require 'rubygems'
require 'inline'


module Object2module
    VERSION = "0.1.0"
end    

class Object
  inline do |builder|
    builder.prefix %{
      #define KLASS_OF(o) RCLASS(RBASIC(o)->klass)
      #define SUPER(o) RCLASS(o)->super

        VALUE
        j_class_new(VALUE module, VALUE sup) {


            NEWOBJ(klass, struct RClass);
            OBJSETUP(klass, rb_cClass, T_ICLASS);

            if (BUILTIN_TYPE(module) == T_ICLASS) {
                module = RBASIC(module)->klass;
            }

            if (!RCLASS(module)->iv_tbl) {

                RCLASS(module)->iv_tbl = (struct st_table *)st_init_numtable();
            }

            /* assign iv_tbl, m_tbl and super */
            klass->iv_tbl = RCLASS(module)->iv_tbl;
            klass->super = sup;
            if(TYPE(module) != T_OBJECT) {

                klass->m_tbl = RCLASS(module)->m_tbl;
            }
            else {
                klass->m_tbl = RCLASS(CLASS_OF(module))->m_tbl;
            }

            /* */

            if (TYPE(module) == T_ICLASS) {
                RBASIC(klass)->klass = RBASIC(module)->klass;
            }
            else {
                RBASIC(klass)->klass = module;
            }


            if(TYPE(module) != T_OBJECT) {
                OBJ_INFECT(klass, module);
                OBJ_INFECT(klass, sup);
            }
            return (VALUE)klass;
        }


    }

    builder.c %{
        VALUE
        object2module() {
            VALUE rclass, chain_start, jcur, klass;

            if(BUILTIN_TYPE(self) == T_CLASS)
                klass = self;
            else if(BUILTIN_TYPE(self) == T_OBJECT)
                klass = rb_singleton_class(self);
            else if(BUILTIN_TYPE(self) == T_MODULE)
                return self;
            else
                return Qnil;
            
            chain_start = j_class_new(klass, rb_cObject);

            RBASIC(chain_start)->klass = rb_cModule;
            RBASIC(chain_start)->flags = T_MODULE;

            jcur = chain_start;
            for(rclass = SUPER(klass); rclass != rb_cObject; rclass = SUPER(rclass)) {
                RCLASS(jcur)->super = j_class_new(rclass, rb_cObject);
                jcur = SUPER(jcur);
            }

            SUPER(jcur) = (VALUE)NULL;

            return chain_start;
        }
    }
  end
                        
  def gen_extend(*objs)
      extend(*objs.map { |o| o.object2module })
  end
  
end

class Module    
  def gen_include(*objs)
      include(*objs.map { |o| o.object2module })
  end
end

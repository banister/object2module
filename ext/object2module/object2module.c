/* object2module.c */
/* (C) John Mair 2009
 * This program is distributed under the terms of the MIT License
 *                                                                */

#include <ruby.h>
#include "compat.h"

// also returns true for receiver
static VALUE
is_meta_singleton_of(VALUE self, VALUE obj)
{
  if (self == obj)
    return Qtrue;
  else if (!FL_TEST(self, FL_SINGLETON) && self != obj)
    return Qfalse;
  else {
    VALUE attached = rb_iv_get(self, "__attached__");
    return is_meta_singleton_of(attached, obj);
  }
}
      
static VALUE
include_class_new(VALUE module, VALUE super)
{
  VALUE klass = create_class(T_ICLASS, rb_cClass);

  if (BUILTIN_TYPE(module) == T_ICLASS) {

    /* for include_complete compat */
    if (!NIL_P(rb_iv_get(module, "__module__")))
      module = rb_iv_get(module, "__module__");
    else
      module = RBASIC(module)->klass;
  }

  if (!RCLASS_IV_TBL(module)) {
    RCLASS_IV_TBL(module) = st_init_numtable();
  }
  RCLASS_IV_TBL(klass) = RCLASS_IV_TBL(module);
  RCLASS_M_TBL(klass) = RCLASS_M_TBL(module);
  RCLASS_SUPER(klass) = super;
  if (TYPE(module) == T_ICLASS) {
    RBASIC(klass)->klass = RBASIC(module)->klass;
  }
  else {
    RBASIC(klass)->klass = module;
  }

  OBJ_INFECT(klass, module);
  OBJ_INFECT(klass, super);

  return (VALUE)klass;
}

VALUE
rb_gen_include_one(VALUE klass, VALUE module)
{
  VALUE p, c;
  int changed = 0;

  rb_frozen_class_p(klass);
  if (!OBJ_UNTRUSTED(klass)) {
    rb_secure(4);
  }

  /* when including an object, include its singleton class */
  if (TYPE(module) == T_OBJECT)
    module = rb_singleton_class(module);
    
  OBJ_INFECT(klass, module);
  c = klass;

  // loop until superclass is 0 (for modules) or superclass is a meta^n singleton of Object (for classes)
  while (module && !is_meta_singleton_of(module, rb_cObject)) {
    int superclass_seen = FALSE;

    if (RCLASS_M_TBL(klass) == RCLASS_M_TBL(module))
      rb_raise(rb_eArgError, "cyclic include detected");
    /* ignore if the module included already in superclasses */
    for (p = RCLASS_SUPER(klass); p; p = RCLASS_SUPER(p)) {
      switch (BUILTIN_TYPE(p)) {
      case T_ICLASS:
        if (RCLASS_M_TBL(p) == RCLASS_M_TBL(module)) {
          if (!superclass_seen) {
            c = p;  /* move insertion point */
          }
          goto skip;
        }
        break;
      case T_CLASS:
        superclass_seen = TRUE;
        break;
      }
    }
    c = RCLASS_SUPER(c) = include_class_new(module, RCLASS_SUPER(c));
    if (RMODULE_M_TBL(module) && RMODULE_M_TBL(module)->num_entries)
      changed = 1;
  skip:
    module = RCLASS_SUPER(module);
  }
  if (changed) rb_clear_cache();

  return Qnil;
}


void
Init_object2module()
{
  VALUE mObject2module = rb_define_module("Object2module");
  VALUE mModuleExtensions = rb_define_module_under(mObject2module, "ModuleExtensions");

  rb_define_method(mModuleExtensions, "gen_include_one", rb_gen_include_one, 1);
}


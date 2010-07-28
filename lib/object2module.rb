direc = File.dirname(__FILE__)

require 'rbconfig'
require "#{direc}/object2module/version"

dlext = Config::CONFIG['DLEXT']

begin
    if RUBY_VERSION && RUBY_VERSION =~ /1.9/
        require "#{direc}/1.9/object2module.#{dlext}"
    else
        require "#{direc}/1.8/object2module.#{dlext}"
    end
rescue LoadError => e
    require "#{direc}/object2module.#{dlext}"
end


# call-seq:
#    obj.gen_extend(other, ...)    => obj

# Adds to _obj_ the instance methods from each object given as a
# parameter.
   
#    class C
#      def hello
#        "Hello from C.\n"
#      end
#    end
   
#    class Klass
#      def hello
#        "Hello from Klass.\n"
#      end
#    end
   
#    k = Klass.new
#    k.hello         #=> "Hello from Klass.\n"
#    k.gen_extend(C)   #=> #<Klass:0x401b3bc8>
#    k.hello         #=> "Hello from C.\n"
class Object
  def gen_extend(*objs)
    raise ArgumentError, "wrong number of arguments (0 for 1)" if objs.empty?

    objs.each { |o|
      begin
        mod = o.__to_module__
        extend(mod)
      ensure
        mod.__reset_tbls__ if mod != o &&o != Object && o != Class && o != Module
      end
    }

    self
  end
end


# call-seq:
#    gen_include(other, ...)    => self

# Adds to the implied receiver the instance methods from each object given as a
# parameter.
   
#    class C
#      def hello
#        "Hello from C.\n"
#      end
#    end
   
#    class Klass
#      gen_include(C)
#    end
   
#    k = Klass.new
#    k.hello         #=> "Hello from C.\n"
class Module
  def gen_include(*objs)
    raise ArgumentError, "wrong number of arguments (0 for 1)" if objs.empty?
    
    objs.each { |o|
      begin
        mod = o.__to_module__
        include(mod)
      ensure
        mod.__reset_tbls__ if mod != o && o != Object && o != Class && o != Module
      end
    }

    self
  end
end

                  
                

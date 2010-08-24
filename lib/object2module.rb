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


class Object
  def __gen_extend_or_include__(extend_or_include, *objs)  #:nodoc:
    raise ArgumentError, "wrong number of arguments (0 for 1)" if objs.empty?

    objs.each { |o|
      begin
        mod = o.__to_module__
        send(extend_or_include, mod)
      ensure
        mod.__reset_tbls__ if mod != o &&o != Object && o != Class && o != Module
      end
    }

    self
  end

  # call-seq:
  #    obj.gen_extend(other, ...)    => obj
  #
  # Adds to _obj_ the instance methods from each object given as a
  # parameter.
  #   
  #    class C
  #      def hello
  #        "Hello from C.\n"
  #      end
  #    end
  #   
  #    class Klass
  #      def hello
  #        "Hello from Klass.\n"
  #      end
  #    end
  #   
  #    k = Klass.new
  #    k.hello         #=> "Hello from Klass.\n"
  #    k.gen_extend(C)   #=> #<Klass:0x401b3bc8>
  #    k.hello         #=> "Hello from C.\n"
  def gen_extend(*objs)
    __gen_extend_or_include__(:extend, *objs)
  end
end

class Module
  
  # call-seq:
  #    gen_include(other, ...)    => self
  #
  # Adds to the implied receiver the instance methods from each object given as a
  # parameter.
  #   
  #    class C
  #      def hello
  #        "Hello from C.\n"
  #      end
  #    end
  #   
  #    class Klass
  #      gen_include(C)
  #    end
  #   
  #    k = Klass.new
  #    k.hello         #=> "Hello from C.\n"
  def gen_include(*objs)
    __gen_extend_or_include__(:include, *objs)
  end
end

                  
                

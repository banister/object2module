direc = File.dirname(__FILE__)
dlext = Config::CONFIG['DLEXT']

require "#{direc}/object2module/version"

begin
  if RUBY_VERSION && RUBY_VERSION =~ /1.9/
    require "#{direc}/1.9/object2module"
  else
    require "#{direc}/1.8/object2module"
  end
rescue LoadError => e
  require 'rbconfig'
  require "#{direc}/object2module.#{dlext}"
end

module Kernel

  # define a `singleton_class` method for the 1.8 kids
  # @return [Class] The singleton class of the receiver
  def singleton_class
    class << self; self; end
  end if !respond_to?(:singleton_class)
end

module Object2module
  module ObjectExtensions
    def __gen_extend_or_include__(extend_or_include, *objs)  #:nodoc:
      raise ArgumentError, "wrong number of arguments (at least 1)" if objs.empty?

      objs.reverse.each { |mod|
        send(extend_or_include, mod)
      }

      self
    end

    # Adds to the singleton class of receiver the instance methods from each object given as a
    # parameter.
    # 
    # @param [Array] objs The array of objects to `gen_extend`
    # @return [Object] The receiver
    # @example  
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
      singleton_class.__gen_extend_or_include__(:gen_include_one, *objs)
    end
  end
  
  module ModuleExtensions

    # Adds to the implied receiver the instance methods from each object given as a
    # parameter.
    # 
    # @param [Array] objs The array of objects to `gen_include`
    # @return [Object] The receiver
    # @example  
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
      __gen_extend_or_include__(:gen_include_one, *objs)
    end
  end
end

class Object
  include Object2module::ObjectExtensions
end

class Module
  include Object2module::ModuleExtensions
end


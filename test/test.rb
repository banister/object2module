direc = File.dirname(__FILE__)
require 'rubygems'
require 'bacon'
require "#{direc}/../lib/object2module"

class Module
  public :include, :remove_const
end

puts "testing Object2module version #{Object2module::VERSION}..."

describe Object2module do
  before do
    class A
      def a
        :a
      end
    end

    class B
      def b
        :b
      end
    end

    module M
      def m
        :m
      end
    end

    O = Object.new
    class << O
      def o
        :o
      end
    end

    C = Class.new
  end

  after do
    Object.remove_const(:A)
    Object.remove_const(:B)
    Object.remove_const(:C)
    Object.remove_const(:M)
    Object.remove_const(:O)
  end

  describe 'gen_include' do
    it 'includes a module' do
      C.gen_include M
      C.new.m.should == :m
    end

    it 'includes a class' do
      C.gen_include A
      C.new.a.should == :a
    end

    it 'includes an object' do
      C.gen_include O
      C.new.o.should == :o
    end

    it 'includes a class that includes a class' do
      A.gen_include B
      C.gen_include A
      C.new.b.should == :b
      C.new.a.should == :a
    end

    it 'includes an object that includes a class that includes a class' do
      A.gen_include B
      O.gen_extend A
      C.gen_include O
      C.new.o.should == :o
      C.new.a.should == :a
      C.new.b.should == :b
    end

    it 'includes an object that includes an object' do
      n = Object.new
      class << n
        def n
          :n
        end
      end

      l = Object.new
      class << l
        def l
          :l
        end
        self
      end.gen_include n

      C.gen_include l
      C.new.l.should == :l
      C.new.n.should == :n
    end
  end

  describe 'gen_extend' do
    it 'extends a module' do
      O.gen_extend M
      O.m.should == :m
    end

    it 'extends a class' do
      O.gen_extend A
      O.a.should == :a
    end

    it 'extends an object' do
      n = Object.new
      class << n
        def n
          :n
        end
      end
      O.gen_extend n
      O.n.should == :n
    end

    it 'extends a class that includes a class' do
      A.gen_include B
      O.gen_extend A
      O.b.should == :b
      O.a.should == :a
    end

    it 'extends an object that includes a class that includes a class' do
      A.gen_include B
      C.gen_include A
      O.gen_extend C
      O.o.should == :o
      O.a.should == :a
      O.b.should == :b
    end

    it 'extends an object that extends an object' do
      n = Object.new
      class << n
        def n
          :n
        end
      end

      l = Object.new
      class << l
        def l
          :l
        end
        self
      end

      l.gen_extend n

      O.gen_extend l
      O.l.should == :l
      O.n.should == :n
    end    
  end
end
      

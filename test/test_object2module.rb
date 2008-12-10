require 'test/unit'
require '../lib/object2module'

module M
  def m
      "m"
  end
end

class A
  include M

  def a
      "a"
  end
end

class B < A
  def b
      "b"
  end
end

class C < B
  def c
      "c"
  end
end

# stand-alone class
class K
    def k
        "k"
    end
end

# another stand-alone class
class J
    def j
        "j"
    end
end

class Object2ModuleTest < Test::Unit::TestCase
  def test_class_to_module
    assert_instance_of(Module, C.object2module)    
  end

  def test_class_heirarchy
    h = C.object2module.ancestors
    assert_equal(B, h[1])
    assert_equal(A, h[2])
    assert_equal(M, h[3])
  end

  def test_class_extend
    h = C.object2module
    o = Object.new
    assert_equal(o, o.extend(h))
  end

  def test_class_extended_methods
    h = C.object2module
    o = Object.new
    o.extend(h)
    assert_equal("a", o.a)
    assert_equal("b", o.b)
    assert_equal("c", o.c)
    assert_equal("m", o.m)
  end                                                       

  def test_object_to_module
    o = C.new
    assert_instance_of(Module, o.object2module)    

  end

  def test_object_heirarchy                                  
    o = C.new
    h = o.object2module.ancestors                           
    assert_equal(C, h[1])                                   
    assert_equal(B, h[2])                                   
    assert_equal(A, h[3])                                   
    assert_equal(M, h[4])                                  
  end                                                       
                                                            
  def test_object_extend                                           
    h = C.object2module                                     
    o = Object.new                                          
    assert_equal(o, o.extend(h))                            
  end                                                       
                                                            
  def test_object_extended_methods                                 
    o = C.new
    h = o.object2module                                     
    l = Object.new                                          
    l.extend(h)                                             
    assert_equal("a", l.a)                                        
    assert_equal("b", l.b)                                        
    assert_equal("c", l.c)                                        
    assert_equal("m", l.m)                                        
  end    
  
  def test_gen_extend
      o = Object.new
      o.gen_extend(C)
      assert_equal("a", o.a)                                        
      assert_equal("b", o.b)                                        
      assert_equal("c", o.c)                                        
      assert_equal("m", o.m)  
  end

  def test_gen_include
      k = Class.new
      k.gen_include(C)
      o = k.new
      assert_equal("a", o.a)                                        
      assert_equal("b", o.b)                                        
      assert_equal("c", o.c)                                        
      assert_equal("m", o.m)  
  end

  def test_gen_extend_multi
      o = Object.new
      o.gen_extend(C, K, J)
      assert_equal("a", o.a)                                        
      assert_equal("b", o.b)                                        
      assert_equal("c", o.c)                                        
      assert_equal("m", o.m)
      assert_equal("k", o.k)
      assert_equal("j", o.j)
  end

  def test_gen_include_multi
      k = Class.new
      k.gen_include(C, K, J)
      o = k.new
      assert_equal("a", o.a)                                        
      assert_equal("b", o.b)                                        
      assert_equal("c", o.c)                                        
      assert_equal("m", o.m)
      assert_equal("k", o.k)
      assert_equal("j", o.j)
  end
end                                        

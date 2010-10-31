require '../lib/object2module'

80_000.times {
  Object.new.gen_extend Object.new, Module.new, Class.new
  Class.new.gen_include Object.new, Module.new, Class.new
}

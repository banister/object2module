 # Rakefile added by John Mair (banisterfiend)

 require 'rake/gempackagetask'
 require 'rake/rdoctask'
require 'rake/clean'
require 'lib/object2module/version.rb'

dlext = Config::CONFIG['DLEXT']

CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~", "ext/**/*#*", "ext/**/.obj", "ext/**/.def", "ext/**/.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")


def apply_spec_defaults(s)
  s.name = "object2module"
  s.summary = "object2module enables ruby classes and objects to be used as modules"
  s.description = s.summary
  s.version = Object2module::VERSION
  s.author = "John Mair (banisterfiend)"
  s.email = 'jrmair@gmail.com'
  s.has_rdoc = true
  s.date = Time.now.strftime '%Y-%m-%d'
  s.require_path = 'lib'
  s.homepage = "http://banisterfiend.wordpress.com"
end


# common tasks
task :compile => :clean

spec = Gem::Specification.new do |s|
  apply_spec_defaults(s)        
  s.platform = 'i386-mingw32'
  s.files = ["Rakefile", "README", "LICENSE",
  "lib/object2module.rb", "lib/1.8/object2module.#{dlext}",
  "lib/1.9/object2module.#{dlext}", "lib/object2module/version.rb", "test/test_object2module.rb"] 
end





# spec = Gem::Specification.new do |s|
#   apply_spec_defaults(s)
#   s.platform = Gem::Platform::RUBY
#   s.extensions = FileList["ext/**/extconf.rb"]
#   s.files = ["Rakefile", "README", "LICENSE", "lib/object2module.rb", "lib/object2module/version.rb", "test/test_object2module.rb"] +
#     FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c"].to_a
# end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end


Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/object2module.rb")
end

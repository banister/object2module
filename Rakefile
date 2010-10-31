# Rakefile added by John Mair (banisterfiend)

require 'rake/gempackagetask'
require 'rake/clean'
require './lib/object2module/version.rb'

dlext = Config::CONFIG['DLEXT']
direc = File.dirname(__FILE__)

CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~", "ext/**/*#*", "ext/**/.obj", "ext/**/.def", "ext/**/.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")

def apply_spec_defaults(s)
  s.name = "object2module"
  s.summary = "object2module enables ruby classes and objects to be used as modules"
  s.description = s.summary
  s.version = Object2module::VERSION
  s.author = "John Mair (banisterfiend)"
  s.email = 'jrmair@gmail.com'
  s.has_rdoc = 'yard'
  s.date = Time.now.strftime '%Y-%m-%d'
  s.require_path = 'lib'
  s.homepage = "http://banisterfiend.wordpress.com"
  s.files = FileList["Rakefile", "README.markdown", "LICENSE",
                     "lib/**/*.rb", "test/**/*.rb", "ext/**/extconf.rb",
                     "ext/**/*.h", "ext/**/*.c"].to_a
  
end

task :test do
  sh "bacon -k #{direc}/test/test.rb"
end

[:mingw32, :mswin32].each do |v|
  task v do
    spec = Gem::Specification.new do |s|
      apply_spec_defaults(s)        
      s.platform = "i386-#{v}"
      s.files += FileList["lib/**/*.#{dlext}"].to_a
    end

    Rake::GemPackageTask.new(spec) do |pkg|
      pkg.need_zip = false
      pkg.need_tar = false
    end

    Rake::Task[:gem].invoke
  end
end

task :ruby do
  spec = Gem::Specification.new do |s|
    apply_spec_defaults(s)        
    s.platform = Gem::Platform::RUBY
    s.extensions = ["ext/object2module/extconf.rb"]
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
  end

  Rake::Task[:gem].invoke
end


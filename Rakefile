# Rakefile added by John Mair (banisterfiend)

require 'rake/gempackagetask'
require 'rake/clean'
require './lib/object2module/version.rb'

dlext = Config::CONFIG['DLEXT']
direc = File.dirname(__FILE__)

CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")
CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~",
              "ext/**/*#*", "ext/**/.obj", "ext/**/.def",
              "ext/**/.pdb", "*flymake*", "*flymake*.*")
                
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
  s.files = Dir["Rakefile", "README.markdown", "LICENSE",
                     "lib/**/*.rb", "test/**/*.rb", "ext/**/extconf.rb",
                     "ext/**/*.h", "ext/**/*.c"]
  
end

task :test do
  sh "bacon -k #{direc}/test/test.rb"
end

[:mingw32, :mswin32].each do |v|
  namespace v do
    spec = Gem::Specification.new do |s|
      apply_spec_defaults(s)        
      s.platform = "i386-#{v}"
      s.files += Dir["lib/**/*.#{dlext}"]
    end

    Rake::GemPackageTask.new(spec) do |pkg|
      pkg.need_zip = false
      pkg.need_tar = false
    end

    task :gem => :clean
  end
end

namespace :ruby do
  spec = Gem::Specification.new do |s|
    apply_spec_defaults(s)        
    s.platform = Gem::Platform::RUBY
    s.extensions = ["ext/object2module/extconf.rb"]
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
  end

  task :gem => :clean
end

directories = ["#{direc}/lib/1.8", "#{direc}/lib/1.9"]
directories.each { |d| directory d }

desc "build the 1.8 and 1.9 binaries from source and copy to lib/"
task :compile => [:clobber, *directories] do
  build_for = proc do |pik_ver, ver|
    sh %{ \
          c:\\devkit\\devkitvars.bat && \
          pik #{pik_ver} && \
          ruby extconf.rb && \
          make clean && \
          make && \
          cp *.so #{direc}/lib/#{ver} \
        }
  end
  
  chdir("#{direc}/ext/object2module") do
    build_for.call("187", "1.8")
    build_for.call("192", "1.9")
  end
end

desc "build all platform gems at once"
task :gems => [:clean, :rmgems, "mingw32:gem", "mswin32:gem", "ruby:gem"]

desc "remove all platform gems"
task :rmgems => ["ruby:clobber_package"]

desc "build and push latest gems"
task :pushgems => :gems do
  chdir("#{direc}/pkg") do
    Dir["*.gem"].each do |gemfile|
      sh "gem push #{gemfile}"
    end
  end
end

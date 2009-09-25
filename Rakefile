require 'rake/clean'

OBJECT2MODULE_VERSION = "0.2.0"

$dlext = Config::CONFIG['DLEXT']

CLEAN.include("ext/*.#{$dlext}", "ext/*.log", "ext/*.o", "ext/*~", "ext/*#*", "ext/*.obj", "ext/*.def", "ext/*.pdb")
CLOBBER.include("**/*.#{$dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")

$make_program = if RUBY_PLATFORM =~ /win/ 
                    "nmake"
                else
                    "make"
                end

task :default => [:build]

desc "Build Object2module"
task :build => :clean do
    chdir("./ext/") do
        ruby "extconf.rb"
        sh "#{$make_program}"
        cp "cobject2module.#{$dlext}", "../lib" , :verbose => true

        if RUBY_PLATFORM =~ /mswin/
            if RUBY_VERSION =~ /1.9/
                File.rename("../lib/cobject2module.#{$dlext}",
                            "../lib/cobject2module.19.#{$dlext}")
            else
                File.rename("../lib/cobject2module.#{$dlext}",
                            "../lib/cobject2module.18.#{$dlext}")
            end
        end
    end
end

require 'rake/gempackagetask'
specification = Gem::Specification.new do |s|
    s.name = "object2module"
    s.summary = "object2module enables ruby classes and objects to be used as modules"
    s.version = OBJECT2MODULE_VERSION
    s.date = Time.now.strftime '%Y-%m-%d'
    s.author = "John Mair (banisterfiend)"
    s.email = 'jrmair@gmail.com'
    s.description = s.summary
    s.require_path = 'lib'
    s.homepage = "http://banisterfiend.wordpress.com"
    s.has_rdoc = true
    s.extra_rdoc_files = ["README.rdoc", "ext/object2module.c"]
    s.rdoc_options << '--main' << 'README.rdoc'
    s.files =  ["Rakefile", "lib/object2module.rb", "README.rdoc"] +
        FileList["ext/*.c", "ext/*.h", "ext/*.rb", "test/*.rb"].to_a

    if RUBY_PLATFORM =~ /mswin/
        s.platform = Gem::Platform::CURRENT
        s.files += ["lib/cobject2module.18.so", "lib/cobject2module.19.so"]
        
    else
        s.platform = Gem::Platform::RUBY
        s.extensions = ["ext/extconf.rb"]
    end
end

# gem, rdoc, and test tasks below

Rake::GemPackageTask.new(specification) do |package|
    package.need_zip = false
    package.need_tar = false
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "ext/*.c")
end

require 'rake/testtask'
Rake::TestTask.new do |t|
    t.libs << "lib"
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
end




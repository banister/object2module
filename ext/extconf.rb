require 'mkmf'

# 1.9 compatibility
$CPPFLAGS += " -DRUBY_19" if RUBY_VERSION =~ /1.9/

create_makefile('cobject2module')

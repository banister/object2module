Object2module
=============

(C) John Mair (banisterfiend) 2010

_Enables Classes and Objects to be mixed into ancestor chains_

Using Object2module you can treat classes and object (their singletons, anyway) as if they were modules and include or extend them into ancestor chains.

Object2module provides the `gen_include` and `gen_extend` methods which are generalizations of the traditional `include` and `extend`.

* Install the [gem](https://rubygems.org/gems/object2module): `gem install object2module`
* Read the [documentation](http://rdoc.info/github/banister/object2module/master/file/README.markdown)
* See the [source code](http://github.com/banister/object2module)

example: gen_include()
--------------------------

Using `gen_include` we can include a class into another class:


    class C
      def hello
        :hello
      end
    end

    class D
      gen_include C
    end

    D.new.hello #=> :hello
    D.ancestors #=> [D, C, Object, ...]
    
example: gen_extend()
--------------------

`gen_extend` lets us mix objects into objects:

    o = Object.new
    class << o
      def bye
        :bye
      end
    end

    n = Object.new
    n.gen_extend o
    n.bye #=> :bye
    
How it works
--------------

Object2module simply removes the check for `T_MODULE` from `rb_include_module()`

Companion Libraries
--------------------

Object2module is one of a series of experimental libraries that mess with
the internals of Ruby to bring new and interesting functionality to
the language, see also:

* [Remix](http://github.com/banister/remix) - Makes ancestor chains read/write
* [Include Complete](http://github.com/banister/include_complete) - Brings in
  module singleton classes during an include. No more ugly ClassMethods and included() hook hacks.
* [Prepend](http://github.com/banister/prepend) - Prepends modules in front of a class; so method lookup starts with the module
* [GenEval](http://github.com/banister/gen_eval) - A strange new breed of instance_eval

Contact
-------

Problems or questions contact me at [github](http://github.com/banister)




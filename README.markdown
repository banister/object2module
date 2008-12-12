Object2module
=============

* converts a Class (or the Singleton of an Object) to a Module
* Includes gen\_extend and gen_include methods: generalizations of Object#extend and Module#include that work with
  Objects and Classes as well as Modules

How it works:
* First creates an IClass for the Class in question and sets the T_MODULE flag 
* Recursively coverts superclasses of the Class to IClasses creating a modulified version of the Class's inheritance chain
* gen\_include/gen\_extend automatically call #object2module on the Class/Object before inclusion/extension.
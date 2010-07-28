/* object2module.h */

#ifndef GUARD_OBJECT2MODULE_H
#define GUARD_OBJECT2MODULE_H
        
VALUE rb_to_module(VALUE self);
VALUE reset_tbls(VALUE self);
void Init_object2module(void);

#endif

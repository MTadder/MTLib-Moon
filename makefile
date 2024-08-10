#!/usr/bin/make -f

ifdef OS
   RM = del /Q
   FixPath = $(subst /,\,$1)
else
   ifeq ($(shell uname), Linux)
      RM = rm -f
      FixPath = $1
   endif
endif

default: compile

clean:
	$(RM) $(call FixPath,mtlib/*.lua)
	$(RM) $(call FixPath,*.lua)


compile:
	@ echo compiling MTLib...
	@ moonc mtlib/*.moon
	@ moonc mtlib.moon

test: compile
	@ moon test.moon

debug:
	@ moon debug.moon
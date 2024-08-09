#!/usr/bin/make -f

default: clean moon

clean:
	@ rm mtlib.lua -fv
	@ rm mtlib/*.lua -fv

moon:
	@ echo compiling MTLib...
	@ moonc mtlib/*.moon
	@ moonc mtlib.moon

test: clean moon
	@ moonc test.moon
	@ lua test.lua

debug:
	@ moonc debug.moon
	@ lua debug.lua
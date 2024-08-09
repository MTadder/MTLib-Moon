#!/usr/bin/make -f

default: clean moon

clean:
	@ rm mtlibrary.lua -fv
	@ rm mtlib/*.lua -fv

moon:
	@ echo compiling MTLib...
	@ moonc mtlib/*.moon
	@ moonc mtlib.moon
	@ echo Done.

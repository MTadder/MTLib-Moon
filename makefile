#!/usr/bin/make -f

default: clean moon

clean:
	@ rm mtlibrary.lua -fv

moon:
	@ echo Compiling MTLibrary...
	@ 	moonc mtlibrary.moon
	@ echo Done.

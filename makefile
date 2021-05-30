#!/usr/bin/make -f

default: clean bust moon

clean:
	@ rm mtlibrary.lua -fv

bust:
	@ echo Busting MTLibrary...
	@ 	busted mtlibrary.moon
	@ echo Done.

moon:
	@ echo Compiling MTLibrary...
	@ 	moonc mtlibrary.moon
	@ echo Done.

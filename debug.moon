export mtlib = require [[mtlib]]
serial = mtlib.string.serialize
print serial(mtlib._NAME) .. serial(mtlib._VERSION) .. serial(mtlib._VERSION_NAME)
print("\ttype `cont` to exit the Lua debugger.")
do debug.debug!
(nil)
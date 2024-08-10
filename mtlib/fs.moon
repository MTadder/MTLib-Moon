-- Filesystem Utilities

fileExists =(filename)->
	ioF = io.open(filename, 'r+')
	result = (ioF != nil)
	if result then ioF\close!
	(result)
fileLines =(filename)->
	if not(fileExists filename) then return {}
	([line for line in io.lines(filename)])
class FileGenerator
	new: (file_name, mode)=>
		assert(file_name, "no file name")
		@file_name = file_name
		@file_stream = io.open(file_name, mode or 'rw')
		(@)
	isValid:=> (@file_stream != nil)
	exists:=>
		assert(@file_name, "no file name")
		(fileExists(@file_name))
	write: (data)=>
		assert(data, "no data for write")
		assert(@isValid!, "invalid file stream")
		@file_stream\write data
		(@)
	read: (what)=>
		assert(@isValid!, "invalid file stream")
		(@file_stream\read (what or "*all"))
	close:=>
		if @isValid! then @file_stream\close!
		(@)
{
    :fileLines
    :fileExists
    generators: {
		:FileGenerator
	}
}
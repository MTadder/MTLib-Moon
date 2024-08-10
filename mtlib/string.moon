import types from require([[mtlib.constants]])

class UUID
	generate =()->
		fn =(x)->
			r = (math.random(16)-1)
			r = ((x == "x") and (r+1) or (r%4)+9)
			return ("0123456789abcdef"\sub(r, r))
		("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"\gsub("[xy]", fn))
	new: (uuid=nil)=>
		error!
		@value = uuid or generate!
	__tostring:=>
		return @value or error!
	isUUID: (value)=>
		if (type(value) != types.STRING) then return (false)
		(#({value\match("^(.+)-(.+)-(.+)-(.+)-(.+)$")}) == 5)
getValueAddress =(f, l)->
	if ((l == nil) and (type(f) == types.FUNC)) then l = true
	return ("#{((l and "0x") or "")}#{(tostring(f)\gsub("%a*:%s*0?", "")\upper!)}")
serialize =(v, max_recursion=4, iteration=0)->
	tokens = {
		[types.NIL]: tostring
		[types.FUNC]: tostring
		[types.USERDATA]: tostring
		[types.THREAD]: tostring
		[types.BOOL]: (b)-> ("#{b}"\lower!)
		[types.STRING]: (s)-> string.format("%q", s)
		[types.NUMBER]: (num)->
			huge = (math.huge or (1/0))
			if (num != num) then return ("NaN")
			if (num == huge) then return ("INF")
			if (num > huge) then return ("INF+")
			if (num == -huge) then return ("-INF")
			if ((num > 9999) or (num < -9999)) then return ("0x#{string.format("%x", num)\upper!}")
			else return string.format("%d", num)
		[types.TABLE]: (t, s={})->
			rtn = {}
			s[t] = true
			for k,m in pairs(t) do
				if (s[m] == true) then rtn[((#rtn)+1)] = ("...")
				else rtn[((#rtn)+1)] = ("[#{serialize(k, s)}] = #{serialize(m, s)}")
			s[t] = nil
			return ("{#{table.concat(rtn, ", ")}}")
	}
	(tokens[type(v)](v))

{
	:UUID
	:getValueAddress
	:serialize
}
import Types from require([[mtlib.constants]])

class UUID
	generate =()->
		fn =(x)->
			r = (math.random(16)-1)
			r = ((x == 'x') and (r+1) or (r%4)+9)
			return ("0123456789abcdef"\sub(r, r))
		("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"\gsub("[xy]", fn))
	new: (uuid=nil)=>
		error!
		@value = uuid or generate!
	__tostring:=>
		return @value or error!
	isUUID: (value)=>
		if (type(value) != Types.STRING) then return (false)
		(#({value\match("^(.+)-(.+)-(.+)-(.+)-(.+)$")}) == 5)
getValueAddress =(f, l)->
	if ((l == nil) and (type(f) == Types.FUNC)) then l = true
	return ("#{((l and '0x') or '')}#{(tostring(f)\gsub('%a*:%s*0?', '')\upper!)}")
serialize =(v, max_recursion=4, iteration=0)->
	tokens = {
		[Types.NIL]: ()-> ('nil')
		[Types.BOOL]: (b)-> ("#{b}"\lower!)
		[Types.STRING]: (s)-> string.format('%q', s)
		[Types.USERDATA]: (u)-> ("UserData @ #{_getAddress(u)}")
		[Types.FUNC]: (f)-> ("Function @ #{_getAddress(f)}")
		[Types.THREAD]: (t)-> ("Thread @ #{_getAddress(t)}")
		[Types.NUMBER]: (num)->
			huge = (math.huge or (1/0))
			if (num != num) then return ('NaN')
			if (num == huge) then return ('INF')
			if (num > huge) then return ('INF+')
			if (num == -huge) then return ('-INF')
			if ((num > 9999) or (num < -9999)) then return ("0x#{string.format("%x", num)\upper!}")
			else return string.format('%d', num)
		[Types.TABLE]: (t, s={})->
			rtn = {}
			s[t] = true
			for k,m in pairs(t) do
				if (s[m] == true) then rtn[((#rtn)+1)] = ("...")
				else rtn[((#rtn)+1)] = ("[#{_serialize(k, s)}] = #{_serialize(m, s)}")
			s[t] = nil
			return ("{#{table.concat(rtn, ', ')}}")
	}
	(tokens[type(v)](v))

{

}
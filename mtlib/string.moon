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
serialize =(what, depth=0, seen={})->
	tokens = {
		[types.NIL]: tostring
		[types.FUNC]: tostring
		[types.USERDATA]: tostring
		[types.THREAD]: tostring
		[types.BOOL]: tostring
		[types.STRING]: (s)-> string.format("%q", s)
		[types.NUMBER]: (num)-> string.format("%d", num)
		[types.TABLE]: (t)->
			rtn = {}
			seen[t] = true
			depth += 1
			--lines = for k,v in pairs what
			--	(" ")\rep(depth*4).."["..tostring(k).."] = "..serialize(v, depth, seen)
			tab = (" ")\rep(depth*4)
			for k,m in pairs(t) do
				if (seen[m] == true) then
					rtn[(#rtn)+1] = (tab.."recursion(#{tostring m})\n")
				else
					rtn[(#rtn)+1] = (tab.."[#{tostring k}] = #{serialize(m, depth, seen)}\n")
			seen[t] = false
			class_id = if what.__class then "class " else ""
			return (class_id.."{\n#{table.concat(rtn, "")}\n#{(" ")\rep((depth - 1)*4)}}")
	}
	(tokens[type(what)](what, seen))

{
	:UUID
	:getValueAddress
	:serialize
}
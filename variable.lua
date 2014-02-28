--[[
Params:
	getVP(STRING variableName, TABLE parentTable)
	getV(STRING variableName, TABLE parentTable)
	setV(STRING variableName, ANY value, TABLE parentTable)
]]
function getVP(s,t)
	local t = t or _G
	for k, d in s:gmatch'([^%.]+)(%.?)' do
		if '.' ~= d then
			return t, k
		end
		t = t[k]
	end
end
function getV(s,t)
	local p,k = getVP(s,t)
	if p then return p[k] end
end
function setV(s,v,t)
	local p,k = getVP(s,t)
	if p then p[k]=v end
end

--[[ Example ]]

mytable = {}
setV('mytable.childtable', { 7, a=5 })
assert(type(mytable.childtable) == 'table')
assert(getVP('mytable.childtable') == mytable)
assert(getV('mytable.childtable.a') == 5)
assert(getV('mytable.childtable.b.1') == nil) -- mytable.childtable.b['1']

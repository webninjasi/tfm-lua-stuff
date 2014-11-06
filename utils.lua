---
-- Utils
---

--- Alias for tfm.exec, keep it at the top of script
local TFM = tfm.exec

--- Get player table from name
-- @param name Name of the player. Must be string.
-- @param search Optional. Case-insensitive search.
-- @return Table of the player in tfm.get.room.playerList.
function getPlayer(name, search)
	local player = tfm.get.room.playerList[name]
	if not player and check then
		local name = name:lower()
		for n,p in pairs(tfm.get.room.playerList) do
			if n:lower() == name then
				player = p
				break
			end
		end
	end
	return player
end

--- Bind a key for both up and down states
-- @param name Name of the player. Must be string.
-- @param key Key to bind. Must be number.
function listenKey(name, key)
	TFM.bindKeyboard(name, key, true, true)
	TFM.bindKeyboard(name, key, false, true)
end

--- Get parent table of the variable by its name.
-- @param variableName Name of the variable. Must be string.
-- @param rootTable Optional. Must be a table.
-- @return Parent table of the variable.
-- @return The key needed to access the variable from its parent table.
-- @usage
-- myTable = { child = 2 }
-- t, k = getVP("myTable.child")
-- assert(t == myTable)
-- assert(k == "child")
function getVP(s, t)
	local t = t or _G
	for k,d in s:gmatch'([^%.]+)(%.?)' do
		if '.' ~= d then
			return t, k
		end
		t = t[k]
	end
end

--- Get value of the variable by its name.
-- @param variableName Name of the variable. Must be string.
-- @param rootTable Optional. Must be a table.
-- @return Value of the variable.
-- @usage
-- myTable = { child = 2 }
-- assert(getV("myTable.child") == 2)
function getV(s, t)
	local p,k = getVP(s, t)
	if p then
		return p[k]
	end
end

--- Set value of the variable by its name.
-- @param variableName Name of the variable. Must be string.
-- @param value Can be any value.
-- @param rootTable Optional. Must be a table.
-- @usage
-- myTable = {}
-- setV("myTable.child", 2)
-- assert(getV("myTable.child") == 2)
function setV(s, v, t)
	local p,k = getVP(s, t)
	if p then
		p[k] = v
	end
end

--- Get map ID from string
-- @param map Map ID string.
-- @return Map ID as integer.
-- @usage assert(getMID("@123456") == getMID("123456"))
function getMID(s)
	return s and tonumber(s:sub('@' == s:sub(1,1) and 2 or 1))
end

--- Might be useful to set numbers like time etc.
-- @param number Value of the variable before set it.
-- @param value Can be a number to set the variable or an offset like +1, -2.
-- @return If value is an offset, number + offset otherwise value. Converts value to number, if can't convert, returns the number.
-- @usage
-- i = 5
-- i = nSet(i. "+1")
-- assert(i == 6)
function nSet(n, v)
	local s = tostring(v):sub(1,1)
	v = tonumber(v)
	return (v or n) + ((v and s == '+' or '-' == s) and n or 0)
end

--- Real player victory.
-- @param name Name of the player.
-- @usage table.foreach(tfm.get.room.playerList, playerWin)
function playerWin(n)
	TFM.giveCheese(n)
	TFM.playerVictory(n)
end

--- Teleport player or lazarus.
-- @param name Name of the player.
-- @param x X coordinate to teleport.
-- @param y X coordinate to teleport.
-- @usage
-- eventMouse = playerTP
-- table.foreach(tfm.get.room.playerList, system.bindMouse)
function playerTP(n, x, y)
	TFM.respawnPlayer(n)
	TFM.movePlayer(n, x, y)
end

--- Tail optimized unpack function
-- @param table Table to unpack.
-- @param index Optional. Index to start unpacking.
-- @param end Optional. End index for unpacking.
-- @param ... Optional. Values to add at the end of return values.
-- @return Unpacked values from a table.
-- @usage
-- t = { 1, "<p align='center'>Hi", nil, 200, 100, 400, nil, 1, 0, 0.8, true }
-- ui.addTextArea(unpack(t, 1, 11))
function unpack(t, i, l, ...)
	i = i or 1
	l = l or #t
	if i > l then
		return ...
	end
	return unpack(t, i, -1+l, t[l], ...)
end

--- Filter some of html entities.
-- @param str String to filter.
-- @return Filtered string.
function htmlFilter(s)
	s = s:gsub('[&<>]', '') -- gsub returns 2 values
	return s
end

--- Replace some of html entities to safer characters.
-- @param str String to replace.
-- @return Replaced string.
function htmlReplace(s)
	s = s:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;') -- gsub returns 2 values
	return s
end

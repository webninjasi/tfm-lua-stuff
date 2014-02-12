--[[ Macro functions ]]

function getPlayer(name)
	return tfm.get.room.playerList[name]
end

function getPlayer(name, check)
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

function listenKey(name, key)
	tfm.exec.bindKeyboard(name, key, true, true)
	tfm.exec.bindKeyboard(name, key, false, true)
end

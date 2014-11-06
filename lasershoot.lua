---
-- Simple laser shoot effect
---

function laserShoot(x, y, x2, y2, len)
	local dx, dy = x2-x, y2-y
	local d = math.sqrt(dx^2 + dy^2)/20
	for i=0, (len or 20)-1 do
		tfm.exec.displayParticle(13, x+(i*dx/d/10), y+(i*dy/d/10), dx/d, dy/d, 0, 0)
	end
end

--# Example Usage

players = {}
function eventNewPlayer(name)
	players[name] = { keys={} }
	system.bindMouse(name, true)
	listenKey(name, 80)
end
function eventKeyboard(name, key, down)
	players[name].keys[key] = down
end
function eventMouse(name, x, y)
	if players[name].keys[80] then
		local player = getPlayer(name)
		laserShoot(player.x, player.y, x, y)
	end
end
function getPlayer(name)
	return tfm.get.room.playerList[name]
end
function listenKey(name, key)
	tfm.exec.bindKeyboard(name, key, true, true)
	tfm.exec.bindKeyboard(name, key, false, true)
end
for name in pairs(tfm.get.room.playerList) do
	eventNewPlayer(name)
end

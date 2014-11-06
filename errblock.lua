---
-- Error Informer
---
--# Don't forget to add your name to devs table

function sendDevMsg(m)
	local devs={'Transforlays'}
	for i,n in pairs(devs) then
		if tfm.get.room.playerList[n] then
			tfm.exec.chatMessage('<R>[ERR] <BL>'..m:gsub('<','&lt;'),n)
		end
	end
end
do
	local f={}
	local function c(k)
		return function(...)
			local s,m=pcall(f[k],...)
			if not s then sendDevMsg(m) end
		end
	end
	for k,v in pairs(_G) do
		if type(v)=='function' and type(k)=='string' and k:sub(1,5)=='event' then
			f[k]=v
			_G[k]=c(k)
		end
	end
end

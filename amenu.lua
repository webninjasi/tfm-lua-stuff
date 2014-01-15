-- Admin Menu
--[[
While holding P key, click on a mouse to select player
Commands:
	!amenu
	!amenu [name]
	!amenu *
Action format: {'Label',functionName,{'Arg Name','Arg Name'},{'Default Value'}}
]]
players={}
aMenu={
	actions={{'New Map',tfm.exec.newGame,{'Map Code'},{0}},{'Set Time',tfm.exec.setGameTime,{'Time','Init'},{120}},
		{'Add Object',tfm.exec.addShamanObject,{'ID','X','Y','Angle','Speed X','Speed Y','Ghost'},{1,10,10}},{'Remove Object',tfm.exec.removeObject,{'ID'},{2}},
		{'Move Object',tfm.exec.moveObject,{'ID','X','Y','Offset','Speed X','Speed Y','Offset'},{2,10,10}},
		{'Particle',tfm.exec.displayParticle,{'ID','X','Y','Speed X','Speed Y','Acceleration X','Acceleration Y','Target'},{1,10,10,0,0,0,0}},
		{'Explosion',tfm.exec.explosion,{'X','Y','Power','Distance','Mice Only'},{400,200,-100,100}},
		{'Conjuration',tfm.exec.addConjuration,{'X','Y','Time'},{10,10,1e6}},
		'NICK',{'Kill',tfm.exec.killPlayer},{'Give Cheese',tfm.exec.giveCheese},{'Victory',tfm.exec.playerVictory},
		{'Shaman',tfm.exec.setShaman},{'Meep',tfm.exec.giveMeep},{'Vampire',tfm.exec.setVampirePlayer},
		{'Respawn',tfm.exec.respawnPlayer},{'Set Score',tfm.exec.setPlayerScore,{'Score','Add'},{1,true}},
		{'Set Color',tfm.exec.setNameColor,{'Color'},{0}},
		{'Move Player',tfm.exec.movePlayer,{'X','Y','Offset','Speed X','Speed Y','Offset'},{400,200}}},
	text='<R><a href="event:close"><b>Close</b></a><N>',
	nickID=0}
function init()
	for i=1,#aMenu.actions do
		if aMenu.actions[i]=='NICK' then
			aMenu.text=aMenu.text..'\n<V><u>%s</u><J>'
			aMenu.nickID=i
		else
			aMenu.text=aMenu.text..string.format('\n<a href="event:amenu%d">%s</a>',i,aMenu.actions[i][1])
			if aMenu.actions[i][3] then
				aMenu.text=aMenu.text..string.format(' <a href="event:amenup%d">&gt;</a>',i)
			end
		end
	end
	for n in pairs(tfm.get.room.playerList) do
		eventNewPlayer(n)
	end
end
function eventNewPlayer(name)
	players[name]={keys={},aMenu={target=name,pID=0,params={}}}
	system.bindMouse(name,true)
	tfm.exec.bindKeyboard(name,80,true,true)
	tfm.exec.bindKeyboard(name,80,false,true)
end
function eventPlayerLeft(name)
	players[name]=nil
end
function eventChatCommand(name,cmd)
	if isAdmin(name) then
		if cmd=='amenu' then
			eventTextAreaCallback(1,name,'amenu0'..name)
		elseif cmd:sub(1,6)=='amenu ' then
			eventTextAreaCallback(1,name,'amenu0'..cmd:sub(7))
		end
	end
end
function eventKeyboard(name,key,down)
	players[name].keys[key]=down
end
function eventMouse(name,x,y)
	if players[name].keys[80] and isAdmin(name) then
		local pList={}
		for n,p in pairs(tfm.get.room.playerList) do
			if math.abs(p.x-x)<10 and math.abs(p.y-y)<10 then
				table.insert(pList, n)
			end
		end
		if #pList>1 then
			local s='<R><a href="event:close"><b>Close</b></a><V>'
			for i=1,#pList do
				s=s..string.format('\n<a href="event:amenu0%s">%s</a>',pList[i],pList[i])
			end
			local maxy=380-(14*(#pList+1))
			local y=y>maxy and maxy or y
			ui.addTextArea(1,s,name,x,y,nil,nil,1,0,0.7)
		elseif #pList==1 then
			eventTextAreaCallback(1,name,'amenu0'..pList[1])
		end
	end
end
function eventTextAreaCallback(ID,name,callback)
	if callback=='close' then
		ui.removeTextArea(ID,name)
		if ID==2 then
			eventTextAreaCallback(ID,name,'amenup0')
		end
	elseif callback:sub(1,6)=='amenu0' then
		players[name].aMenu.target=callback:sub(7)
		ui.removeTextArea(1,name)
		ui.addTextArea(2,aMenu.text:format(callback:sub(7)),name,10,20,nil,nil,1,0,0.7,true)
	elseif callback:sub(1,6)=='amenup' then
		local aID,pID=tonumber(callback:sub(7)),players[name].aMenu.pID
		if type(aMenu.actions[pID])=='table' and aMenu.actions[pID][3] then
			for i=1,#aMenu.actions[pID][3] do
				ui.addPopup(i,0,'',name,9e5,9e5,1,true)
			end
		end
		if pID==aID then
			players[name].aMenu.pID=0
		else
			if type(aMenu.actions[aID])=='table' and aMenu.actions[aID][3] then
				if not players[name].aMenu.params[aID] then
					players[name].aMenu.params[aID]=aMenu.actions[aID][4] and table.copy(aMenu.actions[aID][4]) or {}
				end
				players[name].aMenu.pID=aID
				for i=1,#aMenu.actions[aID][3] do
					showParamPopup(name,i,aMenu.actions[aID][3][i],players[name].aMenu.params[aID][i])
				end
			end
		end
	elseif callback:sub(1,5)=='amenu' then
		local aID=tonumber(callback:sub(6))
		if type(aMenu.actions[aID])=='table' then
			if aID>aMenu.nickID then
				callPlayerFunction(players[name].aMenu.target,aMenu.actions[aID][2],unpack(players[name].aMenu.params[aID] or aMenu.actions[aID][4] or {}))
			else
				aMenu.actions[aID][2](unpack(players[name].aMenu.params[aID] or aMenu.actions[aID][4] or {}))
			end
		end
	end
end
function eventPopupAnswer(ID,name,answer)
	local aID=players[name].aMenu.pID
	if aMenu.actions[aID] and aMenu.actions[aID][3] and ID>=1 and ID<=#aMenu.actions[aID][3] then
		if answer=='' then
			players[name].aMenu.params[aID][ID]=nil
		else
			players[name].aMenu.params[aID][ID]=answer
		end
		showParamPopup(name,ID,aMenu.actions[aID][3][ID],players[name].aMenu.params[aID][ID])
	end
end
function isAdmin(name)
	return true --name=='Transforcips'
end
function showParamPopup(name,i,key,val)
	ui.addPopup(i,2,string.format('<p align="center"><b>%s:</b> %s',key,tostring(val or '')),name,170+(((i-1)%6)*105),(math.floor((i-1)/6)*75)+20,100,true)
end
function callPlayerFunction(name,func,...)
	if name=='*' then
		for n in pairs(tfm.get.room.playerList) do
			func(n,...)
		end
	else
		func(name,...)
	end
end
function unpack(t,i)
	i = i or 1
	local v = t[i]
	if v ~= nil or #t > i then return v, unpack(t, i+1) end
end
function table.copy(t,d)
	d = d or false
	local rt = {}
	for k, v in pairs(t) do
		if d then
			if type(k) == "table" then
				k = table.copy(k, true)
			end
			if type(v) == "table" then
				v = table.copy(v, true)
			end
		end
		rt[k] = v
	end
	return rt
end
init()

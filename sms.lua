-- Short Message Script
--[[
Inbox message limit: 15
Commands:
	!sms - Shows SMS panel
	!sms [name] - Shows a popup to type message
	!sms [name] message - Sends message to name
	!mute [name] - Mutes the player, the player you specified can't send you message
	!unmute [name] - Unmutes the player
	!fsms [sender] [name] message - Sends fake message
Use or make your own isAdmin and trans functions
]]

langs={
	EN={
		smsPanel='<R><b><a href="event:close">^</a></b> <J>You have <BL><b>%i</b><G>/<R><b>%i</b> <J>messages in your inbox. <R><a href="event:inbox"><b>[Inbox]</b></a>%s',
		smsSuccess='<V>Your message has been sent!',
		smsFail='<R>The player could not be found!',
		smsFail2="<R>The player's inbox is full!",
		smsLimit='<R>Your inbox is full!',
		smsMute="<V>%s <J>is ignored!",
		smsUnmute='<V>%s <J>is unignored!',
		smsFakeMsgOk='<V>Fake message has been sent!',
		smsPopup='Message',
		smsInbox='<R><b><a href="event:close">^</a></b> <J>Inbox<V>',
		smsInboxEmpty='<V>Empty',
		smsInfo=[[<R><p align="right"><b><a href="event:close">X</a></b></p><V><b>Sender:</b> <N>%s
<V><b>Date:</b> <N>%s
<V><b>Message</b><J>
%s
<V><p align="center"><b><a href="event:smsr%s">Answer</a></b>]]
	},
	TR={
		smsPanel='<R><b><a href="event:close">^</a></b> <J>Gelen kutunuzda <BL><b>%i</b><G>/<R><b>%i</b> <J>mesajınız bulunmakta. <R><a href="event:inbox"><b>[Gelen Kutusu]</b></a>%s',
		smsSuccess='<V>Mesajınız alıcıya teslim edildi!',
		smsFail='<R>Oyuncu bulunamadı!',
		smsFail2='<R>Oyuncunun gelen kutusu dolu!',
		smsLimit='<R>Gelen kutunuz doldu!',
		smsMute='<V>%s <J>engellendi!',
		smsUnmute='<V>%s <J>engeli kaldırıldı!',
		smsFakeMsgOk='<V>Sahte mesaj gönderildi!',
		smsPopup='Mesaj',
		smsInbox='<R><b><a href="event:close">^</a></b> <J>Gelen Kutusu<V>',
		smsInboxEmpty='<V>Boş',
		smsInfo=[[<R><p align="right"><b><a href="event:close">X</a></b></p><V><b>Gönderen:</b> <N>%s
<V><b>Tarih:</b> <N>%s
<V><b>Mesaj</b><J>
%s
<V><p align="center"><b><a href="event:smsr%s">Cevapla</a></b>]]
	},
}
players={}
function init()
	for name in pairs(tfm.get.room.playerList) do
		eventNewPlayer(name)
	end
	for _,c in pairs({'sms','fsms'}) do
		system.disableChatCommandDisplay(c, true)
	end
end
function eventNewPlayer(name)
	if not _get(players, name) then
		_set(players, name, {muteList={}, msgs={}, msgc=0})
	end
end
function eventChatCommand(name, cmd)
	local args = {}
	for a in cmd:gmatch('%S+') do args[#args+1] = a end
	local pInfo = _get(players,name)
	if 'sms' == args[1] then
		if args[2] then
			local receiver, msg = args[2], cmd:sub(#args[2]+6)
			if #msg > 0 then
				local rInfo = _get(players, receiver)
				if rInfo then
					if _get(rInfo.muteList, name) then
						updateMsgUI(name, trans('smsFail2',name))
					elseif #rInfo.msgs > 14 then
						updateMsgUI(name, trans('smsFail2',name))
						updateMsgUI(receiver, trans('smsLimit',receiver))
					else
						table.insert(rInfo.msgs, {time=os.date(), sender=name, msg=isAdmin(name) and msg or smsFilter(msg)})
						rInfo.msgc = rInfo.msgc+1
						updateMsgUI(name, trans('smsSuccess',name))
						updateMsgUI(receiver)
					end
				else
					updateMsgUI(name, trans('smsFail',name))
				end
			else
				pInfo.smsr = receiver
				ui.addPopup(8787, 2, trans('smsPopup',name), name, 300, 100, 200, true)
			end
		else
			updateMsgUI(name)
		end
	elseif 'mute ' == cmd:sub(1,5) then
		local who = cmd:sub(6):lower()
		pInfo.muteList[who] = 1
		updateMsgUI(name, trans('smsMute',name):format(smsFilter(who)))
	elseif 'unmute ' == cmd:sub(1,7) then
		local who = cmd:sub(8)
		_set(pInfo.muteList, who, nil)
		updateMsgUI(name, trans('smsUnmute',name):format(smsFilter(who)))
	elseif isAdmin(name) then
		if 'fsms ' == cmd:sub(1,5) then
			local sender,msg = cmd:match('fsms (%S+) (.+)')
			if sender and msg then
				eventChatCommand(sender, 'sms '..msg)
				updateMsgUI(name, trans('smsFakeMsgOk',name))
			end
		end
	end
end
function eventPopupAnswer(ID, name, answer)
	if ID == 8787 then
		local pInfo = _get(players, name)
		if pInfo and pInfo.smsr and #answer > 0 then
			eventChatCommand(name, 'sms '..pInfo.smsr..' '..answer)
		end
	end
end
function eventTextAreaCallback(ID,name,event)
	if event == 'close' then
		ui.removeTextArea(ID, name)
	else
		local pInfo = _get(players, name)
		if pInfo then
			if event == 'inbox' then
				ui.addTextArea(8778, '', name, 450, 20, 330, nil, 1, 0, 0.7, true)
				updateMsgUI(name)
			elseif 'smsd' == event:sub(1,4) then
				local smsID = tonumber(event:sub(5))
				if pInfo.msgs[smsID] then
					if not pInfo.msgs[smsID].ok then
						pInfo.msgc = pInfo.msgc-1
					end
					table.remove(pInfo.msgs, smsID)
					updateMsgUI(name)
				end
			elseif 'smsr' == event:sub(1,4) then
				pInfo.smsr = event:sub(5)
				ui.addPopup(8787, 2, trans('smsPopup',name), name, 300, 100, 200, true)
			elseif 'sms' == event:sub(1,3) then
				local smsID = tonumber(event:sub(4))
				if pInfo.msgs[smsID] then
					local sInfo = pInfo.msgs[smsID]
					ui.addTextArea(7878, trans('smsInfo',name):format(sInfo.sender, sInfo.time, sInfo.msg, sInfo.sender),
						name, 10, 100, 300, nil, 0x000011, 0, 0.7, true)
					if not sInfo.ok then
						pInfo.msgc = pInfo.msgc-1
						sInfo.ok = true
						updateMsgUI(name)
					end
				end
			end
		end
	end
end
function updateMsgUI(name, msg)
	local pInfo = _get(players, name)
	if not pInfo then return end
	ui.addTextArea(7887, trans('smsPanel',name):format(#pInfo.msgs, pInfo.msgc,msg and '\n' .. msg or ''),
		name, 10, 20, nil, nil, 0x110000, 0, 0.7, true)
	local text = trans('smsInbox', name)
	if #pInfo.msgs > 0 then
		for i=1,#pInfo.msgs do
			text = string.format('%s\n[%s] <a href="event:sms%i">%s</a> <G>- <J>%s <R><a href="event:smsd%i">[X]</a><V>', text,
				pInfo.msgs[i].ok and '+' or '-', i, pInfo.msgs[i].sender, pInfo.msgs[i].time, i)
		end
	else
		text = text.."\n"..trans('smsInboxEmpty', name)
	end
	ui.updateTextArea(8778, text, name)
end
function isAdmin(name)
	return true -- name=='Transforcips'
end
function trans(key)
	return langs.EN[key]
	--return langs.TR[key]
end
function _get(t,k)
	return t[k:lower()]
end
function _set(t,k,v)
	t[k:lower()] = v
end
function smsFilter(s)
	return s:gsub('&','&amp;'):gsub('<','&lt;'):gsub('>','&gt;'):gsub('http','ht<c/>tp')
end
init()

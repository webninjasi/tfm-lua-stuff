---
-- Lays' Palette+
---

local LANG = 'EN'
local CLEANER = 'Transforlays'
local help = {
	TR = [[<textformat tabstops="[150]"><R><p align="center"><R>1 ■ <VP>2 ■ <G>3 ■ <font color="#E88F4F">4 ■ <J>5 ■ <V>6 ■ <ROSE>7 ■ <CH>8 ■ <T>9 ■
<p align="left">
<N>Fırça kenar rengin	<font color="#%x">■

<VP>Yön tuşları/Numpad	<N>Fırça kontrolü

<VP>Boşluk/Numpad 0	<N>Sil (Basılı tutabilirsin)

<VP>Ctrl/Numpad 5 	<N>Boya (Basılı tutabilirsin)

<G>!c [renk] 	<N>Renk değiştirme

<G>!! 	<N>Ekranı temizle
<p align="center"><font size="11">
<BL>Oyuncu listesini görmek için <VP>P <BL>tuşuna basılı tut

Bu ekranı görmek için <VP>Shift <BL>tuşuna basılı tut]],
	EN = [[<textformat tabstops="[150]"><R><p align="center"><R>1 ■ <VP>2 ■ <G>3 ■ <font color="#E88F4F">4 ■ <J>5 ■ <V>6 ■ <ROSE>7 ■ <CH>8 ■ <T>9 ■
<p align="left">
<N>Your brush border color	<font color="#%x">■

<VP>Arrow keys/Numpad	<N>Brush control

<VP>Space/Numpad 0	<N>Erase (You can hold it)

<VP>Ctrl/Numpad 5 	<N>Paint (You can hold it)

<G>!c [color] 	<N>Change color

<G>!! 	<N>Clear the screen
<p align="center"><font size="11">
<BL>Hold <VP>P <BL>key to see player list

Hold <VP>Shift <BL>key to make this screen appear]] }
local colors = { 0xCB546B, 0x2ECF73, 0x606090, 0xE88F4F, 0xBABD2F, 0x009D9D, 0xED67EA, 0x98E2EB, 0xA4CF9E }
local colorStr, playerStr = {}, ''
local pixels, brushX, brushY, brushC, brushD, eraserD, brushB, brushI = {}, {}, {}, {}, {}, {}, {}, { -10 }
function init()
	tfm.exec.disableAutoNewGame(true)
	tfm.exec.disableAfkDeath(true)
	tfm.exec.disableAutoShaman(true)
	system.disableChatCommandDisplay('c')
	system.disableChatCommandDisplay('!')

	for i=1, 9 do
		getColorStr(colors[i])
	end
	for n in pairs(tfm.get.room.playerList) do
		eventNewPlayer(n, true)
	end

	makePlayerStr()
	tfm.exec.newGame([[<C><P /><Z><S><S X="400" o="0" L="50" Y="180" H="10" P="0,0,0.3,0.2,0,0,0,0" T="12" /><S X="400" o="0" L="50" Y="220" H="10" P="0,0,0.3,0.2,0,0,0,0" T="12" /><S X="370" o="0" L="10" Y="200" H="50" P="0,0,0.3,0.2,0,0,0,0" T="12" /><S X="430" o="0" L="10" Y="200" H="50" P="0,0,0.3,0.2,0,0,0,0" T="12" /></S><D><DS X="400" Y="200" /></D><O /></Z></C>]])
end
function showHelp(name)
	ui.addTextArea(-2, help[LANG]:format(brushB[name]), name, 250, 100, 300, nil, 1, 1, 0.8, true)
end
function updateBrush(name, x, y)
	if brushI[name] then
		local x, y = (x < 0 and 79 or x), (y < 1 and 38 or y)
		x, y = (x > 79 and 0 or x), (y > 38 and 1 or y)
		brushX[name], brushY[name] = x, y
		ui.addTextArea(brushI[name], '', nil, x*10 + 4, y*10 + 7, 10, 10, brushC[name], brushB[name], 0.5)
	end
end
function getColorStr(c)
	if colorStr[c] == nil then
		colorStr[c] = string.format('<font size="14" font="Verdana" color="#%x">■', c)
	end
	return colorStr[c]
end
function fillBlock(x, y, c)
	if x >= 0 and y > 0 and x < 80 and y < 39 then
		local i = x*79 + y
		if c then
			local c = getColorStr(c)
			ui.addTextArea(i, c, nil, x*10, y*10, nil, nil, 0, 0, 0)
			pixels[i] = c
		else
			ui.removeTextArea(i)
			pixels[i] = nil
		end
	end
end
function makePlayerStr(name)
	if name then
		if #playerStr < 1976 then
			playerStr = string.format('%s<font color="#%x">%s\t■\n', playerStr, brushB[name], name):sub(1,2e3)
		end 
	else
		local s, i = { '<textformat tabstops="[180]"><font size="11" font="Verdana">' }, 2
		for n,c in pairs(brushB) do
			s[i] = string.format('<font color="#%x">%s\t■\n', c, n)
			i = 1 + i
		end
		playerStr = table.concat(s):sub(1, 2e3)
	end
end
function eventNewGame()
	tfm.exec.setUIMapName("Lays' Palette+")
end
function eventNewPlayer(name, init)
	ui.addTextArea(-1, '', name, -100, -100, 1000, 600, 0x6A7495, 0x6A7495, 1)

	if brushI[name] == nil then
		brushI[1] = -1 + brushI[1]
		brushC[name] = colors[math.random(1, 9)]
		brushI[name] = brushI[1]
	end
	brushB[name] = math.random(0xff, 0xff0000)

	updateBrush(name, math.random(20, 60),  math.random(10, 30))
	system.bindMouse(name, true)
	showHelp(name)

	if init == nil then
		makePlayerStr(name)
		eventNewGame()
		for i, c in pairs(pixels) do
			ui.addTextArea(i, c, name, math.floor(i/79) * 10, (i%79) * 10, nil, nil, 0, 0, 0)
		end
		for n, b in pairs(brushB) do
			ui.addTextArea(brushI[n], '', nil, brushX[n]*10 + 4, brushY[n]*10 + 7, 10, 10, brushC[n], b, 0.5)
		end
	end

	for _, key in pairs({ 16, 17, 32, 37, 38, 39, 40, 49, 50, 51, 52, 53, 54, 55, 56, 57, 80, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105 }) do
		tfm.exec.bindKeyboard(name, key, true, true)
	end
	for _, key in pairs({ 16, 17, 32, 80, 96, 101 }) do
		tfm.exec.bindKeyboard(name, key, false, true)
	end
end
function eventPlayerLeft(name)
	ui.removeTextArea(brushI[name])
	brushB[name] = nil
	makePlayerStr()
end
function eventMouse(name, x, y)
	local x, y = math.floor((x-7)/10), math.floor((y-7)/10)
	x = math.min(79, math.max(0, x))
	y = math.min(38, math.max(1, y))
	updateBrush(name, x, y)
	if brushD[name] then
		fillBlock(x, y, brushC[name])
	elseif eraserD[name] then
		fillBlock(x, y)
	end
end
function eventKeyboard(name, key, down)
	local x, y = brushX[name], brushY[name]
	if key == 16 then
		if down then
			showHelp(name)
		else
			ui.removeTextArea(-2, name)
		end
	elseif key == 80 then
		if down then
			ui.addTextArea(-3, playerStr, name, 10, 20, 200, nil, 1, 0, 0.8, true)
		else
			ui.removeTextArea(-3, name)
		end
	elseif key == 17 or key == 101 then
		brushD[name] = down
		if down then
			fillBlock(x, y, brushC[name])
		end
	elseif key == 32 or key == 96 then
		eraserD[name] = down
		if down then
			fillBlock(x, y)
		end
	elseif (key > 36 and key < 41) or (key > 96 and key < 106) then
		if key == 37 or key == 97 or key == 100 or key == 103 then
			x = -1 + x
		elseif key == 39 or key == 99 or key == 102 or key == 105 then
			x = 1 + x
		end
		if key == 38 or key == 103 or key == 104 or key == 105 then
			y = -1 + y
		elseif key == 40 or key == 97 or key == 98 or key == 99 then
			y = 1 + y
		end
		updateBrush(name, x, y)
		if brushD[name] then
			fillBlock(x, y, brushC[name])
		elseif eraserD[name] then
			fillBlock(x, y)
		end
	elseif key > 48 and key < 58 then
		brushC[name] = colors[key - 48]
		updateBrush(name, x, y)
	end
end
function eventChatCommand(name, cmd)
	if '!' == cmd and CLEANER == name then
		local l, n = {}, 0
		for k in pairs(pixels) do
			ui.removeTextArea(k)
			n = 1 + n
			l[n] = k
		end
		for i=1, n do
			pixels[l[i]] = nil
		end
	elseif 'c ' == cmd:sub(1,2) then
		local cl = cmd:sub(3)
		if '#' == cl:sub(1,1) then
			cl = '0x' .. cl:sub(2)
		end
		brushC[name] = tonumber(cl) or brushC[name]
		updateBrush(name, brushX[name], brushY[name])
	end
end
init()

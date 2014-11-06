---
-- 3D Text Effect
--
--[[
Params:
	text, x, y, target, startID, textAreaCount, color, colorAdd, textSize,
	factorX, factorY, width, height, backgroundColor, borderColor, opacity, isFixed
]]

function create3DText(t, x, y, n, si, c, cl, cla, sz, fX, fY, w, h, bg, br, o, f)
	local fX,fY,bg,br,o,f = fX or 1,fY or 1,bg or 1,br or 0,o or 0,f or 1
	local si,c,cl,cla,sz = si or 1,c or 10,cl or 0,cla or 0x101010,sz or 50
	local t = '<font size="'..sz..'" color="#%x">' .. t
	for i=si,si+c do
		ui.addTextArea(i,t:format(cl+(i*cla)),n,x+(fX*i),y+(fX*i),w,h,bg,br,o,f)
	end
end

--# Example
create3DText('Test', 200, 75)

---
-- Matrix Effect
---

matrix={
	char={},
	text={},
	color={},
	length={},
	init=function(t)
		for i=48,57 do
			t.char[#t.char+1]=i
		end
		for i=65,90 do
			t.char[#t.char+1]=i
		end
		for i=97,122 do
			t.char[#t.char+1]=i
		end
		for x=1,53 do
			t.length[x]=math.random(5,30)
			for y=1,t.length[x] do
				t.text[x]=t.text[x] or ''
				t.text[x]=t.text[x]..string.char(table.random(t.char))..'\n'
			end
			t.length[x]=math.max(0,30-t.length[x])
		end
	end,
	createTAs=function(t,name,init)
		ui.addTextArea(1,'',name,-4e3,-4e3,8e3,8e3,1,0,1,1)
		for i=1,#t.text do
			if init then
				t.color[i]=string.format('<font color="#%x">',math.random(100,255)*256)
			end
			ui.addTextArea(1+i,t.color[i]..t.text[i],name,((i-1)*15)+3,0,nil,nil,0,0,0,1)
		end
	end}
function eventLoop()
	for i=1,#matrix.color do
		if matrix.length[i]>1 then
			matrix.text[i]=string.char(table.random(matrix.char))..'\n'..matrix.text[i]
			matrix.length[i]=matrix.length[i]-1
		elseif matrix.length[i]<0 then
			matrix.text[i]=' \n'..matrix.text[i]
			matrix.length[i]=matrix.length[i]+1
		elseif matrix.length[i]==0 then
			matrix.length[i]=math.random(5,30)
		elseif matrix.length[i]==1 then
			matrix.length[i]=-math.random(5,15)
		end
		if #matrix.text[i]>30 then
			matrix.text[i]=matrix.text[i]:sub(1,60)
		end
		ui.updateTextArea(i+1,matrix.color[i]..matrix.text[i])
	end
end
function eventNewPlayer(name)
	matrix:createTAs(name)
end
function table.random(t)
	return t[math.random(#t)]
end
matrix:init()
matrix:createTAs(nil,true)

-- Bus Animation
bus={x=10,y=0,
	color=0xFFD800,color2=0x333333,
	--target='Transforcips',
	wheel={
		state=true,
		text='<p align="center"><font color="#121212" size="44">',
		text2='<font color="#dedede"><p align="center"><font size="70">•',
		text3='<font color="#121212"><p align="center"><font size="100">•'}}
function eventLoop()
	ui.addTextArea(10,'',bus.target,bus.x+20,bus.y+50,300,100,bus.color,bus.color)
	ui.addTextArea(20,'',bus.target,bus.x+270,bus.y+70,50,40,bus.color2,bus.color,0.7)
	ui.addTextArea(32,bus.wheel.text3,bus.target,bus.x+32,bus.y+90,nil,nil,0)
	ui.addTextArea(42,bus.wheel.text3,bus.target,bus.x+230,bus.y+90,nil,nil,0)
	ui.addTextArea(31,bus.wheel.text2,bus.target,bus.x+40,bus.y+110,nil,nil,0)
	ui.addTextArea(41,bus.wheel.text2,bus.target,bus.x+238,bus.y+110,nil,nil,0)
	if bus.wheel.state then
		ui.addTextArea(30,bus.wheel.text..'+',bus.target,bus.x+40,bus.y+129,nil,nil,0)
		ui.addTextArea(40,bus.wheel.text..'+',bus.target,bus.x+240,bus.y+129,nil,nil,0)
	else
		ui.addTextArea(30,bus.wheel.text..'x',bus.target,bus.x+46,bus.y+127,nil,nil,0)
		ui.addTextArea(40,bus.wheel.text..'x',bus.target,bus.x+244,bus.y+127,nil,nil,0)
	end
	ui.addTextArea(50,'',bus.target,bus.x+20,bus.y+120,300,1,bus.color2,bus.color)
	tfm.exec.displayParticle(3,bus.x+5,bus.y+140,-1,-1,-0.1,0,bus.target)
	for i=1,6 do
		ui.addTextArea(50+i,'',bus.target,bus.x+25+((i-1)*40),bus.y+70,25,25,bus.color2,bus.color,0.5)
	end
	bus.x=bus.x+3
	bus.wheel.state=not bus.wheel.state
end

-- Warning Blocker

do
	local a,b,c,d=ui.addTextArea,ui.addPopup,tfm.exec.newGame,0
	ui.addTextArea=function(i,t,...)if i and t then a(i,tostring(t):sub(1,2e3),...) end end
	ui.addPopup=function(i,p,t,...)if i and p and t then b(i,p,tostring(t):sub(1,2e3),...) end end
	tfm.exec.newGame=function(m)
		if os.time()-d>3500 then
			c(m)
			d=os.time()
		end
	end
end

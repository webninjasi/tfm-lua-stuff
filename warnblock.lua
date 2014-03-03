-- Warning Blocker

do
	local addTextArea = ui.addTextArea
	ui.addTextArea = function(ID, text, ...)
		if ID and text then
			addTextArea(ID, tostring(text):sub(1, 2e3), ...)
		end
	end

	local addPopup = ui.addPopup
	ui.addPopup = function(ID, type, text, ...)
		if ID and type and text then
			addPopup(ID, type, tostring(text):sub(1, 2e3), ...)
		end
	end

	local newGame, lastMapTime = tfm.exec.newGame, 0
	tfm.exec.newGame = function(mapCode)
		if os.time() - lastMapTime > 3500 then
			newGame(mapCode)
			lastMapTime = os.time()
		end
	end
end

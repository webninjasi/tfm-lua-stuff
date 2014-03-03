-- Warning Blocker

do
	local addTextArea = ui.addTextArea
	ui.addTextArea = function(ID, text, ...)
		if ID and text then
			addTextArea(ID, tostring(text):sub(1, 2e3), ...)
			return true
		end
	end

	local updateTextArea = ui.updateTextArea
	ui.updateTextArea = function(ID, text, ...)
		if ID and text then
			updateTextArea(ID, tostring(text):sub(1, 2e3), ...)
			return true
		end
	end

	local addPopup = ui.addPopup
	ui.addPopup = function(ID, type, text, ...)
		if ID and type and text then
			addPopup(ID, type, tostring(text):sub(1, 2e3), ...)
			return true
		end
	end

	local newGame, lastMapTime = tfm.exec.newGame, 0
	tfm.exec.newGame = function(mapCode)
		if os.time() - lastMapTime > 3500 then
			newGame(mapCode)
			lastMapTime = os.time()
			return true
		end
	end
end

---[[ Tests/Examples
assert(not ui.addTextArea())
assert(not ui.addTextArea(1))
assert(not ui.addTextArea(nil, "Test1"))
assert(ui.addTextArea(2, string.rep('.', 2e3) .. "Test2", nil, 50, 50))
assert(ui.addTextArea(3, "Test3", nil, 50, 100))

assert(not ui.updateTextArea())
assert(not ui.updateTextArea(1))
assert(not ui.updateTextArea(nil, "Test4"))
assert(ui.updateTextArea(2, string.rep('.', 2e3) .. "Test5"))
assert(ui.updateTextArea(3, "Test6"))

assert(not ui.addPopup())
assert(not ui.addPopup(1))
assert(not ui.addPopup(1, 2))
assert(not ui.addPopup(1, nil, "Test7"))
assert(not ui.addPopup(nil, 2, "Test8"))
assert(ui.addPopup(1, 2, "Test9"))

assert(tfm.exec.newGame(5))
assert(not tfm.exec.newGame(4))
--]]

---
-- Lays'in Dijital Saati
---

clock = {
	uiID = 500,
	timeOffset = 3600,
	x = 365, y = 160,
	days = { Mon="Pazartesi", Tue="Salı", Wed="Çarşamba", Thu="Perşembe", Fri="Cuma", Sat="Cumartesi", Sun="Pazar" },
	months = { Jan="Ocak", Feb="Şubat", Mar="Mart", Apr="Nisan", May="Mayıs", Jun="Haziran", Jul="Temmuz", Aug="Ağustos", Sep="Eylül", Oct="Ekim", Nov="Kasım", Dec="Aralık" },
	format = '<p align="center"><font face="Impact"><font size="20" color="#2AFAFF"><b>%s</b></font><font color="#1E8597">\n%s %s %s\n%s',
	str = '',
	parseDate = function()
		return os.date(nil, os.time() / 1000 + clock.timeOffset):match'(%S+) (%S+) (%S+) (%S+) (%S+) (%S+)'
	end,
	eventNewPlayer = function(name)
		for i=1,15 do
			ui.addTextArea(clock.uiID+i, '', name, clock.x-i, clock.y+i, 100, 60, 1+i*0x020202, 1+i*0x020202, 1, true)
		end
		ui.addTextArea(clock.uiID, clock.str, name, clock.x - 15, clock.y + 15, 100, 60, 1, 1, 1, true)
	end,
	eventLoop = function()
		local d = { clock.parseDate() }
		clock.str = clock.format:format(d[4], d[3], clock.months[d[2]], d[6], clock.days[d[1]])
		ui.updateTextArea(clock.uiID, clock.str)
	end
}

eventNewPlayer = clock.eventNewPlayer
eventLoop = clock.eventLoop
clock.eventNewPlayer()

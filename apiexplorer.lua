---
-- APIExplorer v1.1
-- Dev: Transforlays
---

local APIExplorer = {
	UI_CMD = "api",
	UI_ID = 747,
	UI_IDPREV = 748,
	UI_IDNEXT = 749,
	UI_IDBACK = 750,
	UI_IDPAGES = 751,
	UI_X = -350,
	UI_Y = 0,
	UI_BG = 0,
	UI_BORDER = 1,
	UI_OPACITY = 0.8,
	UI_FIXED = true,
	playerdata = {},
}

APIExplorer.init = function(self)
	system.disableChatCommandDisplay(self.UI_CMD)
end

APIExplorer.getPData = function(self, name)
	if self.playerdata[name] == nil then
		self.playerdata[name] = {
			parents = { _G },
			pageid = 0
		}
	end
	
	return self.playerdata[name]
end

APIExplorer.generatePage = function(self, name, pageid)
	local str = ""
	local line = ""
	local idx = 0
	local pagecount = 0
	local pagestr = nil
	local pdata = self:getPData(name)
	
	for k,v in pairs(pdata.parents[#pdata.parents]) do
		if type(v) == "table" then
			line = "<a href='event:api" .. tostring(idx) .. "'>" .. tostring(k) .. "</a>\n"
		else
			line = tostring(k) .. "<V>: " .. tostring(v) .. " [" .. type(v) .. "]\n<N>"
		end
		
		if #str + #line <= 2000 then
			str = str .. line
		else
			if pageid == pagecount then
				pagestr = str
				
				if pdata.maxpage ~= nil then
					break
				end
			end
			
			pagecount = pagecount + 1
			str = line
		end
		
		pdata[idx] = k
		idx = idx + 1
	end
	
	if pdata.maxpage == nil then
		pdata.maxpage = pagecount
	end
	
	return pagestr or str
end

APIExplorer.showUI = function(self, name)
	local pdata = self:getPData(name)
	
	if pdata.str == nil then
		pdata.str = self:generatePage(name, pdata.pageid)
	end
	
	ui.addTextArea(self.UI_ID, pdata.str, name, self.UI_X, self.UI_Y + 25, nil, nil, self.UI_BG, self.UI_BORDER, self.UI_OPACITY, self.UI_FIXED)
	ui.addTextArea(self.UI_IDPREV, "<a href='event:apiprev'>&lt;</a>", name, self.UI_X, self.UI_Y, 15, 15, self.UI_BG, self.UI_BORDER, self.UI_OPACITY, self.UI_FIXED)
	ui.addTextArea(self.UI_IDNEXT, "<a href='event:apinext'>&gt;</a>", name, self.UI_X + 20, self.UI_Y, 15, 15, self.UI_BG, self.UI_BORDER, self.UI_OPACITY, self.UI_FIXED)
	ui.addTextArea(self.UI_IDBACK, "<a href='event:apiback'>^</a>", name, self.UI_X + 50, self.UI_Y, 15, 15, self.UI_BG, self.UI_BORDER, self.UI_OPACITY, self.UI_FIXED)
	ui.addTextArea(self.UI_IDPAGES, pdata.maxpage + 1, name, self.UI_X + 70, self.UI_Y, nil, 15, self.UI_BG, self.UI_BORDER, self.UI_OPACITY, self.UI_FIXED)
end

APIExplorer.handleCommand = function(self, name, cmd)
	if cmd == APIExplorer.UI_CMD then
		self:showUI(name)
	end
end

APIExplorer.handleUIEvent = function(self, id, name, event)
	if event:sub(1, 3) == "api" then
		local pdata = self:getPData(name)
		
		if event:sub(4) == "next" then
			if pdata.pageid ~= pdata.maxpage then
				pdata.str = nil
				pdata.pageid = pdata.pageid + 1
				self:showUI(name)
			end
		elseif event:sub(4) == "prev" then
			if pdata.pageid ~= 0 then
				pdata.str = nil
				pdata.pageid = pdata.pageid - 1
				self:showUI(name)
			end
		elseif event:sub(4) == "back" then
			if #pdata.parents > 1  then
				pdata.parents[#pdata.parents] = nil
				pdata.str = nil
				pdata.pageid = 0
				pdata.maxpage = nil
				self:showUI(name)
			end
		else
			local key = pdata[tonumber(event:sub(4))]
			local val = nil
			
			if key then
				val = pdata.parents[#pdata.parents][key]
				
				if type(val) == "table" then
					pdata.parents[#pdata.parents + 1] = val
					pdata.str = nil
					pdata.pageid = 0
					pdata.maxpage = nil
					self:showUI(name)
				end
			end
		end
	end
end

--- Events

APIExplorer:init()

function eventChatCommand(name, cmd)
	APIExplorer:handleCommand(name, cmd)
end

function eventTextAreaCallback(id, name, event)
	APIExplorer:handleUIEvent(id, name, event)
end

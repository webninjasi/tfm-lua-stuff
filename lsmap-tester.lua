---
-- LSMap Tester v1.1
-- Transforlays
---

LSMAP=[[
/lsmap komutunun çıktısı buraya
]]
AUTH=nil
MAPS={}

PAGES={}
KEYS={}
UI_LIST=444
UI_NEXT=445
UI_PREV=446
UI_INFO=447
UI_SETTINGS=448
UI_POS_X=-200
KEY_TELEPORT=17

AUTO_RESPAWN=true
tfm.exec.enableAutoRespawn = function(state)
    AUTO_RESPAWN = state
end

ALLOW_TELEPORT=true
tfm.exec.enableTeleport = function(state)
    ALLOW_TELEPORT = state
end

SETTINGS = {
    ["disableAfkDeath"] = true,
    ["disableAutoNewGame"] = true,
    ["disableAutoShaman"] = true,
    ["enableAutoRespawn"] = true,
    ["enableTeleport"] = true,
    ["disableAllShamanSkills"] = false,
    ["disableAutoScore"] = false,
    ["disableAutoTimeLeft"] = false,
    ["disableDebugCommand"] = false,
    ["disableMinimalistMode"] = false,
    ["disableMortCommand"] = false,
    ["disablePhysicalConsumables"] = false,
    ["disablePrespawnPreview"] = false,
    ["disableWatchCommand"] = false,
}

function init()
    parseMaps()
    generatePages()
    showPage(1)

    for k, v in pairs(tfm.get.room.playerList) do
        eventNewPlayer(k)
    end
end

function parseMaps()
    local vote, percent, cat
    for id, rest in LSMAP:gmatch('(@%d+)(.-)\n') do
        if rest then
            vote, percent, cat = rest:match('^ %- (%d+) %- (%d+)%% %- (%S+)$')
        end
        table.insert(MAPS, {id=id, vote=tonumber(vote) or 0, percent=tonumber(percent) or 100, cat=cat or 'P?'})
    end
end

function generatePages()
    local str=""
    local line=""

    for k, v in pairs(MAPS) do
        line = string.format("<a href='event:%s'>%s\t%d\t%d%%\t%s</a>\n", v.id, v.id, v.vote, v.percent, v.cat)
        if #str + #line > 2000 then
            table.insert(PAGES, str)
            str = ""
        end
        str = str .. line
    end

    if #str > 0 then
        table.insert(PAGES, str)
    end
end

function showSettings()
    local str = "\n<ROSE><b><a href='event:X'>Close</a></b>"

    for k, v in pairs(SETTINGS) do
        tfm.exec[k](v)
        str = string.format("%s<a href='event:%s'>%s</a>\n%s", v and "<VP>" or "<R>", k, k, str)
    end

    ui.addTextArea(UI_SETTINGS, str, AUTH, UI_POS_X+200, 30, nil, nil, 1, 0, 0.8, true)
end

function showPage(num)
    if #PAGES >= num and num > 0 then
        ui.addTextArea(UI_LIST, PAGES[num], AUTH, UI_POS_X, 30, nil, nil, 1, 0, 0.8, true)

        if num > 1 then
            ui.addTextArea(UI_PREV, string.format("<a href='event:%d'>&lt;&lt;</a>", num-1), AUTH, UI_POS_X, 0, nil, nil, 1, 0, 0.8, true)
        else
            ui.removeTextArea(UI_PREV, AUTH)
        end

        if num < #PAGES then
            ui.addTextArea(UI_NEXT, string.format("<a href='event:%d'>&gt;&gt;</a>", num+1), AUTH, UI_POS_X+40, 0, nil, nil, 1, 0, 0.8, true)
        else
            ui.removeTextArea(UI_NEXT, AUTH)
        end
        
        ui.addTextArea(UI_INFO, string.format("<ROSE>%d <G>- <a href='event:S'>Settings</a>", num), AUTH, UI_POS_X+80, 0, nil, nil, 1, 0, 0.8, true)
    end
end

function eventTextAreaCallback(textAreaId, playerName, eventName)
    if AUTH and playerName ~= AUTH then
        return
    end

    if textAreaId == UI_LIST then
        tfm.exec.newGame(eventName)
    elseif textAreaId == UI_NEXT or textAreaId == UI_PREV then
        showPage(tonumber(eventName))
    elseif textAreaId == UI_INFO then
        showSettings()
    elseif textAreaId == UI_SETTINGS then
        if eventName == 'X' then
            ui.removeTextArea(UI_SETTINGS, AUTH)
        elseif SETTINGS[eventName] ~= nil then
            SETTINGS[eventName] = not SETTINGS[eventName]
            showSettings()
        end
    end
end

function eventNewPlayer(playerName)
    KEYS[playerName] = {}

    tfm.exec.bindKeyboard(playerName, KEY_TELEPORT, true, true)
    tfm.exec.bindKeyboard(playerName, KEY_TELEPORT, false, true)
    system.bindMouse(playerName, true)

    if AUTO_RESPAWN then
        tfm.exec.respawnPlayer(playerName)
    end
end

function eventPlayerLeft(playerName)
    KEYS[playerName] = nil
end

function eventPlayerDied(playerName)
    if AUTO_RESPAWN then
        tfm.exec.respawnPlayer(playerName)
    end
end

function eventPlayerWon(playerName, timeElapsed, timeElapsedSinceRespawn)
    if AUTO_RESPAWN then
        tfm.exec.respawnPlayer(playerName)
    end
end

function eventKeyboard(playerName, keyCode, down, xPlayerPosition, yPlayerPosition)
    KEYS[playerName][keyCode] = down
end

function eventMouse(playerName, xMousePosition, yMousePosition)
    if ALLOW_TELEPORT or playerName == AUTH then
        if KEYS[playerName][KEY_TELEPORT] then
            tfm.exec.respawnPlayer(playerName)
            tfm.exec.movePlayer(playerName, xMousePosition, yMousePosition)
        end
    end
end

init()

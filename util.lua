local M = {}

M.HYPER = { 'cmd', 'ctrl', 'alt', 'shift' }

function M.ternary(condition, ifTrue, ifFalse)
    if condition then
        return ifTrue
    else
        return ifFalse
    end
end

function M.wrapModalExit(functionToWrap)
    return function(modal)
        functionToWrap(modal)
        modal:exit()
    end
end

function M.alert(alert)
    hs.alert.closeAll()
    hs.alert.show(alert)
end

function M.sendKey(mods, key)
    if mods == nil then mods = {} end

    hs.eventtap.keyStroke(mods, key)
end

function M.sendSystemKey(key)
    hs.eventtap.event.newSystemKeyEvent(key, true):post()
    hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

function M.bindHyperSubmodeActions(triggerKey, modeName, keysAndActions)
    local modal = hs.hotkey.modal.new(M.HYPER, triggerKey, modeName .. ' mode')

    for key, actionSupplier in pairs(keysAndActions) do
        modal:bind('', key, function() actionSupplier(modal) end)
    end

    modal:bind('', 'escape', function()
        M.alert('Exiting ' .. modeName .. ' mode')
        modal:exit()
    end)
end

function M.launchOrFocusChromeProfileWindow(profileName)
    local chromeWindows = hs.application.find('Google Chrome'):allWindows()

    local windowToFocus = nil

    for _, window in ipairs(chromeWindows) do
        if string.match(window:title(), profileName) then windowToFocus = window end
    end

    if windowToFocus then
        windowToFocus:focus()
    else
        M.alert('No Chrome window found for ' .. profileName .. ' profile')
    end
end

return M

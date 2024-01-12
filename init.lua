local u = require 'util'

--- `Hyper` sub-layer key bindings

hs.window.animationDuration = 0 -- Disable animations, default value = 0.2

u.bindHyperSubmodeActions(
    'v',
    'Views',
    hs.fnutils.map({
        -- Occupy 1/2 of a screen
        h = { 0, 0, 0.5, 1 }, -- <
        l = { 0.5, 0, 0.5, 1 }, -- >
        j = { 0, 0.5, 1, 0.5 }, -- v
        k = { 0, 0, 1, 0.5 }, -- ^
        -- Occupy 1/3 of a screen
        n = { 0, 0, 0.33, 1 }, -- Left
        m = { 0.33, 0, 0.33, 1 }, -- Middle
        [','] = { 0.66, 0, 0.33, 1 }, -- Right
        -- Occupy 1/4 of a screen
        y = { 0, 0, 0.5, 0.5 }, -- ⌜
        u = { 0, 0.5, 0.5, 0.5 }, -- ⌞
        i = { 0.5, 0.5, 0.5, 0.5 }, -- ⌟
        o = { 0.5, 0, 0.5, 0.5 }, -- ⌝
        p = function() hs.window.focusedWindow():maximize() end, -- Maximize
        -- Center
        [';'] = function() hs.window.focusedWindow():centerOnScreen() end,
    }, function(windowUnitOrFunction)
        local action = u.ternary(
            type(windowUnitOrFunction) == 'function',
            windowUnitOrFunction,
            function() hs.window.focusedWindow():moveToUnit(windowUnitOrFunction) end
        )

        return u.wrapModalExit(action)
    end)
)

u.bindHyperSubmodeActions(
    's',
    'Switch Apps',
    hs.fnutils.map({
        y = 'Youtube Music',
        u = 'Slack', -- Work [u]pdates
        i = 'IntelliJ IDEA',
        o = 'Finder', -- [O]pen
        p = 'NordPass', -- [P]asswords
        h = 'Hammerspoon',
        j = 'Mail', -- [J]unk
        k = 'Kitty',
        l = 'Reminders', -- To-do [l]ist
        [';'] = 'Calendar', -- No mnemonic binding :'(
        n = 'Notion',
        m = 'Telegram', -- [M]essaging
    }, function(appName)
        return u.wrapModalExit(function() hs.application.launchOrFocus(appName) end)
    end)
)

u.bindHyperSubmodeActions(
    'b',
    'Browse Internet',
    hs.fnutils.map({
        h = 'Incognito', -- [H]idden
        i = 'Innovecs',
        p = 'Personal',
        m = 'Miro',
    }, function(profileName)
        return u.wrapModalExit(function() u.launchOrFocusChromeProfileWindow(profileName) end)
    end)
)

u.bindHyperSubmodeActions(
    'c',
    'Controls',
    hs.fnutils.map({
        h = 'PREVIOUS',
        j = 'SOUND_DOWN',
        k = 'SOUND_UP',
        l = 'NEXT',
        [';'] = function() u.sendSystemKey 'MUTE' end,
        u = 'BRIGHTNESS_DOWN',
        i = 'BRIGHTNESS_UP',
        o = 'FAST',
        y = 'REWIND',
        p = hs.caffeinate.lockScreen,
        ['.'] = function() u.sendSystemKey 'PLAY' end,
    }, function(systemKeyOrFunction)
        return u.ternary(
            type(systemKeyOrFunction) == 'function',
            u.wrapModalExit(systemKeyOrFunction),
            function() u.sendSystemKey(systemKeyOrFunction) end
        )
    end)
)

u.bindHyperSubmodeActions(
    'z',
    'Zap Screen',
    hs.fnutils.map({
        u = { { 'cmd', 'shift' }, '3' },
        i = { { 'ctrl', 'cmd', 'shift' }, '3' },
        j = { { 'cmd', 'shift' }, '4' },
        k = { { 'ctrl', 'cmd', 'shift' }, '4' },
        o = { { 'cmd', 'shift' }, '5' },
    }, function(modsAndKey)
        return u.wrapModalExit(function() u.sendKey(modsAndKey[1], modsAndKey[2]) end)
    end)
)

u.bindHyperSubmodeActions(
    'x',
    'Execute',
    hs.fnutils.map({
        k = function() hs.application.frontmostApplication():kill() end, -- [K]ill
        l = function() hs.reload() end, -- [L]oad Hammerspoon configuration
        m = function() hs.eventtap.keyStroke({ 'ctrl', 'cmd' }, 'space') end, -- Open e[m]oji picker
    }, function(action) return u.wrapModalExit(action) end)
)

hs.alert.show 'Configuration reloaded'

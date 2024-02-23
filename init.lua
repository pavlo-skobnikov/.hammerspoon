local u = require 'util'

-- Disable animations, default value = 0.2
hs.window.animationDuration = 0

----------------------------------------------------------------------------------------------------
------------------------------------ Root `Leader` modal -------------------------------------------
----------------------------------------------------------------------------------------------------

local leaderModal = u.createModal {
  modifiers = 'ctrl',
  key = '\\',
  modalName = 'Leader Modal',
}

----------------------------------------------------------------------------------------------------
------------------------------------- `Window` modal -----------------------------------------------
----------------------------------------------------------------------------------------------------

local viewsModal = u.createModal {
  modalName = 'Views Modal',
}

local listOfViewsModalBindSpec = hs.fnutils.map({
  -- Occupy 1/2 of a screen
  { key = 'h', description = '1/2 Left', windowUnit = { 0, 0, 0.5, 1 } },
  { key = 'l', description = '1/2 Right', windowUnit = { 0.5, 0, 0.5, 1 } },
  { key = 'j', description = '1/2 Bottom', windowUnit = { 0, 0.5, 1, 0.5 } },
  { key = 'k', description = '1/2 Top', windowUnit = { 0, 0, 1, 0.5 } },
  -- Occupy 1/3 of a screen
  { key = 'a', description = '1/3 Left', windowUnit = { 0, 0, 0.33, 1 } },
  { key = 's', description = '1/3 Middle', windowUnit = { 0.33, 0, 0.33, 1 } },
  { key = 'd', description = '1/3 Right', windowUnit = { 0.66, 0, 0.33, 1 } },
  -- Occupy 1/4 of a screen
  { key = 'y', description = '⌜', windowUnit = { 0, 0, 0.5, 0.5 } },
  { key = 'u', description = '⌞', windowUnit = { 0, 0.5, 0.5, 0.5 } },
  { key = 'i', description = '⌟', windowUnit = { 0.5, 0.5, 0.5, 0.5 } },
  { key = 'o', description = '⌝', windowUnit = { 0.5, 0, 0.5, 0.5 } },
  -- Maximize
  { key = 'm', description = 'Maximize', action = function() hs.window.focusedWindow():maximize() end },
  -- Center
  { key = 'c', description = 'Center', action = function() hs.window.focusedWindow():centerOnScreen() end },
}, function(mapping)
  local action

  if mapping.windowUnit then
    action = function() hs.window.focusedWindow():moveToUnit(mapping.windowUnit) end
  else
    action = mapping.action
  end

  return {
    modal = viewsModal,
    key = mapping.key,
    description = mapping.description,
    action = action,
    exitModalAfterAction = true,
  }
end)

hs.fnutils.each(listOfViewsModalBindSpec, u.bindModalMapping)

local viewsModalBindings = u.modalBindSpecToString(listOfViewsModalBindSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 'v',
  description = 'Views',
  action = function()
    viewsModal:enter()
    u.alert(viewsModalBindings)
  end,
  exitModalAfterAction = true,
}

----------------------------------------------------------------------------------------------------
---------------------------------- `Applications` modal --------------------------------------------
----------------------------------------------------------------------------------------------------

local applicationsModal = u.createModal {
  modalName = 'Applications Modal',
}

local listOfApplicationsBindModalSpec = hs.fnutils.map({
  { key = 'a', appName = 'Arc' },
  { key = 'f', appName = 'Finder' },
  { key = 'h', appName = 'Hammerspoon' },
  { key = 'y', appName = 'Youtube Music' },
  { key = 'd', appName = 'Docker Desktop' },
  { key = 'i', appName = 'IntelliJ IDEA' },
  { key = 'k', appName = 'Kitty' },
  { key = 'p', appName = 'NordPass', description = 'Password manager' },
  { key = 'n', appName = 'Notion' },
  { key = 'l', appName = 'Todoist', description = 'To-do list' },
  { key = 'c', appName = 'Notion Calendar' },
  { key = 'm', appName = 'Mail' },
  { key = 'w', appName = 'Microsoft Teams (work or school)', description = '[Work] Microsoft Teams' },
  { key = 's', appName = 'Slack' },
  { key = 't', appName = 'Telegram' },
  { key = 'z', appName = 'zoom.us', description = 'Zoom' },
}, function(mapping)
  local description = mapping.description and mapping.description or mapping.appName

  return {
    modal = applicationsModal,
    key = mapping.key,
    description = description,
    action = function() hs.application.launchOrFocus(mapping.appName) end,
    exitModalAfterAction = true,
  }
end)

hs.fnutils.each(listOfApplicationsBindModalSpec, u.bindModalMapping)

local applicationsModalBindings = u.modalBindSpecToString(listOfApplicationsBindModalSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 'a',
  description = 'Applications',
  action = function()
    applicationsModal:enter()
    u.alert(applicationsModalBindings)
  end,
  exitModalAfterAction = true,
}

----------------------------------------------------------------------------------------------------
---------------------------------- `Utilities` modal -----------------------------------------------
----------------------------------------------------------------------------------------------------

local utilitiesModal = u.createModal {
  modalName = 'Utilities Modal',
}

local listOfUtilitiesBindModalSpec = hs.fnutils.map({
  { key = 'p', description = 'Previous track', systemKey = 'PREVIOUS' },
  { key = 'n', description = 'Next track', systemKey = 'NEXT' },
  { key = 's', description = 'Sound down', systemKey = 'SOUND_DOWN' },
  { key = 'w', description = 'Sound up', systemKey = 'SOUND_UP' },
  { key = 'm', description = 'Mute', action = function() u.sendSystemKey 'MUTE' end },
  { key = 'f', description = 'Fast forward', systemKey = 'FAST' },
  { key = 'r', description = 'Rewind', systemKey = 'REWIND' },
  { key = 'y', description = 'Play', action = function() u.sendSystemKey 'PLAY' end },
  { key = 'b', description = 'Brightness down', systemKey = 'BRIGHTNESS_DOWN' },
  { key = 'g', description = 'Brightness up', systemKey = 'BRIGHTNESS_UP' },
  { key = 'l', description = 'Lock screen', action = hs.caffeinate.lockScreen },
}, function(mapping)
  local action
  local exitModalAfterAction

  if mapping.systemKey then
    action = function() u.sendSystemKey(mapping.systemKey) end
    exitModalAfterAction = false
  else
    action = mapping.action
    exitModalAfterAction = true
  end

  return {
    modal = utilitiesModal,
    key = mapping.key,
    description = mapping.description,
    action = action,
    exitModalAfterAction = exitModalAfterAction,
  }
end)

hs.fnutils.each(listOfUtilitiesBindModalSpec, u.bindModalMapping)

local utilitiesModalBindings = u.modalBindSpecToString(listOfUtilitiesBindModalSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 'u',
  description = 'Utilities',
  action = function()
    utilitiesModal:enter()
    u.alert(utilitiesModalBindings)
  end,
  exitModalAfterAction = true,
}

----------------------------------------------------------------------------------------------------
--------------------------------- `Execute` modal --------------------------------------------------
----------------------------------------------------------------------------------------------------

local executeModal = u.createModal {
  modalName = 'Execute',
}

local listOfExecuteModalBindSpec = hs.fnutils.map(
  {
    {
      key = 'k',
      description = 'Kill the frontmost app',
      action = function() hs.application.frontmostApplication():kill() end,
    },
    { key = 'r', description = 'Reload Hammerspoon config', action = hs.reload },
    {
      key = 'e',
      description = 'Emoji picker',
      action = function() hs.eventtap.keyStroke({ 'ctrl', 'cmd' }, 'space') end,
    },
    {
      key = 'o',
      description = 'Open Arc bar',
      action = function()
        hs.application.launchOrFocus 'Arc'
        hs.eventtap.keyStroke({ 'cmd' }, 'l')
      end,
    },
  },
  function(mapping)
    return {
      modal = executeModal,
      key = mapping.key,
      description = mapping.description,
      action = mapping.action,
      exitModalAfterAction = true,
    }
  end
)

hs.fnutils.each(listOfExecuteModalBindSpec, u.bindModalMapping)

local executeModalBindings = u.modalBindSpecToString(listOfExecuteModalBindSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 'e',
  description = 'Execute',
  action = function()
    executeModal:enter()
    u.alert(executeModalBindings)
  end,
  exitModalAfterAction = true,
}

----------------------------------------------------------------------------------------------------
---------------------------------- `Screenshot bindings --------------------------------------------
----------------------------------------------------------------------------------------------------

local screenshotModal = u.createModal {
  modalName = 'Screenshot',
}

local listOfScreenshotModalBindSpec = hs.fnutils.map({
  {
    mappedKey = 'u',
    modifiers = { 'cmd', 'shift' },
    executeKey = '3',
    description = 'Capture screen and save to desktop',
  },
  {
    mappedKey = 'i',
    modifiers = { 'cmd', 'shift' },
    executeKey = '4',
    description = 'Capture area and save to desktop',
  },
  {
    mappedKey = 'j',
    modifiers = { 'ctrl', 'cmd', 'shift' },
    executeKey = '3',
    description = 'Capture screen and copy',
  },
  {
    mappedKey = 'k',
    modifiers = { 'ctrl', 'cmd', 'shift' },
    executeKey = '4',
    description = 'Capture area and copy',
  },
  {
    mappedKey = 'r',
    modifiers = { 'cmd', 'shift' },
    executeKey = '5',
    description = 'Record screen',
  },
}, function(mapping)
  return {
    modal = screenshotModal,
    key = mapping.mappedKey,
    description = mapping.description,
    action = function() u.sendKey(mapping.modifiers, mapping.executeKey) end,
    exitModalAfterAction = true,
  }
end)

hs.fnutils.each(listOfScreenshotModalBindSpec, u.bindModalMapping)

local screenshotModalBindings = u.modalBindSpecToString(listOfScreenshotModalBindSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 's',
  description = 'Screenshot',
  action = function()
    screenshotModal:enter()
    u.alert(screenshotModalBindings)
  end,
  exitModalAfterAction = true,
}

----------------------------------------------------------------------------------------------------
------------------------------- Sub-`Leader` modal bindings ----------------------------------------
----------------------------------------------------------------------------------------------------

local listOfLeaderModalBindSpec = hs.fnutils.map({
  { key = 'a', description = '+applications', modal = applicationsModal, modalBindings = applicationsModalBindings },
  { key = 'e', description = '+execute', modal = executeModal, modalBindings = executeModalBindings },
  { key = 's', description = '+screenshot', modal = screenshotModal, modalBindings = screenshotModalBindings },
  { key = 'u', description = '+utilities', modal = utilitiesModal, modalBindings = utilitiesModalBindings },
  { key = 'v', description = '+views', modal = viewsModal, modalBindings = viewsModalBindings },
}, function(modal)
  return {
    modal = leaderModal,
    key = modal.key,
    description = modal.description,
    action = function()
      modal.modal:enter()
      u.alert(modal.modalBindings)
    end,
    exitModalAfterAction = true,
  }
end)

hs.fnutils.each(listOfLeaderModalBindSpec, u.bindModalMapping)

local leaderModalBindings = u.modalBindSpecToString(listOfLeaderModalBindSpec)

function leaderModal:entered() u.alert(leaderModalBindings) end

----------------------------------------------------------------------------------------------------

hs.alert.show 'Configuration reloaded'

local u = require 'util'

-- Disable animations, default value = 0.2
hs.window.animationDuration = 0
-- Disable window shadows
hs.window.setShadows(false)

------------------------------
-- Root `Leader` modal
------------------------------

local leaderModal = u.createModal {
  modifiers = 'ctrl',
  key = '\\',
  modalName = 'Leader Modal',
}

------------------------------
-- `Views` modal
------------------------------

local viewsModal = u.createModal {
  modalName = 'Views Modal',
}

local listOfViewsModalBindSpec = hs.fnutils.map({
  -- Occupy 1/2 of a screen
  { key = 'h', desc = '1/2 Left', windowUnit = { 0, 0, 0.5, 1 } },
  { key = 'l', desc = '1/2 Right', windowUnit = { 0.5, 0, 0.5, 1 } },
  { key = 'j', desc = '1/2 Bottom', windowUnit = { 0, 0.5, 1, 0.5 } },
  { key = 'k', desc = '1/2 Top', windowUnit = { 0, 0, 1, 0.5 } },
  -- Occupy 1/3 of a screen
  { key = 'a', desc = '1/3 Left', windowUnit = { 0, 0, 0.33, 1 } },
  { key = 's', desc = '1/3 Middle', windowUnit = { 0.33, 0, 0.33, 1 } },
  { key = 'd', desc = '1/3 Right', windowUnit = { 0.66, 0, 0.33, 1 } },
  -- Occupy 1/4 of a screen
  { key = 'y', desc = '⌜', windowUnit = { 0, 0, 0.5, 0.5 } },
  { key = 'u', desc = '⌞', windowUnit = { 0, 0.5, 0.5, 0.5 } },
  { key = 'i', desc = '⌟', windowUnit = { 0.5, 0.5, 0.5, 0.5 } },
  { key = 'o', desc = '⌝', windowUnit = { 0.5, 0, 0.5, 0.5 } },
  -- Maximize
  { key = 'm', desc = 'Maximize', action = function() hs.window.focusedWindow():maximize() end },
  -- Center
  { key = 'c', desc = 'Center', action = function() hs.window.focusedWindow():centerOnScreen() end },
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
    description = mapping.desc,
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

------------------------------
-- `Applications` modal
------------------------------

local applicationsModal = u.createModal {
  modalName = 'Applications Modal',
}

local listOfApplicationsBindModalSpec = hs.fnutils.map({
  { key = 'a', appName = 'Arc' },
  { key = 'c', appName = 'Calendar' },
  { key = 'd', appName = 'Docker Desktop', desc = 'Docker' },
  { key = 'f', appName = 'Finder' },
  { key = 'h', appName = 'Hammerspoon' },
  { key = 'i', appName = 'IntelliJ IDEA', desc = 'IDEA' },
  { key = 'k', appName = 'Kitty' },
  { key = 'r', appName = 'Reminders' },
  { key = 'm', appName = 'Mail' },
  { key = 'n', appName = 'Notes' },
  { key = 'p', appName = 'System Settings', desc = 'System Preferences' },
  { key = 's', appName = 'Slack' },
  { key = 't', appName = 'Telegram' },
  { key = 'w', appName = 'Microsoft Teams (work or school)', desc = 'Work messenger' },
  { key = 'z', appName = 'zoom.us', desc = 'Zoom' },
}, function(mapping)
  local description = mapping.desc and mapping.desc or mapping.appName

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

------------------------------
-- `Utilities` modal
------------------------------

local utilitiesModal = u.createModal {
  modalName = 'Utilities Modal',
}

local listOfUtilitiesBindModalSpec = hs.fnutils.map({
  { key = 'b', desc = 'Brightness down', systemKey = 'BRIGHTNESS_DOWN' },
  { key = 'f', desc = 'Fast forward', systemKey = 'FAST' },
  { key = 'g', desc = 'Brightness up', systemKey = 'BRIGHTNESS_UP' },
  { key = 'l', desc = 'Lock screen', action = hs.caffeinate.lockScreen },
  { key = 'm', desc = 'Mute', action = function() u.sendSystemKey 'MUTE' end },
  { key = 'n', desc = 'Next track', systemKey = 'NEXT' },
  { key = 'p', desc = 'Previous track', systemKey = 'PREVIOUS' },
  { key = 'r', desc = 'Rewind', systemKey = 'REWIND' },
  { key = 's', desc = 'Sound down', systemKey = 'SOUND_DOWN' },
  { key = 'w', desc = 'Sound up', systemKey = 'SOUND_UP' },
  { key = 'y', desc = 'Play', action = function() u.sendSystemKey 'PLAY' end },
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
    description = mapping.desc,
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

------------------------------
-- `Execute` modal
------------------------------

local executeModal = u.createModal {
  modalName = 'Execute',
}

local listOfExecuteModalBindSpec = hs.fnutils.map(
  {
    { key = 'k', desc = 'Kill app', action = function() hs.application.frontmostApplication():kill() end },
    { key = 'r', desc = 'Reload Hammerspoon config', action = hs.reload },
    { key = 'e', desc = 'Emojis', action = function() hs.eventtap.keyStroke({ 'ctrl', 'cmd' }, 'space') end },
  },
  function(mapping)
    return {
      modal = executeModal,
      key = mapping.key,
      description = mapping.desc,
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

------------------------------
-- `Browser` modal
------------------------------

local browserModal = u.createModal {
  modalName = 'Browser',
}

local listOfBrowserModalBindSpec = hs.fnutils.map({
  -- Searching
  { key = 's', desc = 'Search', keyEvent = { mods = { 'cmd' }, key = 't' } },
  { key = 'q', desc = 'Quick search', keyEvent = { mods = { 'alt', 'cmd' }, key = 'n' } },
  { key = 'g', desc = 'ChatGPT', keyEvent = { mods = { 'alt', 'cmd' }, key = 'g' } },
  { key = 'c', desc = 'Command bar', keyEvent = { mods = { 'cmd' }, key = 'l' } },
  -- Tab management
  { key = 'r', desc = 'Reload tab', keyEvent = { mods = { 'cmd' }, key = 'r' } },
  { key = 'k', desc = 'Kill tab', keyEvent = { mods = { 'cmd' }, key = 'w' } },
  { key = 'o', desc = 'Open in main window', keyEvent = { mods = { 'cmd' }, key = 'o' } },
  { key = 'p', desc = 'Pin/unpin', keyEvent = { mods = { 'cmd' }, key = 'd' } },
  { key = 'n', desc = 'Rename', keyEvent = { mods = { 'ctrl', 'cmd' }, key = 'r' } },
  -- Splits
  { key = 'v', desc = 'Vertical split', keyEvent = { mods = { 'ctrl', 'shift' }, key = '=' } },
  { key = 'x', desc = 'Close split', keyEvent = { mods = { 'ctrl', 'shift' }, key = '-' } },
  { key = ']', desc = 'Next split', keyEvent = { mods = { 'ctrl', 'shift' }, key = ']' } },
  { key = '[', desc = 'Previous split', keyEvent = { mods = { 'ctrl', 'shift' }, key = '[' } },
  -- Miscellaneous
  { key = 'w', desc = 'Workspaces search', keyEvent = { mods = { 'shift', 'cmd' }, key = 'o' } },
  { key = 'b', desc = 'Toggle sidebar', keyEvent = { mods = { 'cmd' }, key = 's' } },
  -- Developer tools
  { key = 'e', desc = 'Elements', keyEvent = { mods = { 'alt', 'cmd' }, key = 'c' } },
  { key = 'j', desc = 'JS console', keyEvent = { mods = { 'alt', 'cmd' }, key = 'j' } },
  { key = 'h', desc = 'HTTP', keyEvent = { mods = { 'ctrl', 'cmd' }, key = 'h' } },
  -- Workspaces
  { key = '1', desc = '[Personal]', keyEvent = { mods = { 'ctrl' }, key = '1', focusApp = true } },
  { key = '2', desc = '[Miro]', keyEvent = { mods = { 'ctrl' }, key = '2', focusApp = true } },
  { key = '3', desc = '[Innovecs]', keyEvent = { mods = { 'ctrl' }, key = '3', focusApp = true } },
}, function(mapping)
  local spec = mapping.keyEvent

  return {
    modal = browserModal,
    key = mapping.key,
    description = mapping.desc,
    action = function()
      u.sendKeyToApplication {
        mods = spec.mods,
        key = spec.key,
        msDelay = spec.msDelay,
        appName = 'Arc',
        focusApp = spec.focusApp,
      }
    end,
    exitModalAfterAction = mapping.exitMod ~= false,
  }
end)

hs.fnutils.each(listOfBrowserModalBindSpec, u.bindModalMapping)

local browserModalBindings = u.modalBindSpecToString(listOfBrowserModalBindSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 'b',
  description = 'Browser',
  action = function()
    browserModal:enter()
    u.alert(browserModalBindings)
  end,
  exitModalAfterAction = true,
}

------------------------------
-- `Reminders` modal
------------------------------

local remindersModal = u.createModal {
  modalName = 'Reminders',
}

local listOfRemindersModalBindSpec = hs.fnutils.map({
  { key = 'n', desc = 'New reminder', keyEventSpec = { mods = { 'cmd' }, key = 'n', focusApp = true } },
  { key = 'i', desc = 'Indent task', keyEventSpec = { mods = { 'cmd' }, key = ']' } },
  { key = 'o', desc = 'Outdent task', keyEventSpec = { mods = { 'cmd' }, key = '[' } },
  { key = 's', desc = 'Show subtasks', keyEventSpec = { mods = { 'cmd' }, key = 'e' } },
  { key = 'h', desc = 'Hide subtasks', keyEventSpec = { mods = { 'cmd', 'shift' }, key = 'e' } },
  { key = 'f', desc = 'Flag/unflag task', keyEventSpec = { mods = { 'cmd', 'shift' }, key = 'f' } },
  { key = 'c', desc = 'Complete/uncomplete task', keyEventSpec = { mods = { 'cmd', 'shift' }, key = 'c' } },
  { key = '.', desc = 'Show/hide completed tasks', keyEventSpec = { mods = { 'cmd', 'shift' }, key = 'h' } },
  { key = 'b', desc = 'Toggle sidebar', keyEventSpec = { mods = { 'alt', 'cmd' }, key = 's' } },
  { key = 't', desc = 'Set due today', keyEventSpec = { mods = { 'cmd' }, key = 't' } },
  { key = 'd', desc = 'Set due tomorrow', keyEventSpec = { mods = { 'cmd', 'alt' }, key = 't' } },
  { key = 'o', desc = 'Set overdue to today', keyEventSpec = { mods = { 'cmd', 'ctrl' }, key = 't' } },
  { key = 'e', desc = 'Set due this/next weekend', keyEventSpec = { mods = { 'cmd' }, key = 'k' } },
  { key = 'w', desc = 'Set due next week', keyEventSpec = { mods = { 'cmd', 'alt' }, key = 'k' } },
  { key = '1', desc = 'Go to Today list', keyEventSpec = { mods = { 'cmd' }, key = '1', focusApp = true } },
  { key = '2', desc = 'Go to Scheduled', keyEventSpec = { mods = { 'cmd' }, key = '2', focusApp = true } },
  { key = '3', desc = 'Go to All', keyEventSpec = { mods = { 'cmd' }, key = '3', focusApp = true } },
  { key = '4', desc = 'Go to Flagged', keyEventSpec = { mods = { 'cmd' }, key = '4', focusApp = true } },
  { key = '5', desc = 'Go to Completed', keyEventSpec = { mods = { 'cmd' }, key = '5', focusApp = true } },
  { key = '6', desc = 'Go to Inbox', keyEventSpec = { mods = { 'cmd' }, key = '6', focusApp = true } },
}, function(mapping)
  local spec = mapping.keyEventSpec

  return {
    modal = remindersModal,
    key = mapping.key,
    description = mapping.desc,
    action = function()
      u.sendKeyToApplication {
        mods = spec.mods,
        key = spec.key,
        msDelay = spec.msDelay,
        appName = 'Reminders',
        focusApp = spec.focusApp,
      }
    end,
    exitModalAfterAction = true,
  }
end)

hs.fnutils.each(listOfRemindersModalBindSpec, u.bindModalMapping)

local remindersModalBindings = u.modalBindSpecToString(listOfRemindersModalBindSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 'r',
  description = 'Reminders',
  action = function()
    remindersModal:enter()
    u.alert(remindersModalBindings)
  end,
  exitModalAfterAction = true,
}

------------------------------
-- `Calendar` modal
------------------------------

local calendarModal = u.createModal {
  modalName = 'Calendar',
}

local listOfCalendarModalBindSpec = hs.fnutils.map({
  -- Calendar shortcuts
  { key = 't', desc = 'Today', keyEventSpec = { mods = { 'cmd' }, key = 't', focusApp = true } },
  { key = 's', desc = 'Specific date', keyEventSpec = { mods = { 'cmd', 'shift' }, key = 't', focusApp = true } },
  { key = 'd', desc = 'Day view', keyEventSpec = { mods = { 'cmd' }, key = '1', focusApp = true } },
  { key = 'w', desc = 'Week view', keyEventSpec = { mods = { 'cmd' }, key = '2', focusApp = true } },
  { key = 'm', desc = 'Month view', keyEventSpec = { mods = { 'cmd' }, key = '3', focusApp = true } },
  { key = 'y', desc = 'Year view', keyEventSpec = { mods = { 'cmd' }, key = '4', focusApp = true } },
  -- Event shortcuts
  { key = 'n', desc = 'New event', keyEventSpec = { mods = { 'cmd' }, key = 'n', focusApp = true } },
  { key = 'e', desc = 'Edit event', keyEventSpec = { mods = { 'cmd' }, key = 'e' } },
  { key = 'i', desc = 'Event/calendar info', keyEventSpec = { mods = { 'cmd' }, key = 'i' } },
}, function(mapping)
  local spec = mapping.keyEventSpec

  return {
    modal = calendarModal,
    key = mapping.key,
    description = mapping.desc,
    action = function()
      u.sendKeyToApplication {
        mods = spec.mods,
        key = spec.key,
        msDelay = spec.msDelay,
        appName = 'Calendar',
        focusApp = spec.focusApp,
      }
    end,
    exitModalAfterAction = true,
  }
end)

hs.fnutils.each(listOfCalendarModalBindSpec, u.bindModalMapping)

local calendarModalBindings = u.modalBindSpecToString(listOfCalendarModalBindSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 'c',
  description = 'Calendar',
  action = function()
    calendarModal:enter()
    u.alert(calendarModalBindings)
  end,
  exitModalAfterAction = true,
}

------------------------------
-- `Notes` modal
------------------------------

local notesModal = u.createModal {
  modalName = 'Notes',
}

local listOfNotesModalBindSpec = hs.fnutils.map({
  { key = 'n', desc = 'Create note', keyEventSpec = { mods = { 'cmd' }, key = 'n', focusApp = true } },
  { key = 'd', desc = 'Duplicate note', keyEventSpec = { mods = { 'cmd' }, key = 'd' } },
  { key = '1', desc = 'List view', keyEventSpec = { mods = { 'cmd' }, key = '1', focusApp = true } },
  { key = '2', desc = 'Gallery view', keyEventSpec = { mods = { 'cmd' }, key = '2', focusApp = true } },
  { key = '3', desc = 'Attachments', keyEventSpec = { mods = { 'cmd' }, key = '3', focusApp = true } },
  { key = 'b', desc = 'Show/hide folders bar', keyEventSpec = { mods = { 'cmd', 'alt' }, key = 's' } },
  { key = 'f', desc = 'Find note', keyEventSpec = { mods = { 'alt', 'cmd' }, key = 'f', focusApp = true } },
  { key = 'a', desc = 'Add a table', keyEventSpec = { mods = { 'alt', 'cmd' }, key = 't' } },
  { key = 'l', desc = 'Insert a link', keyEventSpec = { mods = { 'cmd' }, key = 'k' } },
  { key = 't', desc = 'Apply Title format', keyEventSpec = { mods = { 'shift', 'cmd' }, key = 't' } },
  { key = 'h', desc = 'Apply Heading format', keyEventSpec = { mods = { 'shift', 'cmd' }, key = 'h' } },
  { key = 's', desc = 'Apply Subheading format', keyEventSpec = { mods = { 'shift', 'cmd' }, key = 'j' } },
  { key = 'p', desc = 'Apply plain text format', keyEventSpec = { mods = { 'shift', 'cmd' }, key = 'b' } },
  { key = 'm', desc = 'Apply Monospaced format', keyEventSpec = { mods = { 'shift', 'cmd' }, key = 'm' } },
  { key = 'q', desc = 'Apply Block Quote format', keyEventSpec = { mods = { 'cmd' }, key = "'" } },
  { key = 'c', desc = 'Create a checklist', keyEventSpec = { mods = { 'shift', 'cmd' }, key = 'l' } },
  { key = 'u', desc = 'Mark/unmark a checklist item', keyEventSpec = { mods = { 'shift', 'cmd' }, key = 'u' } },
  { key = 'k', desc = 'Clist item up', keyEventSpec = { mods = { 'ctrl', 'cmd' }, key = 'up' }, exitMod = false },
  { key = 'j', desc = 'Clist item down', keyEventSpec = { mods = { 'ctrl', 'cmd' }, key = 'down' }, exitMod = false },
}, function(mapping)
  local spec = mapping.keyEventSpec

  return {
    modal = notesModal,
    key = mapping.key,
    description = mapping.desc,
    action = function()
      u.sendKeyToApplication {
        mods = spec.mods,
        key = spec.key,
        msDelay = spec.msDelay,
        appName = 'Notes',
        focusApp = spec.focusApp,
      }
    end,
    exitModalAfterAction = mapping.exitMod ~= false,
  }
end)

hs.fnutils.each(listOfNotesModalBindSpec, u.bindModalMapping)

local notesModalBindings = u.modalBindSpecToString(listOfNotesModalBindSpec)

u.bindModalMapping {
  modal = leaderModal,
  key = 'n',
  description = 'Notes',
  action = function()
    notesModal:enter()
    u.alert(notesModalBindings)
  end,
  exitModalAfterAction = true,
}

------------------------------
-- `Screenshot bindings
------------------------------

local screenshotModal = u.createModal {
  modalName = 'Screenshot',
}

local listOfScreenshotModalBindSpec = hs.fnutils.map({
  { key = 'u', mods = { 'cmd', 'shift' }, executeKey = '3', desc = 'Screen to desktop' },
  { key = 'i', mods = { 'cmd', 'shift' }, executeKey = '4', desc = 'Area to desktop' },
  { key = 'j', mods = { 'ctrl', 'cmd', 'shift' }, executeKey = '3', desc = 'Screen and copy' },
  { key = 'k', mods = { 'ctrl', 'cmd', 'shift' }, executeKey = '4', desc = 'Area and copy' },
  { key = 'r', mods = { 'cmd', 'shift' }, executeKey = '5', desc = 'Record screen' },
}, function(mapping)
  return {
    modal = screenshotModal,
    key = mapping.key,
    description = mapping.desc,
    action = function() u.sendKey(mapping.mods, mapping.executeKey) end,
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

------------------------------
-- Sub-`Leader` modal bindings
------------------------------

local listOfLeaderModalBindSpec = hs.fnutils.map({
  { key = 'a', description = '+applications', modal = applicationsModal, modalBindings = applicationsModalBindings },
  { key = 'b', description = '+browser', modal = browserModal, modalBindings = browserModalBindings },
  { key = 'c', description = '+calendar', modal = calendarModal, modalBindings = calendarModalBindings },
  { key = 'e', description = '+execute', modal = executeModal, modalBindings = executeModalBindings },
  { key = 'n', description = '+notes', modal = notesModal, modalBindings = notesModalBindings },
  { key = 'r', description = '+reminders', modal = remindersModal, modalBindings = remindersModalBindings },
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

------------------------------

hs.alert.show 'Configuration reloaded'

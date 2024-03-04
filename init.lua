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
-------------------------------------- `Views` modal -----------------------------------------------
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
  { key = 'c', appName = 'Calendar' },
  { key = 'd', appName = 'Docker Desktop', description = 'Docker' },
  { key = 'f', appName = 'Finder' },
  { key = 'h', appName = 'Hammerspoon' },
  { key = 'i', appName = 'IntelliJ IDEA', description = 'IDEA' },
  { key = 'k', appName = 'Kitty' },
  { key = 'r', appName = 'Reminders' },
  { key = 'm', appName = 'Mail' },
  { key = 'n', appName = 'Notes' },
  { key = 'p', appName = 'NordPass', description = 'Passwords' },
  { key = 's', appName = 'Slack' },
  { key = 't', appName = 'Telegram' },
  { key = 'w', appName = 'Microsoft Teams (work or school)', description = 'Work messenger' },
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
  { key = 'b', description = 'Brightness down', systemKey = 'BRIGHTNESS_DOWN' },
  { key = 'f', description = 'Fast forward', systemKey = 'FAST' },
  { key = 'g', description = 'Brightness up', systemKey = 'BRIGHTNESS_UP' },
  { key = 'l', description = 'Lock screen', action = hs.caffeinate.lockScreen },
  { key = 'm', description = 'Mute', action = function() u.sendSystemKey 'MUTE' end },
  { key = 'n', description = 'Next track', systemKey = 'NEXT' },
  { key = 'p', description = 'Previous track', systemKey = 'PREVIOUS' },
  { key = 'r', description = 'Rewind', systemKey = 'REWIND' },
  { key = 's', description = 'Sound down', systemKey = 'SOUND_DOWN' },
  { key = 'w', description = 'Sound up', systemKey = 'SOUND_UP' },
  { key = 'y', description = 'Play', action = function() u.sendSystemKey 'PLAY' end },
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
---------------------------------- `Execute` modal -------------------------------------------------
----------------------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------------------
---------------------------------- `Browser` modal -------------------------------------------------
----------------------------------------------------------------------------------------------------

local browserModal = u.createModal {
  modalName = 'Execute',
}

local listOfBrowserModalBindSpec = hs.fnutils.map(
  {
    {
      key = 't',
      description = 'Browse in current workspace',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 't',
          applicationName = 'Arc',
        }
      end,
    },
    {
      key = 'c',
      description = 'Open command bar',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'l',
          applicationName = 'Arc',
        }
      end,
    },
    {
      key = 'n',
      description = 'New small tab for quick search',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'alt', 'cmd' },
          key = 'n',
          applicationName = 'Arc',
        }
      end,
    },
    {
      key = 'v',
      description = 'Create vertical split',
      action = function()
        hs.application.launchOrFocus 'Arc'

        u.sendKeyToApplication {
          modifiers = { 'ctrl', 'shift' },
          key = '=',
          interval = 5,
          applicationName = 'Arc',
        }
      end,
    },
    -- Immediately switch to the specified workspace and open a new tab.
    -- The sleep is necessary to give the workspace switcher time to open.
    -- The delay for the key stroke is flaky, so we need to manually give it a little time to work.
    {
      key = 'i',
      description = 'Search/open tab in [Innovecs] workspace',
      action = function()
        hs.application.launchOrFocus 'Arc'

        u.sleep(10)

        u.sendKeyToApplication {
          modifiers = { 'ctrl' },
          key = '3',
          applicationName = 'Arc',
        }

        u.sleep(200)

        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 't',
          applicationName = 'Arc',
        }
      end,
    },
    {
      key = 'm',
      description = 'Search/open tab in [Miro] workspace',
      action = function()
        hs.application.launchOrFocus 'Arc'

        u.sleep(10)

        u.sendKeyToApplication {
          modifiers = { 'ctrl' },
          key = '2',
          applicationName = 'Arc',
        }

        u.sleep(200)

        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 't',
          applicationName = 'Arc',
        }
      end,
    },
    {
      key = 'p',
      description = 'Search/open tab in [Personal] workspace',
      action = function()
        hs.application.launchOrFocus 'Arc'

        u.sleep(10)

        u.sendKeyToApplication {
          modifiers = { 'ctrl' },
          key = '1',
          applicationName = 'Arc',
        }

        u.sleep(200)

        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 't',
          applicationName = 'Arc',
        }
      end,
    },
  },
  function(mapping)
    return {
      modal = browserModal,
      key = mapping.key,
      description = mapping.description,
      action = mapping.action,
      exitModalAfterAction = true,
    }
  end
)

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

----------------------------------------------------------------------------------------------------
--------------------------------- `Reminders` modal ------------------------------------------------
----------------------------------------------------------------------------------------------------

local remindersModal = u.createModal {
  modalName = 'Reminders',
}

local listOfRemindersModalBindSpec = hs.fnutils.map(
  {
    {
      key = 'n',
      description = 'New reminder',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'n',
          applicationName = 'Reminders',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = 'i',
      description = 'Indent task',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = ']',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'o',
      description = 'Outdent task',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '[',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 's',
      description = 'Show subtasks',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'e',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'h',
      description = 'Hide subtasks',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'shift' },
          key = 'e',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'f',
      description = 'Flag/unflag task',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'shift' },
          key = 'f',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'c',
      description = 'Complete/uncomplete task',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'shift' },
          key = 'c',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = '.',
      description = 'Show/hide completed tasks',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'shift' },
          key = 'h',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'b',
      description = 'Toggle sidebar',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'alt', 'cmd' },
          key = 's',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 't',
      description = 'Set due today',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 't',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'd',
      description = 'Set due tomorrow',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'alt' },
          key = 't',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'o',
      description = 'Set overdue to today',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'ctrl' },
          key = 't',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'e',
      description = 'Set due this/next weekend',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'k',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = 'w',
      description = 'Set due next week',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'alt' },
          key = 'k',
          applicationName = 'Reminders',
        }
      end,
    },
    {
      key = '1',
      description = 'Go to Today list',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '1',
          applicationName = 'Reminders',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = '2',
      description = 'Go to Scheduled',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '2',
          applicationName = 'Reminders',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = '3',
      description = 'Go to All',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '3',
          applicationName = 'Reminders',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = '4',
      description = 'Go to Flagged',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '4',
          applicationName = 'Reminders',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = '5',
      description = 'Go to Completed',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '5',
          applicationName = 'Reminders',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = '6',
      description = 'Go to Inbox',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '6',
          applicationName = 'Reminders',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
  },
  function(mapping)
    return {
      modal = remindersModal,
      key = mapping.key,
      description = mapping.description,
      action = mapping.action,
      exitModalAfterAction = true,
    }
  end
)

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

----------------------------------------------------------------------------------------------------
---------------------------------- `Calendar` modal ------------------------------------------------
----------------------------------------------------------------------------------------------------

local calendarModal = u.createModal {
  modalName = 'Calendar',
}

local listOfCalendarModalBindSpec = hs.fnutils.map(
  {
    -- Calendar shortcuts
    {
      key = 't',
      description = 'Go to today',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 't',
          applicationName = 'Calendar',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = 's',
      description = 'Go to a specific date',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'shift' },
          key = 't',
          applicationName = 'Calendar',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = 'd',
      description = 'Switch to Day view',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '1',
          applicationName = 'Calendar',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = 'w',
      description = 'Switch to Week view',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '2',
          applicationName = 'Calendar',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = 'm',
      description = 'Switch to Month view',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '3',
          applicationName = 'Calendar',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = 'y',
      description = 'Switch to Year view',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '4',
          applicationName = 'Calendar',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    -- Event shortcuts
    {
      key = 'n',
      description = 'Add a new event',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'n',
          applicationName = 'Calendar',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
    },
    {
      key = 'e',
      description = 'Edit the selected event',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'e',
          applicationName = 'Calendar',
        }
      end,
    },
    {
      key = 'i',
      description = 'Show information for a calendar or event',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'i',
          applicationName = 'Calendar',
        }
      end,
    },
  },
  function(mapping)
    return {
      modal = calendarModal,
      key = mapping.key,
      description = mapping.description,
      action = mapping.action,
      exitModalAfterAction = true,
    }
  end
)

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

----------------------------------------------------------------------------------------------------
------------------------------------ `Notes` modal -------------------------------------------------
----------------------------------------------------------------------------------------------------

local notesModal = u.createModal {
  modalName = 'Notes',
}

local listOfNotesModalBindSpec = hs.fnutils.map(
  {
    {
      key = 'n',
      description = 'Create a new note',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'n',
          applicationName = 'Notes',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'd',
      description = 'Duplicate the existing note',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'd',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = '1',
      description = 'Show notes in a list',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '1',
          applicationName = 'Notes',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = '2',
      description = 'Show notes in gallery view',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '2',
          applicationName = 'Notes',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = '3',
      description = 'Show attachments',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = '3',
          applicationName = 'Notes',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'b',
      description = 'Show or hide folders bar',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd', 'alt' },
          key = 's',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'f',
      description = 'Find note',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'alt', 'cmd' },
          key = 'f',
          applicationName = 'Notes',
          shouldFocusBeforeKeyEvent = true,
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'a',
      description = 'Add a table',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'alt', 'cmd' },
          key = 't',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'l',
      description = 'Insert a link',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = 'k',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 't',
      description = 'Apply Title format',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'shift', 'cmd' },
          key = 't',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'h',
      description = 'Apply Heading format',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'shift', 'cmd' },
          key = 'h',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 's',
      description = 'Apply Subheading format',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'shift', 'cmd' },
          key = 'j',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'p',
      description = 'Apply plain text format',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'shift', 'cmd' },
          key = 'b',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'm',
      description = 'Apply Monospaced format',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'shift', 'cmd' },
          key = 'm',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'q',
      description = 'Apply Block Quote format',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'cmd' },
          key = "'",
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'c',
      description = 'Create a checklist',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'shift', 'cmd' },
          key = 'l',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'u',
      description = 'Mark/unmark a checklist item',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'shift', 'cmd' },
          key = 'u',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = true,
    },
    {
      key = 'k',
      description = 'Move checklist item up',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'ctrl', 'cmd' },
          key = 'up',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = false,
    },
    {
      key = 'j',
      description = 'Move checklist item down',
      action = function()
        u.sendKeyToApplication {
          modifiers = { 'ctrl', 'cmd' },
          key = 'down',
          applicationName = 'Notes',
        }
      end,
      exitModalAfterAction = false,
    },
  },
  function(mapping)
    return {
      modal = notesModal,
      key = mapping.key,
      description = mapping.description,
      action = mapping.action,
      exitModalAfterAction = mapping.exitModalAfterAction,
    }
  end
)

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

----------------------------------------------------------------------------------------------------
---------------------------------- `Screenshot bindings --------------------------------------------
----------------------------------------------------------------------------------------------------

local screenshotModal = u.createModal {
  modalName = 'Screenshot',
}

local listOfScreenshotModalBindSpec = hs.fnutils.map({
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
  {
    mappedKey = 'u',
    modifiers = { 'cmd', 'shift' },
    executeKey = '3',
    description = 'Capture screen and save to desktop',
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

----------------------------------------------------------------------------------------------------

hs.alert.show 'Configuration reloaded'

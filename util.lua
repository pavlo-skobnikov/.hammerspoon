local MODULE = {}

----------------------------------------------------------------------------------------------------
---------------------------------- Utility functions -----------------------------------------------
----------------------------------------------------------------------------------------------------

-- Sends a notification with the given title and message with a custome style.
---@param alert string
function MODULE.alert(alert)
  hs.alert.closeAll()
  hs.alert.show(alert, {
    strokeWidth = 0,
    strokeColor = { white = 1, alpha = 1 },
    fillColor = { white = 0, alpha = 0.75 },
    textColor = { white = 1, alpha = 1 },
    textFont = '.AppleSystemUIFont',
    textSize = 15,
    radius = 15,
    atScreenEdge = 2,
    fadeInDuration = 0.15,
    fadeOutDuration = 0.05,
    padding = nil,
  }, nil, 0.01)
end

-- Posts a single keystroke to the system.
---@param mods string[] | nil
---@param key string
function MODULE.sendKey(mods, key)
  if mods == nil then mods = {} end

  hs.eventtap.keyStroke(mods, key)
end

-- Sends a key stroke to the application with the exact given name.
---@param spec ApplicationKeyStrokeSpec
function MODULE.sendKeyToApplication(spec)
  local application = hs.application.get(spec.appName)

  if application then
    if spec.focusApp then application:setFrontmost() end

    local modifiers = spec.mods and spec.mods or {}
    local interval = spec.msDelay and spec.msDelay * 1000 or 0

    hs.eventtap.keyStroke(modifiers, spec.key, interval, application)
  else
    MODULE.alert('No application found with the name ' .. spec.appName)
  end
end

-- Posts a system key event to the system.
---@param keyEvent string
function MODULE.sendSystemKey(keyEvent)
  hs.eventtap.event.newSystemKeyEvent(keyEvent, true):post()
  hs.eventtap.event.newSystemKeyEvent(keyEvent, false):post()
end

-- Launches or focuses a Chrome window with the given profile name.
---@param profileName string
function MODULE.launchOrFocusChromeProfileWindow(profileName)
  local chromeWindows = hs.application.find('Google Chrome'):allWindows()

  local windowToFocus = nil

  for _, window in ipairs(chromeWindows) do
    if string.match(window:title(), profileName) then windowToFocus = window end
  end

  if windowToFocus then
    windowToFocus:focus()
  else
    MODULE.alert('No Chrome window found for ' .. profileName .. ' profile')
  end
end

-- Sleeps for the given amount of interval in milliseconds.
-- Useful for delaying some key stroke after trying to focus a window.
---@param msDelay number
function MODULE.sleep(msDelay)
  hs.timer.usleep(msDelay * 1000)
end

----------------------------------------------------------------------------------------------------
-------------------------------- Modal helper functions --------------------------------------------
----------------------------------------------------------------------------------------------------

-- Creates a modal with the given specification. Additionally,
-- attaches `entered` and `exited` callback functions to the modal and
-- binds the `escape` key to exit the modal.
---@param spec CreateModalSpec
---@return Modal
function MODULE.createModal(spec)
  local modifiers = spec.modifiers and spec.modifiers or {}

  local modal = hs.hotkey.modal.new(modifiers, spec.key)

  function modal:entered() MODULE.alert(spec.modalName) end

  modal:bind('', 'escape', function()
    modal:exit()
    MODULE.alert('Exiting ' .. spec.modalName)
  end)

  return modal
end

-- Binds the given action to the given key for the given modal.
-- Conditionally exits the modal after the action is performed.
---@param spec ModalBindSpec
function MODULE.bindModalMapping(spec)
  local shouldExitModal = spec.exitModalAfterAction and spec.exitModalAfterAction or false

  local action

  if shouldExitModal then
    action = function()
      spec.action()
      spec.modal:exit()
    end
  else
    action = spec.action
  end

  spec.modal:bind('', spec.key, action)
end

-- Transforms a modal bind specification into a description string in the format:
-- `key1: description1`
-- `key2: description2`
-- ...
-- `keyN: descriptionN`
---@param listOfSpec ModalBindSpec[]
function MODULE.modalBindSpecToString(listOfSpec)
  local description = ''

  for i, mappings in ipairs(listOfSpec) do
    description = description .. mappings.key .. ':\t' .. mappings.description

    if i < #listOfSpec then description = description .. '\n' end
  end

  return description
end

----------------------------------------------------------------------------------------------------

return MODULE

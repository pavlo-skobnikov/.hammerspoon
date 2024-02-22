---@class Modal
---@field bind function
---@field enter function
---@field entered function
---@field exit function
---@field exited function

---@class CreateModalSpec
---@field modifiers string | string[] | nil
---@field key string | nil
---@field modalName string

---@class ModalBindSpec
---@field modal Modal
---@field key string
---@field description string
---@field action function
---@field exitModalAfterAction boolean | nil

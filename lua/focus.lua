local M = {}

M.enable = true -- Default to enabled
M.height_compatible = false
M.width = 120 --> Default to 120 for now
M.height = 0 --> Don't set height by default for now
M.focus_init = function()
    if M.width == nil then M.width = 120 end --> Catch exceptions in case people set values to nil in their init.lua
    if M.height == nil then M.height = 0 end
    if M.enable == true then
    require 'modules.autocmd'.setup(M.width,M.height)
    end
end

return M

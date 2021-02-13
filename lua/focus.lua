local M = {}

M.focus = true -- Default to enabled
M.height_compatible = false
M.width = 120 --> Default to 120 for now
M.height = 0 --> Don't set height by default for now
M.focus_init = function()
    if M.focus == true then
    require 'modules.autocmd'.setup(M.width,M.height)
    end
end

return M

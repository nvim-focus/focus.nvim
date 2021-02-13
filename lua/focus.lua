local M = {}

M.focus = true -- Default to true
M.width = 50
M.focus_init = function()
    if M.focus == true then
    require 'modules.autocmd'.setup(M.width)
    end
end

return M

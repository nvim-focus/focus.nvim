-- require 'modules.resizer'.split_resizer()

--[[ local ft = vim.bo.ft --> Get vim filetype using nvim api
function split_resizer()
    print("test")
    if ft == 'NvimTree' or 'NerdTree' then return
    elseif ft == 'qf' then
        vim.o.winwidth = 10
        return
    else
        -- vim.o.winwidth = 120
    end
end ]]


local M = {}

M.focus = true -- Default to true
M.width = 50
M.focus_init = function()
    if M.focus == true then
    require 'modules.autocmd'.setup(M.width)
    end
end



return M

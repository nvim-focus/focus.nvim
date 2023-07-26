local utils = require('focus.modules.utils')
local cmd = vim.cmd
local M = {}

M.focus_enable = function()
    if not utils.is_disabled() then
        return
    end

    vim.g.focus_disable = false
    require('focus.modules.resizer').goal = 'autoresize'
    require('focus').resize()
end

M.focus_disable = function()
    if utils.is_disabled() then
        return
    end

    vim.g.focus_disable = true
    cmd('wincmd=')
end

M.focus_toggle = function()
    if utils.is_disabled() then
        M.focus_enable()

        return
    end

    M.focus_disable()
end

M.focus_maximise = function()
    require('focus.modules.resizer').goal = 'maximise'
    require('focus').resize()
end

M.focus_equalise = function()
    require('focus.modules.resizer').goal = 'equalise'
    require('focus').resize()
end

M.focus_autoresize = function()
    require('focus.modules.resizer').goal = 'autoresize'
    require('focus').resize()
end

M.focus_max_or_equal = function()
    local winwidth = vim.fn.winwidth(vim.api.nvim_get_current_win())
    if winwidth > vim.o.columns / 2 then
        M.focus_equalise()
    else
        M.focus_maximise()
    end
end

return M

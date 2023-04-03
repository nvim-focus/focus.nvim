local utils = require('focus.modules.utils')
local cmd = vim.cmd
local M = {}

M.focus_enable = function()
    if not utils.is_disabled() then
        return
    end

    vim.g.focus_disable = false
    require('focus').resize()
end

M.focus_disable = function()
    if utils.is_disabled() then
        return
    end

    vim.g.enabled_focus_resizing = 0
    vim.o.winminwidth = 0
    vim.o.winwidth = 20
    vim.o.winminheight = 1
    vim.o.winheight = 1
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
	-- we add +1 just incase winminwidth or height is full width/height
	vim.o.winwidth = vim.o.columns + 1
	vim.o.winheight = vim.o.lines + 1
end

M.focus_equalise = function()
	vim.o.winminwidth = 0
	vim.o.winwidth = 20
	vim.o.winminheight = 1
	vim.o.winheight = 1
	cmd('wincmd=')
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

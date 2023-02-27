local config = require('focus.modules.config')
local commands = require('focus.modules.commands')
local autocmd = require('focus.modules.autocmd')
local split = require('focus.modules.split')
local functions = require('focus.modules.functions')
local resizer = require('focus.modules.resizer')

local M = {}

M.setup = function(options)
	--load the configs
	setmetatable(M, {
		__newindex = config.set,
		__index = config.get,
	})
	-- if options provided to setup, override defaults
	if options ~= nil then
		for k, v1 in pairs(options) do
			config.defaults[k] = v1
		end
	end
	-- Verify that configuration values are of the correct type
	config.verify()

	-- Don't set up focus if its not enabled by the user
	if M.enable then
		-- Focus is enabled when setup is run, we use this var to enable/disable/toggle
		vim.g.enabled_focus_resizing = 1
		-- Pass this module M, noting that `__index` actually references the
		-- configuration module, to setup the autocmds used for this plugin
		autocmd.setup(M)
		if M.commands then
			commands.setup()
		end

		if M.winhighlight then
			if vim.fn.has('nvim-0.9') then
				vim.api.nvim_set_hl(0, 'FocusedWindow', { link = 'VertSplit'})
				vim.api.nvim_set_hl(0, 'UnfocusedWindow', { link = 'Normal'})
			else
				vim.highlight.link('FocusedWindow', 'VertSplit', true)
				vim.highlight.link('UnfocusedWindow', 'Normal', true)
			end

			vim.wo.winhighlight = 'Normal:FocusedWindow,NormalNC:UnfocusedWindow'
		end

		-- Finally begin resizing when enabled and configs set
		if config.autoresize then
			M.resize()
		end
	end
end

M.resize = function()
	resizer.split_resizer(M)
end

-- Exported internal functions for use in commands
function M.split_nicely(args)
	if args == nil then
		args = ''
	end
	split.split_nicely(args, M.bufnew)
end

function M.split_command(direction, args)
	args = args or ''
	split.split_command(direction, args, M.tmux, M.bufnew)
end

function M.split_cycle(reverse)
	split.split_cycle(reverse, M.bufnew)
end

function M.focus_enable()
	functions.focus_enable()
end

function M.focus_disable()
	functions.focus_disable()
end

function M.focus_toggle()
	functions.focus_toggle()
end

function M.focus_maximise()
	functions.focus_maximise()
end

function M.focus_equalise()
	functions.focus_equalise()
end

function M.focus_max_or_equal()
	functions.focus_max_or_equal()
end

function M.focus_disable_window()
	table.insert(M.excluded_windows, vim.api.nvim_get_current_win())
end

function M.focus_enable_window()
	for k, v in pairs(M.excluded_windows) do
		if v == vim.api.nvim_get_current_win() then
			table.remove(M.excluded_windows, k)
		end
	end
end

function M.focus_toggle_window()
	for _, v in pairs(M.excluded_windows) do
		if v == vim.api.nvim_get_current_win() then
			M.focus_enable_window()
			return
		end
	end
	M.focus_disable_window()
end

function M.focus_get_disabled_windows()
	print('------------------')
	print('█▀ ▄▀▄ ▄▀▀ █ █ ▄▀▀')
	print('█▀ ▀▄▀ ▀▄▄ ▀▄█ ▄██')
	print('------------------')
	print('Disabled Windows')
	for _, v in pairs(M.excluded_windows) do
		print('- ' .. v)
	end
	print('-------------------')
	print('Current Window')
	print('- ' .. vim.api.nvim_get_current_win())
	print('-------------------')
end

return M

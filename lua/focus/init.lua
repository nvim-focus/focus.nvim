local config = require('focus.modules.config')
local commands = require('focus.modules.commands')
local autocmd = require('focus.modules.autocmd')
local resizer = require('focus.modules.resizer')
local split = require('focus.modules.split')
local functions = require('focus.modules.functions')

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
		commands.setup()

		if M.winhighlight then
			vim.cmd('hi default link FocusedWindow VertSplit')
			vim.cmd('hi default link UnfocusedWindow Normal')

			vim.wo.winhighlight = 'Normal:FocusedWindow,NormalNC:UnfocusedWindow'
		end

		-- Finally begin resizing when enabled and configs set
		M.resize()
	end
end

M.resize = function()
	resizer.split_resizer(M)
end

-- Exported internal functions for use in commands
function M.split_nicely()
	split.split_nicely()
end

function M.split_command(direction, fileName)
	fileName = fileName or ''
	split.split_command(direction, fileName, M.tmux)
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

return M

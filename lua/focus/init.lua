local config = require('focus.modules.config')
local commands = require('focus.modules.commands')
local autocmd = require('focus.modules.autocmd')
local resizer = require('focus.modules.resizer')
local split = require('focus.modules.split')
local functions = require('focus.modules.functions')

local M = {}

M.setup = function(options)
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
	config.verify()
	M.init()
end

M.init = function()
	-- Verify that configuration values are of the correct type

	if M.enable == true then
		-- Pass this module, noting that `__index` actually references the
		-- configuration module, to setup the autocmds used for this plugin
		commands.setup()
		autocmd.setup(M)
		resizer.split_resizer(M)

		if M.winhighlight then
			-- Allows user-overridable highlighting of the focused window
			--
			-- See `:h hi-default` for more details
			vim.cmd('hi default link FocusedWindow VertSplit')
			vim.cmd('hi default link UnfocusedWindow Normal')

			vim.wo.winhighlight = 'Normal:FocusedWindow,NormalNC:UnfocusedWindow'
		end
	end
end

-- Exported internal functions for use in commands etc
function M.split_nicely()
	split.split_nicely()
end

function M.split_command(direction, fileName)
	fileName = fileName or ''
	split.split_command(direction, fileName)
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

return M

local utils = require('focus.modules.utils')
local vim = vim
local cmd = vim.api.nvim_command
local M = {}

local golden_ratio = 1.618

local function process_split_args(created, args)
	local args_array = utils.split(args, ' ')
	print(args_array[1])
	-- print('2 is '..args_array[2])
	if args_array[1] ~= '' and args_array[1] ~= 'cmd' then
		cmd('edit ' .. args_array[1])
	elseif args_array[1] == 'cmd' and args_array[2] ~= nil then
		cmd('enew')
		cmd(args_array[2])
	elseif created == true then
		cmd('enew')
	end
end

local golden_ratio_split_cmd = function(winnr)
	local maxwidth = vim.o.columns
	local winwidth = vim.fn.winwidth(winnr)
	local textwidth = vim.bo.textwidth

	if textwidth > 0 and winwidth > math.floor(textwidth * golden_ratio) then
		return 'vsplit'
	end

	if winwidth > math.floor(maxwidth / golden_ratio) then
		return 'vsplit'
	end

	return 'split'
end

local split_ENOROOM = function(err)
	-- err: Vim(split):E36: Not enough room
	return string.match(err, 'Vim([a-z]split):E36:.*')
end

function M.split_nicely(args)
	vim.g.counter_focus_resizing = vim.g.counter_focus_resizing + 1
	local winnr = vim.api.nvim_get_current_win()
	local split_cmd = golden_ratio_split_cmd(winnr)

	if vim.g.counter_focus_resizing > 2 then
		cmd('wincmd w')
	end

	local _, e = xpcall(cmd, split_ENOROOM, split_cmd)
	if e then
		if split_cmd == 'split' then
			vim.o.minwinheight = vim.o.minwinheight / 2
		else
			vim.o.minwinwidth = vim.o.minwinwidth / 2
		end
	end

	-- splitright.. ensure that whenever you split vertically, it’s going to appear on the right.
	-- Moreover, for a horizontal split, the new split is going to appear at the bottom.
	-- always returns false/nil below when not set by user
	-- we check it because when splitbelow/right is set, wincmd happens automatically
	if split_cmd == 'vsplit' and not vim.o.splitright then
		cmd('wincmd p')
	end

	if split_cmd == 'split' and not vim.o.splitbelow then
		cmd('wincmd p')
	end

	--open file or term .. etc if args provided
	process_split_args(true, args)
end

function M.split_command(direction, args, tmux)
	local winnr = vim.api.nvim_get_current_win()
	cmd('wincmd ' .. direction)

	local created = false
	if winnr == vim.api.nvim_get_current_win() then
		created = true
		if tmux == true then
			vim.fn.system('tmux select-pane -' .. vim.fn.tr(direction, 'phjkl', 'lLDUR'))
		elseif direction == 'h' or direction == 'l' then
			cmd('wincmd v')
		elseif direction == 'j' or direction == 'k' then
			cmd('wincmd s')
		end
		cmd('wincmd ' .. direction)
	end
	process_split_args(created, args)
end

function M.split_cycle()
	local winnr = vim.api.nvim_get_current_win()
	cmd('wincmd w')

	if winnr == vim.api.nvim_get_current_win() then
		cmd('wincmd v')
		cmd('wincmd w')
	end
end

return M

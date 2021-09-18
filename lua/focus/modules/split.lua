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

local function move_back(direction)
	if direction == 'h' then
		return 'l'
	elseif direction == 'l' then
		return 'h'
	elseif direction == 'j' then
		return 'k'
	elseif direction == 'k' then
		return 'j'
	end
end

local split_ENOROOM = function(err)
	-- err: Vim(split):E36: Not enough room
	return string.match(err, 'Vim([a-z]split):E36:.*')
end

function M.split_nicely(args)
	local winnr = vim.api.nvim_get_current_win()
	local split_cmd = golden_ratio_split_cmd(winnr)

	if #vim.api.nvim_tabpage_list_wins({0}) == 4 then
		cmd('wincmd w')
	end

	local _, e = xpcall(cmd, split_ENOROOM, split_cmd)
	if e then
		if split_cmd == 'split' then
			vim.o.minwinheight = vim.o.minwinheight / 2
			-- vim.api.nvim_win_set_height(winnr, vim.api.nvim_win_get_height(winnr))
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

	local created = false
	if M.split_exists_direction(winnr, direction) == false then
		created = true
		if tmux == true then
			vim.fn.system('tmux select-pane -' .. vim.fn.tr(direction, 'phjkl', 'lLDUR'))
		elseif direction == 'h' or direction == 'l' then
			cmd('wincmd v')
			cmd('wincmd ' .. direction)
		elseif direction == 'j' or direction == 'k' then
			print('hi')
			cmd('wincmd s')
			cmd('wincmd ' .. direction)
		end
	else
		cmd('wincmd ' .. direction)
	end
	process_split_args(created, args)
end

function M.split_cycle(reverse)
	local winnr = vim.api.nvim_get_current_win()
	cmd('wincmd w')

	if winnr == vim.api.nvim_get_current_win() then
			cmd('wincmd v')
		if reverse == nil or reverse ~= 'reverse' then
			cmd('wincmd w')
		end
        cmd('enew')
	end
end

function M.split_exists_direction(winnr, direction)
	cmd('wincmd ' .. direction)
	if winnr == vim.api.nvim_get_current_win() then
		return false
	else
		-- we want to stay in the current split we were in
		cmd('wincmd ' .. move_back(direction))
		return true
	end
end

return M

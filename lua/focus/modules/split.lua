local vim = vim --> Use locals
local cmd = vim.api.nvim_command

local M = {}

local golden_ratio = 1.618

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

function M.split_nicely()
	local winnr = vim.api.nvim_get_current_win()
	local split_cmd = golden_ratio_split_cmd(winnr)

	local _, e = xpcall(cmd, split_ENOROOM, split_cmd)
	if e then
		if split_cmd == 'split' then
			vim.o.minwinheight = vim.o.minwinheight / 2
		else
			vim.o.minwinwidth = vim.o.minwinwidth / 2
		end
	end

	if split_cmd == 'vsplit' and not vim.o.splitright then
		cmd('wincmd p')
	end

	if split_cmd == 'split' and not vim.o.splitbelow then
		cmd('wincmd p')
	end
end

function M.split_command(direction, fileName, tmux)
	local winnr = vim.api.nvim_get_current_win()
	cmd('wincmd ' .. direction)

	if winnr == vim.api.nvim_get_current_win() then
		if tmux == true then
			vim.fn.system('tmux select-pane -' .. vim.fn.tr(direction, 'hjkl', 'lLDUR'))
		elseif direction == 'h' or direction == 'l' then
			cmd('wincmd v')
		elseif direction == 'j' or direction == 'k' then
			cmd('wincmd s')
		end
	end
	cmd('wincmd ' .. direction)
	if fileName ~= '' then
		cmd('edit ' .. fileName)
	else
		cmd('enew')
	end
end

return M

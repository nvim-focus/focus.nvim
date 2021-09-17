local utils = require('focus.modules.utils')
local split = require('focus.modules.split')
local vim = vim
local M = {}

local golden_ratio = 1.618

local golden_ratio_width = function()
	local maxwidth = vim.o.columns
	return math.floor(maxwidth / golden_ratio)
end

local golden_ratio_minwidth = function()
	return math.floor(golden_ratio_width() / (3 * golden_ratio))
end

local golden_ratio_height = function()
	local maxheight = vim.o.lines
	return math.floor(maxheight / golden_ratio)
end

local golden_ratio_minheight = function()
	return math.floor(golden_ratio_height() / (3 * golden_ratio))
end

-- TEST: floating windows, snap/telescope, toggleterm, trees, scrollview.nvim, blank buffer, popups during autocompletion i.e coq
function M.split_resizer(config) --> Only resize normal buffers, set qf to 10 always
	local winnr = vim.api.nvim_get_current_win()
	--[[ local curwidth = vim.api.nvim_win_get_width(winnr)
	local curheight = vim.api.nvim_win_get_height(vim.api.nvim_get_current_win())
	local maxwidth = vim.o.columns
	local maxheight = vim.o.lines ]]
	local ft = vim.bo.ft:lower()
	local bt = vim.bo.buftype:lower()
	local filetrees_set = utils.to_set(utils.to_lower(config.compatible_filetrees))
	local excluded_ft_set = utils.to_set(utils.to_lower(config.excluded_filetypes))
	local excluded_bt_set = utils.to_set(utils.to_lower(config.excluded_buftypes))
	print(ft)
	if vim.g.enabled_focus_resizing == 0 then
		return
	--[[ elseif ft == '' or ft == nil then
		return ]]
	elseif ft == 'diffviewfiles' then
		vim.cmd('FocusEqualise')
	elseif ft == 'spectre_panel' then
		return 		--[[ vim.o.winminheight = 0
		vim.o.winheight = 1
		vim.o.winminwidth = 0
		vim.o.winwidth = 1 ]]
vim.cmd('vertical resize 90')
	elseif excluded_bt_set[bt] or excluded_ft_set[ft] then
		return
		--[[ vim.o.winminheight = 0
		vim.o.winheight = 1
		vim.o.winminwidth = 0
		vim.o.winwidth = 1 ]]
	elseif filetrees_set[ft] then
			vim.api.nvim_win_set_width(winnr, config.treewidth)
		-- vim.o.winwidth = config.treewidth
	elseif ft == 'qf' then
			vim.api.nvim_win_set_height(winnr, 10)
		-- vim.o.winheight = 10
	else
		if config.width > 0 then
			-- vim.o.winwidth = config.width
			vim.api.nvim_win_set_width(winnr, config.width)
			-- print(ft)
			-- vim.cmd('vertical resize '..golden_ratio_width())
		else
			-- vim.cmd('vertical resize '..golden_ratio_width())
			vim.api.nvim_win_set_width(winnr, golden_ratio_width())
			-- local curheight = vim.api.nvim_win_set_height(winnr)

			--[[ vim.o.winwidth = golden_ratio_width()
			vim.o.winminwidth = golden_ratio_minwidth() ]]
		end

		-- print(curheight)
		-- print(maxheight)
		if config.height > 0 then
			-- vim.o.winheight = config.height
			vim.api.nvim_win_set_height(winnr, config.height)
            -- if we don't check to this, it will resize height on a window with no splits
		elseif split.split_exists_direction(winnr, 'j') == true or split.split_exists_direction(winnr, 'k') == true then
			vim.api.nvim_win_set_height(winnr, golden_ratio_height())

			-- cmd('wincmd ' .. direction)
			-- vim.cmd('resize '..golden_ratio_height())
			--[[ vim.o.winheight = golden_ratio_height()
			vim.o.winminheight = golden_ratio_minheight() ]]
		end
	end
end

return M

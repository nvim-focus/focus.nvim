local utils = require('focus.modules.utils')
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
	-- FIXME: We have problems with snap fuzzy finder prompts ocassionally messed up, everything else seems fine
	local ft = vim.bo.ft:lower()
	local bt = vim.bo.buftype:lower()
	local filetrees_set = utils.to_set(config.compatible_filetrees)
	local excluded_ft_set = utils.to_set(config.excluded_filetypes)
	local excluded_bt_set = utils.to_set(config.excluded_buftypes)
	if vim.g.enabled_focus == 0 then
		return
	elseif excluded_bt_set[bt] or excluded_ft_set[ft] then
		vim.o.winminheight = 0
		vim.o.winheight = 1
		vim.o.winminwidth = 0
		vim.o.winwidth = 1
	elseif filetrees_set[ft] then
		vim.o.winwidth = config.treewidth
	elseif ft == 'qf' then
		vim.o.winheight = 10
	else
		if config.width > 0 then
			vim.o.winwidth = config.width
		else
			vim.o.winwidth = golden_ratio_width()
			vim.o.winminwidth = golden_ratio_minwidth()
		end

		if config.height > 0 then
			vim.o.winheight = config.height
		else
			vim.o.winheight = golden_ratio_height()
			vim.o.winminheight = golden_ratio_minheight()
		end
	end
end

return M

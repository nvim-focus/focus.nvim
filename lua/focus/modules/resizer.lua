local vim = vim --> Use locals

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

function M.split_resizer(config) --> Only resize normal buffers, set qf to 10 always
	local ft = vim.bo.ft
	if vim.g.enabled_focus == 0 then
		return
	elseif ft == 'NvimTree' or ft == 'nerdtree' or ft == 'CHADTree' then
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
		-- FIXME: Fix this mess
		--[[ if ft == 'toggleterm' then -- if we dont do something about the '' case, wilder.nvim resizes when searching with /
        vim.o.winminheight = 0
        vim.o.winheight = 1
        vim.o.winminwidth = 0
        vim.o.winwidth = 1 ]]
		-- end
	end
	-- FIXME: Placing this line here solves issue #38 but disables resize for blank buffer
	vim.o.winminheight = 0
	vim.o.winheight = 1
	vim.o.winminwidth = 0
	vim.o.winwidth = 1
	-- BUG: config.height is nil
	--[[ elseif config.height ~= 0 then
		vim.o.winheight = config.height --> Opt in to set height value, otherwise auto-size it ]]
	-- end
end

return M

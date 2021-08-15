local cmd = vim.api.nvim_command
local autocmd = {}

local function nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		cmd('augroup ' .. group_name)
		cmd('autocmd!')
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
			cmd(command)
		end
		cmd('augroup END')
	end
end

function autocmd.setup(config)
	local autocmds = {
		focus_init = {
			-- Resize files with typical naming convention *.* i.e focus.lua
			{ 'BufEnter', '*.*', ':lua require"focus".init()' },
			-- Resize files with no filetype
			{ 'Filetype', '', ':lua require"focus".init()' },
			-- Resize startify
			{ 'BufEnter', 'startify', ':lua require"focus".init()' },
			-- So that we can resize windows such as NvimTree correctly, we run init when we open a buffer
			{ 'BufEnter,WinEnter', 'NvimTree,nerdtree,CHADTree,qf', ":lua require'focus'.init()" },
		},
	}

	if config.signcolumn ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['focus_signcolumn'] = {
			{ 'BufEnter,WinEnter', '*', 'setlocal signcolumn=auto' },
			{ 'BufLeave,WinLeave', '*', 'setlocal signcolumn=no' },
		}
	end

	if config.cursorline ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['focus_cursorline'] = {
			{ 'BufEnter,WinEnter', '*', 'setlocal cursorline' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nocursorline' },
		}
	end
	if config.number ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['number'] = {
			{ 'BufEnter,WinEnter', '*', 'set number' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber' },
		}
	end
	if config.relativenumber ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['focus_relativenumber'] = {
			{ 'BufEnter,WinEnter', '*', 'set nonumber relativenumber' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber norelativenumber' },
		}
	end
	if config.hybridnumber ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['focus_hybridnumber'] = {
			{ 'BufEnter,WinEnter', '*', 'set number relativenumber' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber norelativenumber' },
		}
	end

	nvim_create_augroups(autocmds)
end

return autocmd

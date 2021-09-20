local cmd = vim.api.nvim_command
local M = {}

-- if focus auto signcolumn is set to true then
-- we assume it to be auto in case signcolumn = no
local function get_sign_column()
	local default_signcolumn = 'auto'
	if vim.opt.signcolumn:get() == 'no' then
		return default_signcolumn
	else
		return vim.opt.signcolumn:get()
	end
end

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

function M.setup(config)
	local autocmds = {
		focus_resize = {
			--Adding WinEnter breaks snap support..
			{ 'WinLeave,BufEnter', '*', ':lua require"focus".resize()' },
		},
	}
	if config.signcolumn then
		autocmds['focus_signcolumn'] = {
			{ 'BufEnter,WinEnter', '*', 'setlocal signcolumn=' .. get_sign_column() },
			{ 'BufLeave,WinLeave', '*', 'setlocal signcolumn=no' },
		}
	end

	if config.cursorline then
		autocmds['focus_cursorline'] = {
			{ 'BufEnter,WinEnter', '*', 'setlocal cursorline' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nocursorline' },
		}
	end
	-- FIXME: Disable line numbers on startify buffer, add user config?
	if config.number then
		autocmds['number'] = {
			{ 'BufEnter,WinEnter', '*', 'set number' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber' },
		}
	end
	if config.relativenumber then
		autocmds['focus_relativenumber'] = {
			{ 'BufEnter,WinEnter', '*', 'set nonumber relativenumber' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber norelativenumber' },
		}
	end
	if config.hybridnumber then
		autocmds['focus_hybridnumber'] = {
			{ 'BufEnter,WinEnter', '*', 'set number relativenumber' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber norelativenumber' },
		}
	end

	nvim_create_augroups(autocmds)
end

return M

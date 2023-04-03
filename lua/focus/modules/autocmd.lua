local utils = require('focus.modules.utils')
local vim = vim
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

function M.setup(config)
	local augroup = vim.api.nvim_create_augroup('Focus', { clear = true })

	if utils.is_disabled() then
		return
	end

	if config.autoresize then
		vim.api.nvim_create_autocmd({ 'BufEnter' }, {
			group = augroup,
			callback = function(_)
				vim.api.nvim_exec_autocmds('WinScrolled', {})
				require('focus').resize()
			end,
			desc = 'Resize window',
		})
	end

	if config.signcolumn then
		vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
			group = augroup,
			callback = function(_)
				if utils.is_disabled() then
					return
				end
				vim.wo.signcolumn = get_sign_column()
			end,
			desc = 'Enable signcolumn',
		})
		vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
			group = augroup,
			callback = function(_)
				vim.wo.signcolumn = 'no'
			end,
			desc = 'Disable signcolumn',
		})
	end

	if config.cursorline then
		vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
			group = augroup,
			callback = function(_)
				if utils.is_disabled() then
					return
				end
				vim.wo.cursorline = true
			end,
			desc = 'Enable cursorline',
		})
		vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
			group = augroup,
			callback = function(_)
				if utils.is_disabled() then
					return
				end
				vim.wo.cursorline = false
			end,
			desc = 'Disable cursorline',
		})
	end

	if config.number then
		vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
			group = augroup,
			callback = function(_)
				if utils.is_disabled() then
					return
				end
				vim.wo.number = true
			end,
			desc = 'Enable cursorline',
		})
		vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
			group = augroup,
			callback = function(_)
				vim.wo.number = false
			end,
			desc = 'Disable cursorline',
		})
	end

	if config.relativenumber then
		if config.absolutenumber_unfocussed then
			vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
				group = augroup,
				callback = function(_)
					if utils.is_disabled() then
						return
					end
					vim.wo.number = false
					vim.wo.relativenumber = true
				end,
				desc = 'Absolutnumber unfoccused enter',
			})
			vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
				group = augroup,
				callback = function(_)
					if utils.is_disabled() then
						return
					end
					vim.wo.number = true
					vim.wo.relativenumber = false
				end,
				desc = 'Absolutnumber unfoccused leave',
			})
		else
			vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
				group = augroup,
				callback = function(_)
					if utils.is_disabled() then
						return
					end
					vim.wo.number = false
					vim.wo.relativenumber = true
				end,
				desc = 'Absolutnumber foccused enter',
			})
			vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
				group = augroup,
				callback = function(_)
					if utils.is_disabled() then
						return
					end
					vim.wo.number = false
					vim.wo.relativenumber = false
				end,
				desc = 'Absolutnumber foccused leave',
			})
		end
	end
	if config.hybridnumber then
		if config.absolutenumber_unfocussed then
			vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
				group = augroup,
				callback = function(_)
					vim.wo.number = true
					vim.wo.relativenumber = true
				end,
				desc = 'Absolutenumber unfoccused enter',
			})
			vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
				group = augroup,
				callback = function(_)
					if utils.is_disabled() then
						return
					end
					vim.wo.number = true
					vim.wo.relativenumber = false
				end,
				desc = 'Absolutenumber unfoccused leave',
			})
		else
			vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
				group = augroup,
				callback = function(_)
					if utils.is_disabled() then
						return
					end
					vim.wo.number = true
					vim.wo.relativenumber = true
				end,
				desc = 'Hybrid number enter',
			})
			vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
				group = augroup,
				callback = function(_)
					if utils.is_disabled() then
						return
					end
					vim.wo.number = false
					vim.wo.relativenumber = false
				end,
				desc = 'Hybrid number leave',
			})
		end
	end

	if config.cursorcolumn then
		vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
			group = augroup,
			callback = function(_)
				if utils.is_disabled() then
					return
				end
				vim.wo.cursorcolumn = true
			end,
			desc = 'Cursor column enter',
		})
		vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
			group = augroup,
			callback = function(_)
				if utils.is_disabled() then
					return
				end
				vim.wo.cursorcolumn = false
			end,
			desc = 'Cursor column leave',
		})
	end

	if config.colorcolumn.enable then

		vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
			group = augroup,
			callback = function(_)
				if utils.is_disabled() then
					return
				end
				vim.wo.colorcolumn = config.colorcolumn.width
			end,
			desc = 'Color column enter',
		})
		vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
			group = augroup,
			callback = function(_)
				if utils.is_disabled() then
					return
				end
				vim.wo.colorcolumn = 0
			end,
			desc = 'Color column leave',
		})
	end
end

return M

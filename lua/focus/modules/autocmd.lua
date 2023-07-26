-- *focus.nvim* Have a nice view over your split windows
--
-- MIT License
--
-- Copyright (c) Beau Williams
-- Copyright (c) Andreas Schneider <asn@cryptomilk.org>
--
-- ============================================================================

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

    if config.autoresize.enable then
        local previous_win_id = 0

        vim.api.nvim_create_autocmd('WinEnter', {
            group = augroup,
            callback = function(_)
                -- This shouldn't be required with WinScrolled rewrite of 0.9
                if not vim.fn.has('nvim-0.9') then
                    vim.api.nvim_exec_autocmds('WinScrolled', {})
                end

                require('focus').resize()
            end,
            desc = 'Resize splits',
        })
        vim.api.nvim_create_autocmd('WinEnter', {
            group = augroup,
            callback = function(_)
                local current_win_id = vim.api.nvim_get_current_win()

                -- If we have a horizontal split, center the window so we keep
                -- the current line in view.
                if previous_win_id == 0 then
                    return
                end

                local cur_win_pos = vim.fn.win_screenpos(current_win_id)
                local prev_win_pos = vim.fn.win_screenpos(previous_win_id)

                -- If we switch between horizontal splits, center the window
                if cur_win_pos[2] == prev_win_pos[2] then
                    vim.api.nvim_win_call(previous_win_id, function()
                        pcall(vim.api.nvim_command, 'normal! zz')
                    end)
                end
            end,
            desc = 'Center window of previous horizontal split',
        })
        vim.api.nvim_create_autocmd('WinLeave', {
            group = augroup,
            callback = function(_)
                -- Remember the previous window id and cursor position
                previous_win_id = vim.api.nvim_get_current_win()
            end,
            desc = 'Save previous window id from split',
        })
        vim.api.nvim_create_autocmd('WinClosed', {
            group = augroup,
            callback = function(_)
                previous_win_id = 0
            end,
            desc = 'Reset previous window id from closed split',
        })
    end

    if config.ui.signcolumn then
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

    if config.ui.cursorline then
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

    if config.ui.number then
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

    if config.ui.relativenumber then
        if config.ui.absolutenumber_unfocussed then
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
    if config.ui.hybridnumber then
        if config.ui.absolutenumber_unfocussed then
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

    if config.ui.cursorcolumn then
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

    if config.ui.colorcolumn.enable then
        vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
            group = augroup,
            callback = function(_)
                if utils.is_disabled() then
                    return
                end
                vim.wo.colorcolumn = config.ui.colorcolumn.list
            end,
            desc = 'Color column enter',
        })
        vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
            group = augroup,
            callback = function(_)
                if utils.is_disabled() then
                    return
                end
                vim.wo.colorcolumn = ''
            end,
            desc = 'Color column leave',
        })
    end
end

return M

--- *focus.nvim* Have a nice view over your split windows
--- *Focus*
---
--- MIT License
---
--- Copyright (c) Beau Williams
--- Copyright (c) Andreas Schneider <asn@cryptomilk.org>
---
--- ===========================================================================

-- Module definition ==========================================================
local commands = require('focus.modules.commands')
local autocmd = require('focus.modules.autocmd')
local split = require('focus.modules.split')
local functions = require('focus.modules.functions')
local resizer = require('focus.modules.resizer')

local H = {}
local Focus = {}

Focus.config = {
    enable = true, -- Enable module
    commands = true, -- Create Focus commands
    autoresize = {
        enable = true, -- Enable or disable auto-resizing of splits
        width = 0, -- Force width for the focused window
        height = 0, -- Force height for the focused window
        minwidth = 0, -- Force minimum width for the unfocused window
        minheight = 0, -- Force minimum height for the unfocused window
        height_quickfix = 10, -- Set the height of quickfix panel
    },
    split = {
        bufnew = false, -- Create blank buffer for new split windows
        tmux = false, -- Create tmux splits instead of neovim splits
    },
    ui = {
        number = false, -- Display line numbers in the focussed window only
        relativenumber = false, -- Display relative line numbers in the focussed window only
        hybridnumber = false, -- Display hybrid line numbers in the focussed window only
        absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows

        cursorline = true, -- Display a cursorline in the focussed window only
        cursorcolumn = false, -- Display cursorcolumn in the focussed window only
        colorcolumn = {
            enable = false, -- Display colorcolumn in the foccused window only
            list = '+1', -- Set the comma-saperated list for the colorcolumn
        },
        signcolumn = true, -- Display signcolumn in the focussed window only
        winhighlight = false, -- Auto highlighting for focussed/unfocussed windows
    },
}

--- Module setup
---
---@param config table|nil Module config table. See |Focus.config|.
---
---@usage `require('focus').setup({})` (replace `{}` with your `config` table)
Focus.setup = function(config)
    -- Export module
    _G.Focus = Focus

    -- Setup config
    config = H.setup_config(config)

    -- Apply config
    H.apply_config(config)

    if config ~= nil and config.enable then
        autocmd.setup(config)

        if config.commands then
            commands.setup()
        end

        if config.ui.winhighlight then
            if vim.fn.has('nvim-0.9') then
                vim.api.nvim_set_hl(0, 'FocusedWindow', { link = 'VertSplit' })
                vim.api.nvim_set_hl(0, 'UnfocusedWindow', { link = 'Normal' })
            else
                vim.highlight.link('FocusedWindow', 'VertSplit', true)
                vim.highlight.link('UnfocusedWindow', 'Normal', true)
            end

            vim.wo.winhighlight =
                'Normal:FocusedWindow,NormalNC:UnfocusedWindow'
        end

        if config.autoresize.enable == true then
            Focus.resize()
        end
    end
end

Focus.resize = function()
    local config = H.get_config()

    resizer.split_resizer(config)
end

-- Exported internal functions for use in commands
function Focus.split_nicely(args)
    local config = H.get_config()
    if args == nil then
        args = ''
    end
    split.split_nicely(args, config.bufnew)
end

function Focus.split_command(direction, args)
    local config = H.get_config()
    args = args or ''
    split.split_command(direction, args, config.split.tmux, config.split.bufnew)
end

function Focus.split_cycle(reverse)
    local config = H.get_config()
    split.split_cycle(reverse, config.bufnew)
end

function Focus.focus_enable()
    functions.focus_enable()
end

function Focus.focus_disable()
    functions.focus_disable()
end

function Focus.focus_toggle()
    functions.focus_toggle()
end

function Focus.focus_maximise()
    functions.focus_maximise()
end

function Focus.focus_equalise()
    functions.focus_equalise()
end

function Focus.focus_max_or_equal()
    functions.focus_max_or_equal()
end

function Focus.focus_disable_window()
    vim.b.focus_disable = true
end

function Focus.focus_enable_window()
    vim.b.focus_disable = false
end

function Focus.focus_toggle_window()
    vim.b.focus_disable = not vim.b.focus_disable
end

H.default_config = Focus.config

H.setup_config = function(config)
    vim.validate({ config = { config, 'table', true } })

    config = vim.tbl_deep_extend('force', H.default_config, config or {})

    vim.validate({
        enable = { config.enable, 'boolean' },
        commands = { config.commands, 'boolean' },
        autoresize = { config.autoresize, 'table', true },
        split = { config.split, 'table', true },
        ui = { config.split, 'table', true },
    })

    vim.validate({
        ['autoresize.enable'] = { config.autoresize.enable, 'boolean' },
        ['autoresize.width'] = { config.autoresize.width, 'number' },
        ['autoresize.height'] = { config.autoresize.height, 'number' },
        ['autoresize.minwidth'] = { config.autoresize.minwidth, 'number' },
        ['autoresize.minheight'] = { config.autoresize.minheight, 'number' },
        ['autoresize.height_quickfix'] = {
            config.autoresize.height_quickfix,
            'number',
        },
    })

    vim.validate({
        ['split.bufnew'] = { config.split.bufnew, 'boolean' },
        ['split.tmux'] = { config.split.tmux, 'boolean' },
    })

    vim.validate({
        ['ui.number'] = { config.ui.number, 'boolean' },
        ['ui.relativenumber'] = { config.ui.relativenumber, 'boolean' },
        ['ui.hybridnumber'] = { config.ui.hybridnumber, 'boolean' },
        ['ui.absolutenumber_unfocussed'] = {
            config.ui.absolutenumber_unfocussed,
            'boolean',
        },
        ['ui.cursorline'] = { config.ui.cursorline, 'boolean' },
        ['ui.cursorcolumn'] = { config.ui.cursorcolumn, 'boolean' },
        ['ui.colorcolumn'] = { config.ui.colorcolumn, 'table', true },
        ['ui.signcolumn'] = { config.ui.signcolumn, 'boolean' },
        ['ui.winhighlight'] = { config.ui.winhighlight, 'boolean' },
    })

    vim.validate({
        ['ui.colorcolumn.enable'] = { config.ui.colorcolumn.enable, 'boolean' },
        ['ui.colorcolumn.list'] = { config.ui.colorcolumn.list, 'string' },
    })

    return config
end

H.apply_config = function(config)
    Focus.config = config
end

H.get_config = function(config)
    return vim.tbl_deep_extend(
        'force',
        Focus.config,
        vim.b.focus_config or {},
        config or {}
    )
end

return Focus

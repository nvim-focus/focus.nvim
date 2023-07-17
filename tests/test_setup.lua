---
--- MIT License
--- Copyright (c) Andreas Schneider
---
--- ==============================================================================
local helpers = dofile('tests/helpers.lua')

local child = helpers.new_child_neovim()
local expect, eq = helpers.expect, helpers.expect.equality
---@diagnostic disable-next-line: undefined-global
local new_set = MiniTest.new_set
local load_module = function(config)
    child.load_module(config)
end
local unload_module = function()
    child.unload_module()
end
local reload_module = function(config)
    unload_module()
    load_module(config)
end

-- Output test set ============================================================
T = new_set({
    hooks = {
        pre_case = function()
            child.setup()
            load_module()
        end,
        post_once = child.stop,
    },
})

-- Unit tests =================================================================
T['setup()'] = new_set()

T['setup()']['defaults'] = function()
    -- Global variable
    eq(child.lua_get('type(_G.Focus)'), 'table')

    -- Commands
    eq(child.fn.exists(':FocusEnable'), 2)
    eq(child.fn.exists(':FocusDisable'), 2)
    eq(child.fn.exists(':FocusToggle'), 2)

    eq(child.fn.exists(':FocusEnableWindow'), 2)
    eq(child.fn.exists(':FocusDisableWindow'), 2)
    eq(child.fn.exists(':FocusToggleWindow'), 2)

    eq(child.fn.exists(':FocusEqualise'), 2)
    eq(child.fn.exists(':FocusMaximise'), 2)
    eq(child.fn.exists(':FocusMaxOrEqual'), 2)

    eq(child.fn.exists(':FocusSplitNicely'), 2)
    eq(child.fn.exists(':FocusSplitCycle'), 2)

    eq(child.fn.exists(':FocusSplitLeft'), 2)
    eq(child.fn.exists(':FocusSplitRight'), 2)
    eq(child.fn.exists(':FocusSplitUp'), 2)
    eq(child.fn.exists(':FocusSplitDown'), 2)
end

T['setup()']['default config'] = function()
    eq(child.lua_get('type(_G.Focus.config)'), 'table')

    -- Check default values
    local expect_config = function(field, value)
        eq(child.lua_get('Focus.config.' .. field), value)
    end
    expect_config('enable', true)
    expect_config('commands', true)

    expect_config('autoresize.enable', true)
    expect_config('autoresize.width', 0)
    expect_config('autoresize.height', 0)
    expect_config('autoresize.minwidth', 0)
    expect_config('autoresize.minheight', 0)
    expect_config('autoresize.height_quickfix', 10)

    expect_config('split.bufnew', false)
    expect_config('split.tmux', false)

    expect_config('ui.number', false)
    expect_config('ui.relativenumber', false)
    expect_config('ui.hybridnumber', false)
    expect_config('ui.absolutenumber_unfocussed', false)
    expect_config('ui.cursorline', true)
    expect_config('ui.cursorcolumn', false)
    expect_config('ui.colorcolumn.enable', false)
    expect_config('ui.colorcolumn.list', '+1')
    expect_config('ui.signcolumn', true)
    expect_config('ui.winhighlight', false)
end

T['setup()']['respects config argument'] = function()
    reload_module({ commands = false })
    eq(child.lua_get('Focus.config.commands'), false)
end

T['setup()']['validates config argument'] = function()
    local expect_config_error = function(config, name, target_type)
        expect.error(
            reload_module,
            vim.pesc(name) .. '.*' .. vim.pesc(target_type),
            config
        )
    end

    expect_config_error('a', 'config', 'table')
    expect_config_error({ enable = 3 }, 'enable', 'boolean')
    expect_config_error({ commands = 3 }, 'commands', 'boolean')
    expect_config_error(
        { autoresize = { enable = 3 } },
        'autoresize.enable',
        'boolean'
    )
    expect_config_error(
        { autoresize = { width = '5' } },
        'autoresize.width',
        'number'
    )
    expect_config_error(
        { autoresize = { height = '5' } },
        'autoresize.height',
        'number'
    )
    expect_config_error(
        { autoresize = { minwidth = '5' } },
        'autoresize.minwidth',
        'number'
    )
    expect_config_error(
        { autoresize = { minheight = '5' } },
        'autoresize.minheight',
        'number'
    )
    expect_config_error(
        { autoresize = { height_quickfix = '5' } },
        'autoresize.height_quickfix',
        'number'
    )

    expect_config_error({ split = { bufnew = 3 } }, 'split.bufnew', 'boolean')
    expect_config_error({ split = { tmux = 3 } }, 'split.tmux', 'boolean')

    expect_config_error({ ui = { number = 3 } }, 'number', 'boolean')
    expect_config_error(
        { ui = { relativenumber = 3 } },
        'relativenumber',
        'boolean'
    )
    expect_config_error(
        { ui = { hybridnumber = 3 } },
        'hybridnumber',
        'boolean'
    )
    expect_config_error(
        { ui = { absolutenumber_unfocussed = 3 } },
        'absolutenumber_unfocussed',
        'boolean'
    )
    expect_config_error({ ui = { cursorline = 3 } }, 'cursorline', 'boolean')
    expect_config_error(
        { ui = { cursorcolumn = 3 } },
        'cursorcolumn',
        'boolean'
    )
    expect_config_error(
        { ui = { colorcolumn = { enable = 3 } } },
        'colorcolumn.enable',
        'boolean'
    )
    expect_config_error(
        { ui = { colorcolumn = { list = 3 } } },
        'colorcolumn.list',
        'string'
    )
    expect_config_error({ ui = { signcolumn = 3 } }, 'signcolumn', 'boolean')
    expect_config_error(
        { ui = { winhighlight = 3 } },
        'winhighlight',
        'boolean'
    )
end

T['setup()']['autoresize'] = function()
    reload_module({ autoresize = { enable = true } })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
end

T['setup()']['autoresize disabled'] = function()
    reload_module({
        autoresize = { enable = false },
        ui = { cursorline = false, signcolumn = false },
    })

    eq(child.lua_get('_G.Focus.config.autoresize.enable'), false)

    -- Auto command group, this is always created
    eq(child.fn.exists('#Focus'), 1)

    -- There should be no BufEnter if we have all features disabled
    eq(child.fn.exists('#Focus#BufEnter'), 0)
end

T['setup()']['signcolumn'] = function()
    reload_module({ autoresize = { enable = true }, signcolumn = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['cursorline'] = function()
    reload_module({ autoresize = { enable = true }, cursorline = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['number'] = function()
    reload_module({ autoresize = { enable = true }, ui = { number = true } })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['relativenumber'] = function()
    reload_module({
        autoresize = { enable = true },
        ui = { relativenumber = true },
    })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['relativenumber absolutenumber_unfocussed'] = function()
    reload_module({
        autoresize = { enable = true },
        ui = {
            relativenumber = true,
            absolutenumber_unfocussed = true,
        },
    })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['hybridnumber'] = function()
    reload_module({ autoresize = { enable = true }, hybridnumber = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['hybridnumber absolutenumber_unfocussed'] = function()
    reload_module({
        autoresize = { enable = true },
        ui = {
            hybridnumber = true,
            absolutenumber_unfocussed = true,
        },
    })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['cursorcolumn'] = function()
    reload_module({
        autoresize = { enable = true },
        ui = { cursorcolumn = true },
    })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['colorcolumn'] = function()
    reload_module({
        autoresize = { enable = true },
        ui = {
            colorcolumn = { enabled = true },
        },
    })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

return T

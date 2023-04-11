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
    expect_config('autoresize', true)
    expect_config('width', 0)
    expect_config('height', 0)
    expect_config('minwidth', 0)
    expect_config('minheight', 0)
    expect_config('height_quickfix', 10)
    expect_config('cursorline', true)
    expect_config('cursorcolumn', false)
    expect_config('signcolumn', true)
    expect_config('colorcolumn.enable', false)
    expect_config('colorcolumn.list', '+1')
    expect_config('winhighlight', false)
    expect_config('number', false)
    expect_config('relativenumber', false)
    expect_config('hybridnumber', false)
    expect_config('absolutenumber_unfocussed', false)
    expect_config('tmux', false)
    expect_config('bufnew', false)
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
    expect_config_error({ autoresize = 3 }, 'autoresize', 'boolean')
    expect_config_error({ width = '5' }, 'width', 'number')
    expect_config_error({ height = '5' }, 'height', 'number')
    expect_config_error({ minwidth = '5' }, 'minwidth', 'number')
    expect_config_error({ minheight = '5' }, 'minheight', 'number')
    expect_config_error({ minheight = '5' }, 'minheight', 'number')
    expect_config_error({ height_quickfix = '5' }, 'height_quickfix', 'number')
    expect_config_error({ cursorline = 3 }, 'cursorline', 'boolean')
    expect_config_error({ cursorcolumn = 3 }, 'cursorcolumn', 'boolean')
    expect_config_error({ signcolumn = 3 }, 'signcolumn', 'boolean')
    expect_config_error(
        { colorcolumn = { enable = 3 } },
        'colorcolumn.enable',
        'boolean'
    )
    expect_config_error(
        { colorcolumn = { list = 3 } },
        'colorcolumn.list',
        'string'
    )
    expect_config_error({ winhighlight = 3 }, 'winhighlight', 'boolean')
    expect_config_error({ number = 3 }, 'number', 'boolean')
    expect_config_error({ relativenumber = 3 }, 'relativenumber', 'boolean')
    expect_config_error({ hybridnumber = 3 }, 'hybridnumber', 'boolean')
    expect_config_error(
        { absolutenumber_unfocussed = 3 },
        'absolutenumber_unfocussed',
        'boolean'
    )
    expect_config_error({ tmux = 3 }, 'tmux', 'boolean')
    expect_config_error({ bufnew = 3 }, 'bufnew', 'boolean')
end

T['setup()']['autoresize'] = function()
    reload_module({ autoresize = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
end

T['setup()']['signcolumn'] = function()
    reload_module({ autoresize = false, signcolumn = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['cursorline'] = function()
    reload_module({ autoresize = false, cursorline = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['number'] = function()
    reload_module({ autoresize = false, number = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['relativenumber'] = function()
    reload_module({ autoresize = false, relativenumber = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['relativenumber absolutenumber_unfocussed'] = function()
    reload_module({
        autoresize = false,
        relativenumber = true,
        absolutenumber_unfocussed = true,
    })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['hybridnumber'] = function()
    reload_module({ autoresize = false, hybridnumber = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['hybridnumber absolutenumber_unfocussed'] = function()
    reload_module({
        autoresize = false,
        hybridnumber = true,
        absolutenumber_unfocussed = true,
    })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['cursorcolumn'] = function()
    reload_module({ autoresize = false, cursorcolumn = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['colorcolumn'] = function()
    reload_module({ autoresize = false, colorcolumn = { enabled = true } })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

return T

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

T['setup()']['default'] = function()
    -- Global variable
    eq(child.lua_get('type(_G.Focus)'), 'table')
end

T['setup()']['autoresize'] = function()
    reload_module({ autoresize = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
end

T['setup()']['signcolumn'] = function()
    reload_module({ signcolumn = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['cursorline'] = function()
    reload_module({ cursorline = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['number'] = function()
    reload_module({ number = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['relativenumber'] = function()
    reload_module({ relativenumber = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['relativenumber absolutenumber_unfocussed'] = function()
    reload_module({ relativenumber = true, absolutenumber_unfocussed = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['hybridnumber'] = function()
    reload_module({ hybridnumber = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['hybridnumber absolutenumber_unfocussed'] = function()
    reload_module({ hybridnumber = true, absolutenumber_unfocussed = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['cursorcolumn'] = function()
    reload_module({ cursorcolumn = true })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

T['setup()']['colorcolumn'] = function()
    reload_module({ colorcolumn = { enabled = true } })

    -- Auto command group
    eq(child.fn.exists('#Focus'), 1)

    eq(child.fn.exists('#Focus#BufEnter'), 1)
    eq(child.fn.exists('#Focus#WinEnter'), 1)

    eq(child.fn.exists('#Focus#BufLeave'), 1)
    eq(child.fn.exists('#Focus#WinLeave'), 1)
end

return T

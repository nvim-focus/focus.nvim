local cmd = vim.api.nvim_command
local autocmd = {}

local function nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        cmd("augroup " .. group_name)
        cmd("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
            cmd(command)
        end
        cmd("augroup END")
    end
end

function autocmd.setup(config)
    local autocmds = {}

    --Re-init when leaving windows such as nvimtree where we disable it
    table.insert(autocmds, {"BufRead,BufRead", "*", ':lua require"focus".init()'})
    -- NOTE: Don't ask me why the below works. aucommands are a sour point of this plugin. But this works for now.
    table.insert(autocmds, {"BufEnter", "*.*", ':lua require"focus".init()'})
    -- So that we can resize windows such as NvimTree correctly, we run init when we open a buffer
    table.insert(autocmds, {"BufEnter,WinEnter" , "NvimTree,nerdtree,CHADTree,qf" , ":lua require'focus'.init()"})

    if config.signcolumn ~= false then
        -- Explicitly check against false, as it not being present should default to it being on
        table.insert(autocmds, {"WinEnter", "*", "setlocal signcolumn=auto"})
        table.insert(autocmds, {"WinLeave", "*", "setlocal signcolumn=no"})
    end

    if config.cursorline ~= false then
        -- Explicitly check against false, as it not being present should default to it being on
        table.insert(autocmds, {"BufEnter", "*", "setlocal cursorline"})
        table.insert(autocmds, {"BufLeave", "*", "setlocal nocursorline"})
    end

    nvim_create_augroups({autocmds})
end

return autocmd

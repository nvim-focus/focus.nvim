local utils = require('focus.modules.utils')
local vim = vim
local cmd = vim.api.nvim_command
local M = {}

local golden_ratio = 1.618

local function process_split_args(created, args, bufnew)
    local args_array = utils.split(args, ' ')
    if args_array[1] ~= '' and args_array[1] ~= 'cmd' then
        cmd('edit ' .. args_array[1])
    elseif args_array[1] == 'cmd' and args_array[2] ~= nil then
        cmd('enew')
        local cmd_to_run = table.concat(args_array, ' ', 2)
        cmd(cmd_to_run)
    elseif created == true and bufnew == true then
        cmd('enew')
    end
end

local golden_ratio_split_cmd = function(winnr)
    local maxwidth = vim.o.columns
    local winwidth = vim.fn.winwidth(winnr)
    local textwidth = vim.bo.textwidth

    if textwidth > 0 and winwidth > math.floor(textwidth * golden_ratio) then
        return 'vsplit'
    end

    if winwidth > math.floor(maxwidth / golden_ratio) then
        return 'vsplit'
    end

    return 'split'
end

local function move_back(direction)
    if direction == 'h' then
        return 'l'
    elseif direction == 'l' then
        return 'h'
    elseif direction == 'j' then
        return 'k'
    elseif direction == 'k' then
        return 'j'
    end
end

local split_ENOROOM = function(err)
    -- err: Vim(split):E36: Not enough room
    return string.match(err, 'Vim([a-z]split):E36:.*')
end

function M.split_nicely(args, bufnew)
    local winnr = vim.api.nvim_get_current_win()
    local split_cmd = golden_ratio_split_cmd(winnr)

    -- this allows use to get 4 split layout
    -- if #vim.api.nvim_tabpage_list_wins({ 0 }) == 4 then
    if #vim.api.nvim_tabpage_list_wins(0) == 4 then
        cmd('wincmd w')
    end

    local _, e = xpcall(cmd, split_ENOROOM, split_cmd)
    if e then
        if split_cmd == 'split' then
            -- TODO: Determine what effect the below code has
            vim.o.minwinheight = vim.o.minwinheight / 2
            -- this is not useful here but keeping as this might be useful to halve window sizes in future
            -- vim.api.nvim_win_set_height(winnr, vim.api.nvim_win_get_height(winnr)/2)
        else
            vim.o.minwinwidth = vim.o.minwinwidth / 2
        end
    end

    -- splitright.. ensure that whenever you split vertically, it’s going to appear on the right.
    -- Moreover, for a horizontal split, the new split is going to appear at the bottom.
    -- always returns false/nil below when not set by user
    -- we check it because when splitbelow/right is set, wincmd happens automatically
    if split_cmd == 'vsplit' and not vim.o.splitright then
        cmd('wincmd p')
    end

    if split_cmd == 'split' and not vim.o.splitbelow then
        cmd('wincmd p')
    end

    --open file or term .. etc if args provided
    process_split_args(true, args, bufnew)
end

function M.split_command(direction, args, tmux, bufnew)
    local winnr = vim.api.nvim_get_current_win()

    local created = false
    if M.split_exists_direction(winnr, direction) == false then
        created = true
        if tmux == true then
            vim.fn.system(
                'tmux select-pane -' .. vim.fn.tr(direction, 'phjkl', 'lLDUR')
            )
        elseif direction == 'h' or direction == 'l' then
            cmd('wincmd v')
            cmd('wincmd ' .. direction)
        elseif direction == 'j' or direction == 'k' then
            cmd('wincmd s')
            cmd('wincmd ' .. direction)
        end
    else
        cmd('wincmd ' .. direction)
    end
    process_split_args(created, args, bufnew)
end

function M.split_cycle(reverse, bufnew)
    local winnr = vim.api.nvim_get_current_win()
    if reverse == 'reverse' then
        cmd('wincmd W')
    else
        cmd('wincmd w')
    end

    if winnr == vim.api.nvim_get_current_win() then
        cmd('wincmd v')
        if reverse == nil or reverse ~= 'reverse' then
            cmd('wincmd w')
        end
        if bufnew == true then
            cmd('enew')
        end
    end
end

function M.split_exists_direction(winnr, direction)
    return vim.api.nvim_win_call(winnr, function()
        return vim.fn.winnr() ~= vim.fn.winnr(direction)
    end)
end

return M

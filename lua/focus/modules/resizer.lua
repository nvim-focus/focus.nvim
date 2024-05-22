local utils = require('focus.modules.utils')
local M = {}

local golden_ratio = 1.618

local golden_ratio_width = function()
    local maxwidth = vim.o.columns
    return math.floor(maxwidth / golden_ratio)
end

local golden_ratio_minwidth = function()
    return math.floor(golden_ratio_width() / (3 * golden_ratio))
end

local golden_ratio_height = function()
    local maxheight = vim.o.lines
    return math.floor(maxheight / golden_ratio)
end

local golden_ratio_minheight = function()
    return math.floor(golden_ratio_height() / (3 * golden_ratio))
end

local function save_fixed_win_dims()
    local fixed_dims = {}

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).zindex == nil then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.w[win].focus_disable or vim.b[buf].focus_disable then
                fixed_dims[win] = {
                    width = vim.api.nvim_win_get_width(win),
                    height = vim.api.nvim_win_get_height(win),
                }
            end
        end
    end

    return fixed_dims
end

local function restore_fixed_win_dims(fixed_dims)
    for win, dims in pairs(fixed_dims) do
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_set_width(win, dims.width)
            vim.api.nvim_win_set_height(win, dims.height)
        end
    end
end

local goals = {
    autoresize = vim.schedule_wrap(function(config)
        local width
        if config.autoresize.width > 0 then
            width = config.autoresize.width
        else
            width = golden_ratio_width()
            if config.autoresize.minwidth > 0 then
                width = math.max(width, config.autoresize.minwidth)
            elseif width < golden_ratio_minwidth() then
                width = golden_ratio_minwidth()
            end
        end

        local height
        if config.autoresize.height > 0 then
            height = config.autoresize.height
        else
            height = golden_ratio_height()
            if config.autoresize.minheight > 0 then
                height = math.max(height, config.autoresize.minheight)
            elseif height < golden_ratio_minheight() then
                height = golden_ratio_minheight()
            end
        end

        -- save cmdheight to ensure it is not changed by nvim_win_set_height
        local cmdheight = vim.o.cmdheight

        local fixed = save_fixed_win_dims()

        vim.api.nvim_win_set_width(0, width)
        vim.api.nvim_win_set_height(0, height)

        restore_fixed_win_dims(fixed)

        vim.o.cmdheight = cmdheight
    end),
    equalise = vim.schedule_wrap(function()
        vim.api.nvim_exec2('wincmd =', { output = false })
    end),
    maximise = vim.schedule_wrap(function()
        local width, height = vim.o.columns, vim.o.lines

        local fixed = save_fixed_win_dims()

        vim.api.nvim_win_set_width(0, width)
        vim.api.nvim_win_set_height(0, height)

        restore_fixed_win_dims(fixed)
    end),
}

M.goal = 'autoresize'

function M.split_resizer(config, goal) --> Only resize normal buffers, set qf to 10 always
    if goal then
        M.goal = goal
    end
    if
        utils.is_disabled()
        or vim.api.nvim_get_option_value('diff', {
            win = 0,
            scope = 'local',
        })
        or vim.api.nvim_win_get_config(0).zindex ~= nil
        or not config.autoresize.enable
    then
        -- Setting minwidth/minheight must be done before setting width/height
        -- to avoid errors when winminwidth and winminheight are larger than 1.
        vim.o.winminwidth = 1
        vim.o.winminheight = 1
        vim.o.winwidth = 1
        vim.o.winheight = 1
        return
    else
        if config.autoresize.minwidth > 0 then
            if vim.o.winwidth < config.autoresize.minwidth then
                vim.o.winwidth = config.autoresize.minwidth
            end
            vim.o.winminwidth = config.autoresize.minwidth
        end
        if config.autoresize.minheight > 0 then
            if vim.o.winheight < config.autoresize.minheight then
                vim.o.winheight = config.autoresize.minheight
            end
            vim.o.winminheight = config.autoresize.minheight
        end
    end

    if vim.bo.filetype == 'qf' and config.autoresize.height_quickfix > 0 then
        vim.api.nvim_win_set_height(0, config.autoresize.height_quickfix)
        return
    end

    goals[M.goal](config)
end

return M

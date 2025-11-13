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

function M.autoresize(config)
    -- Check if we should use equal splits based on terminal size
    -- When columns >= equalise_min_cols AND/OR rows >= equalise_min_rows, use equal splits (wincmd =)
    -- Otherwise, use golden ratio autoresize
    local should_equalise = false
    local cols_check = config.autoresize.equalise_min_cols > 0 and vim.o.columns >= config.autoresize.equalise_min_cols
    local rows_check = config.autoresize.equalise_min_rows > 0 and vim.o.lines >= config.autoresize.equalise_min_rows

    -- If both thresholds are set, both conditions must be met
    -- If only one is set, only that condition needs to be met
    if config.autoresize.equalise_min_cols > 0 and config.autoresize.equalise_min_rows > 0 then
        should_equalise = cols_check and rows_check
    elseif config.autoresize.equalise_min_cols > 0 then
        should_equalise = cols_check
    elseif config.autoresize.equalise_min_rows > 0 then
        should_equalise = rows_check
    end

    -- If equalise mode, just equalize all windows and return
    if should_equalise then
        local cmdheight = vim.o.cmdheight
        local fixed = save_fixed_win_dims()
        vim.api.nvim_exec2('wincmd =', { output = false })
        restore_fixed_win_dims(fixed)
        vim.o.cmdheight = cmdheight
        return
    end

    -- Otherwise, use golden ratio autoresize
    local width
    if config.autoresize.width > 0 then
        width = config.autoresize.width
    else
        width = golden_ratio_width()
        if config.autoresize.focusedwindow_minwidth > 0 then
            if width < config.autoresize.focusedwindow_minwidth then
                width = config.autoresize.focusedwindow_minwidth
            end
        elseif config.autoresize.minwidth > 0 then
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
        if config.autoresize.focusedwindow_minheight > 0 then
            if height < config.autoresize.focusedwindow_minheight then
                height = config.autoresize.focusedwindow_minheight
            end
        elseif config.autoresize.minheight > 0 then
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
end

function M.equalise()
    vim.api.nvim_exec2('wincmd =', { output = false })
end

function M.maximise()
    local width, height = vim.o.columns, vim.o.lines

    local fixed = save_fixed_win_dims()

    vim.api.nvim_win_set_width(0, width)
    vim.api.nvim_win_set_height(0, height)

    restore_fixed_win_dims(fixed)
end

M.goal = 'autoresize'

function M.split_resizer(config, goal) --> Only resize normal buffers, set qf to 10 always
    if goal then
        M.goal = goal
    end
    if
        utils.is_disabled()
        or vim.api.nvim_win_get_option(0, 'diff')
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
        if
            config.autoresize.minwidth > 0
            and config.autoresize.focusedwindow_minwidth <= 0
        then
            if vim.o.winwidth < config.autoresize.minwidth then
                vim.o.winwidth = config.autoresize.minwidth
            end
            vim.o.winminwidth = config.autoresize.minwidth
        end
        if
            config.autoresize.minheight > 0
            and config.autoresize.focusedwindow_minheight <= 0
        then
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

    M[M.goal](config)
end

return M

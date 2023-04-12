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

function M.split_resizer(config) --> Only resize normal buffers, set qf to 10 always
    if utils.is_disabled() or vim.api.nvim_win_get_option(0, 'diff') then
        vim.o.winminwidth = 1
        vim.o.winwidth = 1
        vim.o.winminheight = 1
        vim.o.winheight = 1

        return
    end

    if vim.bo.ft == 'qf' then
        vim.o.winminheight = 1
        vim.o.winheight = config.autoresize.height_quickfix
        return
    end

    if config.autoresize.width > 0 then
        vim.o.winwidth = config.autoresize.width
        if config.autoresize.minwidth > 0 then
            vim.o.winminwidth = config.autoresize.minwidth
        else
            vim.o.winminwidth = golden_ratio_minwidth()
        end
    else
        vim.o.winwidth = golden_ratio_width()
        if config.autoresize.minwidth > 0 then
            if config.autoresize.minwidth < golden_ratio_width() then
                print(
                    'Focus.nvim: config.autoresize.red minwidth is less than '
                        .. 'golden_ratio_width derived from your display. '
                        .. 'Please set minwidth to at least '
                        .. golden_ratio_width()
                )
            else
                vim.o.winminwidth = config.autoresize.minwidth
            end
        else
            vim.o.winminwidth = golden_ratio_minwidth()
        end
    end

    if config.autoresize.height > 0 then
        vim.o.winheight = config.autoresize.height
        if config.autoresize.minheight > 0 then
            vim.o.winminheight = config.autoresize.minheight
        else
            --NOTE: avoid setting width lower than mindwidth
            vim.o.winminheight = golden_ratio_minheight()
        end
    else
        vim.o.winheight = golden_ratio_height()
        if config.autoresize.minheight > 0 then
            if config.autoresize.minheight < golden_ratio_height() then
                print(
                    'Focus.nvim: config.autoresize.red minheight is less than default '
                        .. 'golden_ratio_height derived from your display. Please '
                        .. 'set minheight to at least '
                        .. golden_ratio_height()
                )
            else
                vim.o.winminheight = config.autoresize.minheight
            end
        else
            vim.o.winminheight = golden_ratio_minheight()
        end
    end
end

return M

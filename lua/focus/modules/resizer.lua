local utils = require('focus.modules.utils')
local functions = require('focus.modules.functions')
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
        vim.o.winheight = config.height_quickfix or 10
        return
    end

    if config.width > 0 then
        vim.o.winwidth = config.width
        if config.minwidth > 0 then
            vim.o.winminwidth = config.minwidth
        else
            vim.o.winminwidth = golden_ratio_minwidth()
        end
    else
        vim.o.winwidth = golden_ratio_width()
        if config.minwidth > 0 then
            if config.minwidth < golden_ratio_width() then
                print(
                    'Focus.nvim: Configured minwidth is less than '
                        .. 'golden_ratio_width derived from your display. '
                        .. 'Please set minwidth to at least '
                        .. golden_ratio_width()
                )
            else
                vim.o.winminwidth = config.minwidth
            end
        else
            vim.o.winminwidth = golden_ratio_minwidth()
        end
    end

    if config.height > 0 then
        vim.o.winheight = config.height
        if config.minheight > 0 then
            vim.o.winminheight = config.minheight
        else
            --NOTE: avoid setting width lower than mindwidth
            vim.o.winminheight = golden_ratio_minheight()
        end
    else
        vim.o.winheight = golden_ratio_height()
        if config.minheight > 0 then
            if config.minheight < golden_ratio_height() then
                print(
                    'Focus.nvim: Configured minheight is less than default '
                        .. 'golden_ratio_height derived from your display. Please '
                        .. 'set minheight to at least '
                        .. golden_ratio_height()
                )
            else
                vim.o.winminheight = config.minheight
            end
        else
            vim.o.winminheight = golden_ratio_minheight()
        end
    end
end

return M

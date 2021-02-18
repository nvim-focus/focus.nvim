local config = require('modules.config')

local M = {}

M.init = function()
    -- Verify that configuration values are of the correct type
    config.verify()

    if M.enable == true then
      -- Pass this module, noting that `__index` actually references the
      -- configuration module, to setup the autocmds used for this plugin
      require 'modules.autocmd'.setup(M)
      require 'modules.resizer'.split_resizer(M)


      if M.winhighlight then
        -- Allows user-overridable highlighting of the focused window
        --
        -- See `:h hi-default` for more details
        vim.cmd('hi default link FocusedWindow VertSplit')
        vim.cmd('hi default link UnfocusedWindow Normal')

        vim.wo.winhighlight = 'Normal:FocusedWindow,NormalNC:UnfocusedWindow'
      end
    end
end

setmetatable(M,
    {
        __newindex = config.set,
        __index = config.get,
    }
)

return M

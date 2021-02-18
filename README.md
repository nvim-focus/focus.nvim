# Auto-resizing Focused Splits/Windows for Neovim

🔋 Batteries Included. No configuration neccessary

👌 Maximises Current Split/Window Automatically When Cursor Moves

⚙️  Set Focus Split/Window Width, Height, Cursorline & Active/Inactive Win-Highlight + Disable

🙌 Compatible with NvimTree, NerdTree, CHADTree, Telescope, FZF & QuickFix (QF default to 10, rest won't resize)

# Demo

![screencast](https://i.ibb.co/0tsKww4/focusop.gif)

*note: for reference this screencast features dimensions set to 120\*40 (W\*H)*

## Installation
#### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'beauwilliams/focus.nvim'
```
#### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'beauwilliams/focus.nvim'
```

## Vim Commands

| _Command_      | _Description_ |
| -------------- | ------------- |
| `:DisableFocus` |  Disable the plugin per session, run at anytime. Splits will be normalised back to defaults and then spaced evenly. |

## Configuration

Place some version of this in your configuration file, e.g. `init.lua`, etc.


**Enable/Disable Focus**
```lua
local focus = require('focus')
-- Completely disable this plugin
-- Default: true
focus.enable = false
```

**Set Focus Width**
```lua
local focus = require('focus')
-- Width for the focused window, other windows resized accordingly
-- Default: 120
focus.width = 120
```

**Set Focus Height**
```lua
local focus = require('focus')
-- Height for the focused window
-- Default: 0
focus.height = 40

```

**Set Focus Auto Cursorline**
```lua
local focus = require('focus')
-- Default: true
focus.cursorline = false
```

**Set Focus Auto Sign Column**
```lua
local focus = require('focus')
-- Default: true
focus.signcolumn = false
```

**Set Focus Window Highlighting**
```lua
local focus = require('focus')
-- Default: false
focus.winhighlight = true

-- By default, the highlight groups are setup as such:
--   hi default link FocusedWindow VertSplit
--   hi default link UnfocusedWindow Normal
-- To change them, you can link them to a different highlight group, see `:h hi-default` for more info.
vim.cmd('hi link UnfocusedWindow CursorLine')
vim.cmd('hi link FocusedWindow VisualNOS')
```


## Planned Improvements 😼

- [ ] Refactoring
- [ ] Adding `:h filetype` support as we go
- [ ] Decide default width as per feedback (I like 120)
- [x] Perhaps some other configs, maybe height?

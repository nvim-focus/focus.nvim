# Auto-Focussing Splits/Windows for Neovim

🔋 Batteries Included. No configuration neccessary

👌 Maximises Current Split/Window Automatically When Cursor Moves

⚙️  Set Focus Split/Window Width, Height, Cursorline & Highlight + Disable

🙌 Compatible with NvimTree, NerdTree, CHADTree & QuickFix (QF default to 10, rest won't resize)

# Demo

![screencast](https://i.ibb.co/0tsKww4/focusop.gif)

## Installation
### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'beauwilliams/focus.nvim'
```
### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'beauwilliams/focus.nvim'
```

# Configuration
**Disable Focus**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.enable = false
```
**Disable Focus (Per Session)**

NOTE: issue command before making some splits
```vim
:DisableFocus
```

**Set Focus Width (Default to 120 px)**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.width = 120
```

**Set Focus Height (By default disabled)**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.height = 40
```
**Set Focus Auto-Cursorline (By default enabled)**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.cursorline = true
```
**Set Focus Window Highlighting (By default disabled)**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.winhighlight = false
```



## Planned Improvements 😼

- [ ] Refactoring
- [ ] Adding Filetypes Support as we go
- [ ] Decide default width as per feedback (I like 120)
- [x] Perhaps some other configs, maybe height?

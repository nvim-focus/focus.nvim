# Auto-Focussing Splits/Windows for Neovim

🔋 Batteries Included. No configuration neccessary

👌 Maximises Current Split/Window Automatically When Cursor Moves

⚙️  Set Focus Split/Window Width, Disable

🙌 Compatible with NvimTree, NerdTree, CHADTree & QuickFix (Won't resize)

# Demo

![screencast](https://i.ibb.co/17J882Y/ezgif-1-b3b5a4e585d9.gif)

## Installation
### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'beauwilliams/focus.lua'
```
### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'beauwilliams/focus.lua'
```

# Configuration
**Disable Focus**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.enable = false
```

**Set Focus Width**
```lua
-- place me somewhere in your init.lua
local focus = require('focus')
focus.width = 100
```

## Planned Improvements 😼

- [ ] Adding Filetypes Support as we go
- [ ] Decide default width as per feedback (I like 120)
- [ ] Perhaps some other configs, maybe height?

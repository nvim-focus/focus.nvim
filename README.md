# focus.nvim

[![GitHub stars](https://img.shields.io/github/stars/beauwilliams/focus.nvim.svg?style=social&label=Star)](https://GitHub.com/beauwilliams/focus.nvim/stargazers/)
[![Requires Neovim 0.7+](https://img.shields.io/badge/requires-nvim%200.7%2B-9cf?logo=neovim)](https://neovim.io/)
[![GitHub contributors](https://img.shields.io/github/contributors/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/graphs/contributors/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com/)
[![GitHub issues](https://img.shields.io/github/issues/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/issues/)
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/beauwilliams/focus.nvim.svg)](https://GitHub.com/beauwilliams/focus.nvim/issues?q=is%3Aissue+is%3Aclosed)

Always have a nice view over your split windows

## Preview

![screencast](https://i.ibb.co/0tsKww4/focusop.gif)

*Note*: For reference this screencast features dimensions set to 40 rows and 120
columns.

*See a visual demonstration of each focus feature
[here](https://github.com/beauwilliams/focus.nvim/blob/master/DEMO.md)*.

## Features

* 👌 Resizes split windows automatically based on [golden ratio](https://en.wikipedia.org/wiki/Golden_ratio)
* ⚙️ Enables cursorline/signcolumn/numbers on focus window only
* 🙌 Window creation or switch by direction
* 🖥 Equalise splits or maximise focused splits, and toggle between the two
* 🔌 Option to open tmux windows instead of creating new splits

## Installation

Here are code snippets for some common installation methods (use only one):

<details>
<summary>With <a href="https://github.com/folke/lazy.nvim">folke/lazy.nvim</a></summary>
<table>
    <thead>
        <tr>
            <th>Github repo</th>
            <th>Branch</th> <th>Code snippet</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>'focus.nvim' library</td>
            <td>Main</td> <td><code>{ 'beauwilliams/focus.nvim', version = false },</code></td>
        </tr>
        <tr>
            <td>Stable</td> <td><code>{ 'beauwilliams/focus.nvim', version = '*' },</code></td>
        </tr>
    </tbody>
</table>
</details>

<details>
<summary>With <a href="https://github.com/wbthomason/packer.nvim">wbthomason/packer.nvim</a></summary>
<table>
    <thead>
        <tr>
            <th>Github repo</th>
            <th>Branch</th> <th>Code snippet</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>'focus.nvim' library</td>
            <td>Main</td> <td><code>use 'beauwilliams/focus.nvim'</code></td>
        </tr>
        <tr>
            <td>Stable</td> <td><code>use { 'beauwilliams/focus.nvim', branch = 'stable' }</code></td>
        </tr>
    </tbody>
</table>
</details>

<details>
<summary>With <a href="https://github.com/junegunn/vim-plug">junegunn/vim-plug</a></summary>
<table>
    <thead>
        <tr>
            <th>Github repo</th>
            <th>Branch</th> <th>Code snippet</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>'focus.nvim' library</td>
            <td>Main</td> <td><code>Plug 'beauwilliams/focus.nvim'</code></td>
        </tr>
        <tr>
            <td>Stable</td> <td><code>Plug 'beauwilliams/focus.nvim', { 'branch': 'stable' }</code></td>
        </tr>
    </tbody>
</table>
</details>

<br>

## Configuration

For basic setup with all batteries included:

```lua
require("focus").setup()
```

Configuration can be passed to the setup function. Here is an example with the
default settings:

```lua
require("focus").setup({
    enable = true, -- Enable module
    commands = true, -- Create Focus commands
    autoresize = {
        enable = true, -- Enable or disable auto-resizing of splits
        width = 0, -- Force width for the focused window
        height = 0, -- Force height for the focused window
        minwidth = 0, -- Force minimum width for the unfocused window
        minheight = 0, -- Force minimum height for the unfocused window
        height_quickfix = 10, -- Set the height of quickfix panel
    },
    split = {
        bufnew = false, -- Create blank buffer for new split windows
        tmux = false, -- Create tmux splits instead of neovim splits
    },
    ui = {
        number = false, -- Display line numbers in the focussed window only
        relativenumber = false, -- Display relative line numbers in the focussed window only
        hybridnumber = false, -- Display hybrid line numbers in the focussed window only
        absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows

        cursorline = true, -- Display a cursorline in the focussed window only
        cursorcolumn = false, -- Display cursorcolumn in the focussed window only
        colorcolumn = {
            enable = false, -- Display colorcolumn in the foccused window only
            list = '+1', -- Set the comma-saperated list for the colorcolumn
        },
        signcolumn = true, -- Display signcolumn in the focussed window only
        winhighlight = false, -- Auto highlighting for focussed/unfocussed windows
    }
})
```

### Setup options

**Enable/Disable Focus**
```lua
-- Completely disable this plugin
-- Default: true
require("focus").setup({enable = false})
```

**Enable/Disable Focus Commands**
```lua
-- This not export :Focus* commands
-- Default: true
require("focus").setup({commands = false})
```

**Enable/Disable Focus Window Autoresizing**
```lua
--The focussed window will no longer automatically resize. Other focus features are still available
-- Default: true
require("focus").setup({ autoresize = { enable = false } })
```


**Set Focus Width**
```lua
-- Force width for the focused window
-- Default: Calculated based on golden ratio
require("focus").setup({ autoresize = { width = 120 } })
```

**Set Focus Minimum Width**
```lua
-- Force minimum width for the unfocused window
-- Default: Calculated based on golden ratio
require("focus").setup({ autoresize = { minwidth = 80} })
```

**Set Focus Height**
```lua
-- Force height for the focused window
-- Default: Calculated based on golden ratio
require("focus").setup({ autoresize = { height = 40 } })
```

**Set Focus Minimum Height**
```lua
-- Force minimum height for the unfocused window
-- Default: 0
require("focus").setup({ autoresize = { minheight = 10} })
```

**Set Focus Quickfix Height**
```lua
-- Sets the height of quickfix panel, in case you pass the height to
-- `:copen <height>`
-- Default: 10
require("focus").setup({ autoresize = { height_quickfix = 10 })
```

**When creating a new split window, do/don't initialise it as an empty buffer**
```lua
-- True: When a :Focus.. command creates a new split window, initialise it as a new blank buffer
-- False: When a :Focus.. command creates a new split, retain a copy of the current window in the new window
-- Default: false
require("focus").setup({ split = { bufnew = true } })
```

**Set Focus Auto Numbers**
```lua
-- Displays line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- Default: true
require("focus").setup({ui = { number = false } })
```

**Set Focus Auto Relative Numbers**
```lua
-- Displays relative line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- See :help relativenumber
-- Default: false
require("focus").setup({ ui = { relativenumber = true } })
```

**Set Focus Auto Hybrid Numbers**
```lua
-- Displays hybrid line numbers in the focussed window only
-- Not displayed in unfocussed windows
-- Combination of :help relativenumber, but also displays the line number of the
-- current line only
-- Default: false
require("focus").setup({ ui = { hybridnumber = true} })
```

**Set Presrve Absolute Numbers**
```lua
-- Preserve absolute numbers in the unfocussed windows
-- Works in combination with relativenumber or hybridnumber
-- Default: false
require("focus").setup({ ui = { absolutenumber_unfocussed = true } })
```

**When creating a new split window, use tmux split instead of neovim**
```lua
-- True: Create tmux splits instead of neovim splits
-- False: Create neovim split windows
-- Default: false
require("focus").setup({ split = { tmux = true } })
```

**Set Focus Auto Cursor Line**
```lua
-- Displays a cursorline in the focussed window only
-- Not displayed in unfocussed windows
-- Default: true
require("focus").setup({ ui = { cursorline = false } })
```

**Set Focus Auto Cursor Column**
```lua
-- Displays a cursor column in the focussed window only
-- See :help cursorcolumn for more options
-- Default: false
require("focus").setup({ ui = { cursorcolumn = true } })
```

**Set Focus Auto Color Column**
```lua
-- Displays a color column in the focussed window only
-- See :help colorcolumn for more options
-- Default: enable = false, list = '+1'
require("focus").setup({
    ui = {
        colorcolumn = {
            enable = true,
            list = '+1,+2'
        }
    }
})
```

**Set Focus Auto Sign Column**
```lua
-- Displays a sign column in the focussed window only
-- Gets the vim variable setcolumn when focus.setup() is run
-- See :help signcolumn for more options e.g :set signcolum=yes
-- Default: true, signcolumn=auto
require("focus").setup({ ui = { signcolumn = false } })
```

**Set Focus Window Highlighting**
```lua
-- Enable auto highlighting for focussed/unfocussed windows
-- Default: false
require("focus").setup({ ui = { winhighlight = true } })

-- By default, the highlight groups are setup as such:
--   hi default link FocusedWindow VertSplit
--   hi default link UnfocusedWindow Normal
-- To change them, you can link them to a different highlight group, see
-- `:help hi-default` for more info.
vim.highlight.link('FocusedWindow', 'CursorLine', true)
vim.highlight.link('UnfocusedWindow', 'VisualNOS', true)
```

## Disabling Focus

Focus can be disabled by setting a variable for a buffer
(`vim.b.focus_disable = true`) or globally (`vim.b.focus_disable = true`).

If you want to disable Focus for certain buffer or file types you can do
this by setting up autocommands (`:help autocmd`) in your configuration.

Here is an example:

```lua
local ignore_filetypes = { 'neo-tree' }
local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

local augroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

vim.api.nvim_create_autocmd('WinEnter', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.b.focus_disable = true
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        end
    end,
    desc = 'Disable focus autoresize for FileType',
})
```

## Vim Commands

*For more information on below commands scroll down to see them each described
in more detail*

| _Command_                  | _Description_                                   |
| -------------------------- | ----------------------------------------------- |
| `:FocusDisable`            | Disable the plugin per session. Splits will be normalized back to defaults and then spaced evenly. |
| `:FocusEnable`             | Enable the plugin per session. Splits will be resized back to your configs or defaults if not set. |
| `:FocusToggle`             | Toggle focus on and off again.                  |
| `:FocusSplitNicely`        | Split a window based on the golden ratio rule.  |
| `:FocusSplitCycle`         | If there are no splits, create one and move to it, else cycle focussed split. `:FocusSplitCycle reverse` for counterclockwise |
| `:FocusDisableWindow`      | Disable resizing of the current window (winnr). |
| `:FocusEnableWindow`       | Enable resizing of the current window (winnr).  |
| `:FocusToggleWindow`       | Toggle focus on and off again on a per window basis. |
| `:FocusGetDisabledWindows` | Pretty prints the list of disabled window ID's along with the current window ID. |
| `:FocusSplitLeft`          | Move to existing or create a new split to the left of your current window + open file or custom command. |
| `:FocusSplitDown`          | Move to existing or create a new split to the bottom of your current window + open file or custom command. |
| `:FocusSplitUp`            | Move to existing or create a new split to the top of your current window + open file or custom command. |
| `:FocusSplitRight`         | Move to existing or create a new split to the right of your current window + open file or custom command. |
| `:FocusEqualise`           | Temporarily equalises the splits so they are all of similar width/height. |
| `:FocusMaximise`           | Temporarily maximises the focussed window.      |
| `:FocusMaxOrEqual`         | Toggles Between having the splits equalised or the focussed window maximised. |

## Splitting Nicely

Focus allows you to split windows to tiled windows nicely and sized according to
the golden ratio.

```
+----------------+------------+
|                |    S1      |
|                |            |
|                +------------+
|                |            |
|   MAIN PANE    |    S2      |
|                |            |
|                |            |
|                |            |
+----------------+------------+
```

To get this view you would press the key combination 2 times.

### Split nicely with `<C-l>`

```lua
keymap('n', '<c-l>', function()
    require('focus').split_nicely()
end, { desc = 'split nicely' })
```

Additionally you can open a file or a run a custom command with the
`:FocusSplitNicely` command

*Opens a file in the split created by `FocusSplitNicely` command*

`:FocusSplitNicely README.md`

*Opens a terminal window in the split created by `FocusSplitNicely` command by
 using the cmd arg to run a custom command*

`:FocusSplitNicely cmd term`


## Split directionally

Instead of worrying about multiple commands and shortcuts, *simply think about
splits as to which direction you would like to go*.

Calling a focus split command i.e :FocusSplitRight will do one of two things,
**it will attempt to move across to the window** in the specified direction.
Otherwise, **if no window exists in the specified direction** relative to the
current window **then it will instead create a new blank buffer window** in the
direction specified, and then move to that window.

### Leverage hjkl to move or create your splits directionally

```lua
local focusmap = function(direction)
    vim.keymap.set('n', '<Leader>'..direction, function()
        require('focus').split_command(direction)
    end, { desc = string.format('Create or move to split (%s)', direction) })
end

-- Use `<Leader>h` to split the screen to the left, same as command FocusSplitLeft etc
focusmap('h')
focusmap('j')
focusmap('k')
focusmap('l')
```

Additionally you can open a file or a run a custom command with the
`:FocusSplit<direction>` command

*Opens a file in a split that was either created or moved to*

`:FocusSplitRight README.md`

*Opening a terminal window by using the cmd arg to run a custom command in a
split that was created or moved to*

`:FocusSplitDown cmd term`

## FAQ

* **I have a small display and I am finding splits are resized too much**

  If for example your screen resolution is *1024x768* --> i.e on the smaller
  side, you may notice that focus by default can maximise a window *too much*.

  That is, the window will sort of 'crush' some of your other splits due to the
  limited screen real estate. This is not an issue with focus, but an issue with
  minimal screen real estate. In this case, you can simply reduce the
  width/height of focus.


* **Quickfix window opens in the right split always.
  Is this caused by focus.lua?**

  No. This is a
  [documented](http://vimdoc.sourceforge.net/htmldoc/quickfix.html#quickfix)
  design decision by core vim, this might be something that can be adjusted
  upstream.

  In the meantime, you can open a quickfix window occupying the the full width
  of the window with `:botright copen`

* **I tried to lazy load focus with `:FocusToggle`, but I need to toggle it
  again to get auto-resizing working**

  Please note if you lazy load with command `:FocusToggle`, it will load focus,
  but will toggle it off initially. See
  [#34](https://github.com/beauwilliams/focus.nvim/issues/34).

  This is because focus is toggled on by default when you load focus, so if you
  load it and then run the command `:FocusToggle`, it toggles it off again.

## Similar plugins

* [anuvyklack/windows.nvim](https://github.com/anuvyklack/windows.nvim)
* [zhaocai/GoldenView.Vim](https://github.com/zhaocai/GoldenView.Vim)
* [Bekaboo/deadcolumn.nvim](https://github.com/Bekaboo/deadcolumn.nvim)

## Developers Only

### Contributing

Please before submitting a PR install
[stylua](https://github.com/JohnnyMorganz/StyLua) and run it in the root folder
of `focus.nvim`.

```sh
stylua .
```

This will format the code according to the guidelines set in `.stylua.toml`.

### Testing

You can run the tests using `make test` if you initialise the git submodules.

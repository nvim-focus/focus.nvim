# Testing Guide

This document describes how to run tests for focus.nvim.

## Test Framework

This project uses [mini.test](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-test.md) as the testing framework.

## Running Tests

### Run All Tests

To run all tests in the project:

```bash
make test
```

### Run Individual Test Files

To run a specific test file:

```bash
make test_file FILE=tests/test_ui.lua
```

Available test files:
- `tests/test_ui.lua` - UI-related tests (signcolumn, cursorline, number, etc.)
- `tests/test_autoresize.lua` - Autoresize functionality tests
- `tests/test_splits.lua` - Split window tests
- `tests/test_setup.lua` - Setup and configuration tests

### Increase Test Verbosity

By default, tests show minimal output. You can increase verbosity using the `GROUP_DEPTH` parameter:

#### Default Output (GROUP_DEPTH=1)
```bash
make test
```
Shows only file names with pass/fail symbols:
```
tests/test_ui.lua: oooooooooooooo
```

#### Medium Verbosity (GROUP_DEPTH=2)
```bash
make test GROUP_DEPTH=2
```
Shows file name and test group:
```
tests/test_ui.lua | focus_ui: oooooooooooooo
```

#### Maximum Verbosity (GROUP_DEPTH=3)
```bash
make test_file FILE=tests/test_ui.lua GROUP_DEPTH=3
```
Shows file name, group name, and individual test names:
```
tests/test_ui.lua | focus_ui | number: o
tests/test_ui.lua | focus_ui | number with split: o
tests/test_ui.lua | focus_ui | signcolumn respects disabled state on WinLeave: o
...
```

### Combining Options

You can combine `test_file` with `GROUP_DEPTH`:

```bash
make test_file FILE=tests/test_ui.lua GROUP_DEPTH=3
```

## Test Output Symbols

- `o` (green) - Test passed
- `x` (red) - Test failed
- `s` - Test skipped

## Running Tests Manually

If you prefer to run tests manually without the Makefile:

```bash
nvim --headless --noplugin -u ./tests/minimal_init.lua \
  -c "lua require('mini.test').setup()" \
  -c "lua MiniTest.run({ execute = { reporter = MiniTest.gen_reporter.stdout({ group_depth = 3 }) } })"
```

For a specific file:

```bash
nvim --headless --noplugin -u ./tests/minimal_init.lua \
  -c "lua require('mini.test').setup()" \
  -c "lua MiniTest.run_file('tests/test_ui.lua', { execute = { reporter = MiniTest.gen_reporter.stdout({ group_depth = 3 }) } })"
```

## Writing Tests

Tests are organized in the `tests/` directory. Each test file should:

1. Load the test helpers: `local helpers = dofile('tests/helpers.lua')`
2. Create a child Neovim instance: `local child = helpers.new_child_neovim()`
3. Define test sets using `MiniTest.new_set()`
4. Use expectations like `eq()`, `neq()`, `expect.equality()`, etc.

See existing test files for examples.

## Requirements

- Neovim 0.8.0 or later
- Tests run in headless mode and do not require a display

GROUP_DEPTH ?= 1
NVIM_EXEC ?= nvim

all: test

test:
	$(NVIM_EXEC) --version | head -n 1 && echo ''
	$(NVIM_EXEC) --headless --noplugin -u ./tests/minimal_init.lua \
		-c "lua require('mini.test').setup()" \
		-c "lua MiniTest.run({ execute = { reporter = MiniTest.gen_reporter.stdout({ group_depth = $(GROUP_DEPTH) }) } })"

test_file:
	$(NVIM_EXEC) --version | head -n 1 && echo ''
	$(NVIM_EXEC) --headless --noplugin -u ./tests/minimal_init.lua \
		-c "lua require('mini.test').setup()" \
		-c "lua MiniTest.run_file('$(FILE)', { execute = { reporter = MiniTest.gen_reporter.stdout({ group_depth = $(GROUP_DEPTH) }) } })"

format:
	@command -v stylua >/dev/null 2>&1 || { echo "Error: stylua is not installed. Please install it from https://github.com/JohnnyMorganz/StyLua"; exit 1; }
	stylua .

lint:
	@command -v selene >/dev/null 2>&1 || { echo "Error: selene is not installed. Please install it from https://github.com/Kampfkarren/selene"; exit 1; }
	selene lua/ tests/

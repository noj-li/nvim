vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 8
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

local servers = { "clangd", "lua_ls", "tinymist", "pylsp", "gopls" }

vim.pack.add({
	{ src = "https://github.com/bluz71/vim-moonfly-colors", name = "moonfly" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" }
})

require("trouble").setup()

require("toggleterm").setup({
	open_mapping = [[<c-\>]],
	direction = "float"
})

require("oil").setup({
	columns = {
		"premissions",
		"icon"
	},
	view_options = {
		show_hidden = true
	}
})

require("gitsigns").setup({
	signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '_' },
		topdelete = { text = '-' },
		changedelete = { text = '~' }
	}
})

require("mini.pick").setup()
require("mini.surround").setup()
require("mini.statusline").setup()

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust" }
})

vim.cmd.colorscheme("moonfly")

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>pc", pack_clean)
vim.keymap.set("n", "<leader>e", ":Oil<CR>")
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>")

vim.keymap.set("n", "<leader>q", ":Trouble diagnostics toggle<CR>")

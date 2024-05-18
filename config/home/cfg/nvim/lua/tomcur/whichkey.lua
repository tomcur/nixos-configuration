local wk = require("which-key")
vim.o.timeout = true
vim.o.timeoutlen = 500

wk.setup({
  plugins = {
    spelling = true,
    registers = true,
  },
  key_labels = { ["<leader>"] = "SPC" },
})
wk.register({
  mode = { "n", "v" },
  ["<leader>f"] = { name = "+file" },
  ["<leader>d"] = { name = "+debug" },
})

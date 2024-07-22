local wk = require("which-key")
vim.o.timeout = true
vim.o.timeoutlen = 500

wk.setup({
  plugins = {
    spelling = true,
    registers = true,
  },
  replace = {
    -- set key = {} to not use default which-key formatter
    key = {},
  },
  spec = {
    { "<leader>f", group = "+file", mode = { "n", "v" } },
    { "<leader>d", group = "+debug", mode = { "n", "v" } },
  }
})

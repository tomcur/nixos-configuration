require'leap'.set_default_keymaps()
require'Comment'.setup()
require'indent_blankline'.setup()

-- Treesitter
local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter-parsers"
vim.opt.runtimepath:append(parser_install_dir)
vim.fn.mkdir(parser_install_dir, "p")
vim.cmd("packadd nvim-treesitter")
require'nvim-treesitter.configs'.setup {
  parser_install_dir = parser_install_dir,
  ensure_installed = {
    "nix",
    "rust",
    "python",
    "bash",
    "toml",
    "lua",
    "julia",
    "typescript",
    "javascript",
    "php",
    "hcl", -- Terraform
    "beancount",
  },
  auto_install = false,
  highlight = {
    enable = true,
    disable = { },
  },
  textobjects = {
    enable = true,
    swap = {
      enable = true,
      swap_previous = {
        ["<A-h>"] = {"@parameter.inner", "@statement.outer"},
      },
      swap_next = {
        ["<A-l>"] = {"@parameter.inner", "@statement.outer"},
      },
    },
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- Telescope
-- Truncate / skip previewing big files
local previewers = require('telescope.previewers')
local previewers_utils = require('telescope.previewers.utils')
local max_size = 150 * 1024
local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > max_size then
      -- Skip:
      -- return
      -- Truncate:
      local cmd = {"head", "-c", max_size, filepath}
      previewers_utils.job_maker(cmd, bufnr, opts)
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require('telescope').setup {
  defaults = {
    buffer_previewer_maker = new_maker,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    file_sorter = require'telescope.sorters'.get_fuzzy_file,
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    }
  }
}
require("telescope").load_extension("ui-select")

-- nvim-cmp
vim.o.completeopt="menu,menuone,noselect"
local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
  }),
  -- Preselect does not work nicely with the tab-mapping defined below.
  -- With cmp.select_next_item, hitting tab would skip the preselected item.
  preselect = cmp.PreselectMode.None,
  mapping = {
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        })
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  experimental = {
    ghost_text = true,
  }
})

-- Setting `root_dir` required until
-- https://github.com/neovim/nvim-lsp/commit/1e20c0b29e67e6cd87252cf8fd697906622bfdd3#diff-1cc82f5816863b83f053f5daf2341daf
-- is in nixpkgs repo.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require'lspconfig'.pylsp.setup{
  capabilities = capabilities
}
require'lspconfig'.rust_analyzer.setup{
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        enable = false
      },
    },
  },
}
require'lspconfig'.tsserver.setup{
  capabilities = capabilities
}
require'lspconfig'.terraformls.setup{
  capabilities = capabilities
}
require'lspconfig'.beancount.setup{
  init_options = {
    journal_file = "/home/thomas/data/uint/books/main.beancount",
  };
  capabilities = capabilities
}
require'lspconfig'.bashls.setup{
  capabilities = capabilities
}

require("trouble").setup {}

require("gitsigns").setup {
  signs = {
    add =       {hl = 'GitSignsAdd'   , text = '┃' },
    change =    {hl = 'GitSignsChange', text = '┇' },
    delete =    {hl = 'GitSignsDelete', text = '_' },
    topdelete = {hl = 'GitSignsDelete', text = '‾' },
  }
}

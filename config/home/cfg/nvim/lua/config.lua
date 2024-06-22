require "tomcur.whichkey"

require'leap'.set_default_keymaps()
require'Comment'.setup()

-- LSP window setup
local border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = border
  }
)

vim.diagnostic.config {
  float = { border = border },
  virtual_text = true,
  severity_sort = true,
}

-- Treesitter
local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter-parsers"
vim.opt.runtimepath:append(parser_install_dir)
vim.fn.mkdir(parser_install_dir, "p")
vim.cmd("packadd nvim-treesitter")
require'nvim-treesitter.configs'.setup {
  parser_install_dir = parser_install_dir,
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
        ["<A-h>"] = {
          query = { "@parameter.inner", "@statement.outer" },
          desc = "first match parameter, then statement",
        },
      },
      swap_next = {
        ["<A-l>"] = {
          query = { "@parameter.inner", "@statement.outer" },
          desc = "first match parameter, then statement",
        },
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

local ellipsis = function(str, maxChars)
    if str == nil then
        return nil
    end
    if string.len(str) > maxChars - 1 then
        return string.sub(str, 1, maxChars - 1) .. "…"
    else
        return str
    end
end

-- nvim-cmp
vim.o.completeopt="menu,menuone,noselect"
local cmp = require'cmp'
local lspkind = require('lspkind')
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  }),
  -- Preselect does not work nicely with the tab-mapping defined below.
  -- With cmp.select_next_item, hitting tab would skip the preselected item.
  -- preselect = cmp.PreselectMode.None,
  mapping = {
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if cmp.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = false,
        }) then
          return
        end
      end
      fallback()
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  experimental = {
    -- ghost_text = true,
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.abbr = ellipsis(vim_item.abbr, 30)
      vim_item.menu = ellipsis(vim_item.menu, 30)
      return vim_item
    end
  }
})

-- signature help
require "lsp_signature".setup({
  bind = true,
  handler_opts = {
    border = "rounded",
  },
  fix_pos = true, -- don't close the window until all parameters are entered
})

-- Setting `root_dir` required until
-- https://github.com/neovim/nvim-lsp/commit/1e20c0b29e67e6cd87252cf8fd697906622bfdd3#diff-1cc82f5816863b83f053f5daf2341daf
-- is in nixpkgs repo.
local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
nvim_lsp.pylsp.setup{
  capabilities = capabilities
}
nvim_lsp.rust_analyzer.setup{
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        enable = true
      },
    },
  },
}
nvim_lsp.denols.setup {
  capabilities = capabilities,
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
}
nvim_lsp.tsserver.setup{
  capabilities = capabilities,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false,
}
nvim_lsp.terraformls.setup{
  capabilities = capabilities
}
nvim_lsp.beancount.setup{
  init_options = {
    journal_file = "/home/thomas/data/uint/books/main.beancount",
  };
  capabilities = capabilities
}
nvim_lsp.bashls.setup{
  capabilities = capabilities
}
nvim_lsp.nixd.setup{
  capabilities = capabilities
}

require("trouble").setup {}

require("gitsigns").setup {
  signs = {
    add =       { text = '┃' },
    change =    { text = '┇' },
    delete =    { text = '_' },
    topdelete = { text = '‾' },
  }
}
require("diffview").setup {}

require("oil").setup {}

require "tomcur.dap"

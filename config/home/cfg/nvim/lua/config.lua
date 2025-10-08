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

-- luasnip
local luasnip = require "luasnip"
luasnip.config.set_cofnig = {
  history = false,
  updateevents = "TextChanged,TextChangedI",
}

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

-- nvim-cmp
vim.o.completeopt="menu,menuone,noselect"
local cmp = require'cmp'
local lspkind = require('lspkind')
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
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
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
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

-- Per-project LSP configuration
require("neoconf").setup({})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('pylsp', {
  capabilities = capabilities
})
vim.lsp.enable('pylsp')

vim.lsp.config('rust_analyzer', {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        enable = true
      },
    },
  },
})
vim.lsp.enable('rust_analyzer')

vim.lsp.config('ocamllsp', {
  capabilities=capabilities
})
vim.lsp.enable('ocamllsp')

vim.lsp.config('denols', {
  capabilities = capabilities,
})
vim.lsp.enable('denols')

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  single_file_support = false,
})
vim.lsp.enable('ts_ls')

vim.lsp.config('terraformls', {
  capabilities = capabilities
})
vim.lsp.enable('terraformls')

vim.lsp.config('beancount', {
  init_options = {
    journal_file = "/home/thomas/data/uint/books/main.beancount",
  };
  capabilities = capabilities
})
vim.lsp.enable('beancount')

vim.lsp.config('bashls', {
  capabilities = capabilities
})
vim.lsp.enable('bashls')

vim.lsp.config('nixd', {
  capabilities = capabilities
})
vim.lsp.enable('nixd')

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

require("oil").setup({
    view_options = {
        show_hidden = true,
    },
})

require "tomcur.dap"

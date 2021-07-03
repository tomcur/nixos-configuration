{ pkgs, unstablePkgs, patchedPkgs, neovimPkg, neovimPlugins, ... }:
let
  plugins = pkgs.callPackage ./plugins.nix {
    inherit neovimPlugins;
    buildVimPluginFrom2Nix = (patchedPkgs.vimUtils.override {
      inherit (neovimPkg);
    }).buildVimPluginFrom2Nix;
  };
  neovim = neovimPkg;
in
{
  programs.neovim = {
    enable = true;
    package = neovimPkg;
    extraConfig = builtins.readFile ./rc.vim;
    extraPackages = (with pkgs; [
      python37Packages.black
      python37Packages.python-language-server
      # nodePackages.javascript-typescript-langserver
      nodePackages.typescript-language-server # tsserver
      nodePackages.prettier
      nodePackages.bash-language-server
      shfmt
    ]) ++ (with unstablePkgs; [
      # rustfmt
      # rls
      rust-analyzer
      nixpkgs-fmt
      # rnix-lsp
      # (rWrapper.override { packages = with rPackages; [ readr styler ]; })
      # Preview for nvim telescope
      bat
      # Necessary for minimap.vim
      code-minimap
    ]);
    plugins = with patchedPkgs.vimPlugins; [
      # Impure manager.
      # vim-plug
      # Fuzzy finding.
      fzf-vim
      # Movement.
      {
        plugin = vim-easymotion;
        config = ''
          let g:EasyMotion_do_mapping = 0
          let g:EasyMotion_smartcase = 1
          map  / <Plug>(easymotion-sn)
          omap / <Plug>(easymotion-tn)
          map  n <Plug>(easymotion-next)
          map  N <Plug>(easymotion-prev)
          map  <leader>d <Plug>(easymotion-bd-f)
          nmap <leader>d <Plug>(easymotion-overwin-f)
          map  <leader>w <Plug>(easymotion-bd-w)
          nmap <leader>w <Plug>(easymotion-overwin-w)
          map  <leader>j <Plug>(easymotion-j)
          map  <leader>k <Plug>(easymotion-k)
        '';
      }
      # Languages.
      vim-nix
      vim-javascript
      purescript-vim
      ### Currently not in repo:
      # vim-jsx-typescript
      vim-tsx
      typescript-vim
      # Buffer formatting.
      neoformat
      NeoSolarized
      # Themes.
      awesome-vim-colorschemes
      plugins.vim-monochrome
      plugins.vim-colors-pencil
      plugins.vim-photon
      # Fonts
      nvim-web-devicons
      # Highlight yank.
      vim-highlightedyank
      # RGB string colorizer.
      plugins.nvim-colorizer-lua
      # Popup finder.
      plugins.popup
      plugins.plenary
      plugins.lsp-extensions
      {
        plugin = plugins.telescope;
        config = ''
          " File and buffer opening
          lua << EOF
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
            }
          }
          EOF
        '';
      }
      # Update location list position.
      {
        plugin = plugins.vim-loclist-follow;
        config = ''
          " packadd vim-loclist-follow
          let g:loclist_follow = 1
          let g:loclist_follow_modes = 'ni'
          let g:loclist_follow_target = 'nearest'

          nnoremap <silent> [l     <cmd>lprevious<CR>
          nnoremap <silent> ]l     <cmd>lnext<CR>
          nnoremap <silent> [q     <cmd>cprevious<CR>
          nnoremap <silent> ]q     <cmd>cnext<CR>
        '';
      }
      # Colorscheme framework.
      plugins.colorbuddy

      {
        plugin = plugins.minimap-vim;
        config = ''
          highlight Minimap gui=None
          highlight MinimapBase gui=None
          " let g:minimap_auto_start = 1
          " let g:minimap_auto_start_win_enter = 1
          let g:minimap_left = 0
          let g:minimap_width = 8
          let g:minimap_highlight = "Minimap"
          let g:minimap_base_highlight = "MinimapBase"
        '';
      }

      # Register preview.
      plugins.registers-nvim

      # Aid completion
      {
        plugin = plugins.completion-nvim;
        optional = true;
        config = ''
          packadd completion-nvim
          inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
          inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
          set completeopt=menuone,noinsert,noselect
          set shortmess+=c
        '';
      }

      # LSP.
      {
        plugin = nvim-lspconfig;
        optional = true;
        config = ''
          " Setting `root_dir` required until
          " https://github.com/neovim/nvim-lsp/commit/1e20c0b29e67e6cd87252cf8fd697906622bfdd3#diff-1cc82f5816863b83f053f5daf2341daf
          " is in nixpkgs repo.
          packadd nvim-lspconfig
          lua << EOF
          vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
              underline = true,
              virtual_text = false,
              signs = true,
              update_in_insert = false,
            }
          )

          require'lspconfig'.pyls.setup{
            root_dir = function(fname)
              return vim.fn.getcwd()
            end;
            on_attach=require'completion'.on_attach
          }
          require'lspconfig'.rust_analyzer.setup{
            on_attach=require'completion'.on_attach
          }
          require'lspconfig'.tsserver.setup{
            on_attach=require'completion'.on_attach
          }
          require'lspconfig'.bashls.setup{
            on_attach=require'completion'.on_attach
          }
          -- require'lspconfig'.rnix.setup{}

          update_diagnostics_qflist = function()
            local buf = vim.api.nvim_get_current_buf()
            local diagnostics = vim.lsp.diagnostic.get(buf)
            local items = {}
            if diagnostics then
              for _, d in ipairs(diagnostics) do
                table.insert(items, {
                  bufnr = buf,
                  lnum = d.range.start.line + 1,
                  col = d.range.start.character + 1,
                  text = d.message,
                })
              end

              table.sort(items, function(i1, i2)
                if i1.bufnr == i2.bufnr then
                  if i1.lnum == i2.lnum then
                    return i1.col < i2.col
                  else
                    return i1.lnum < i2.lnum
                  end
                else
                  return i1.bufnr < i2.bufnr
                end
              end)

              vim.lsp.util.set_qflist(items)
            end
          end
          EOF

          autocmd! User LspDiagnosticsChanged lua update_diagnostics_qflist()
          autocmd! BufEnter * lua update_diagnostics_qflist()
        '';
      }
      {
        plugin = plugins.trouble-nvim;
        optional = true;
        config = ''
          packadd trouble.nvim
          lua << EOF
            require("trouble").setup {}
          EOF
        '';
      }
      {
        plugin = plugins.gitsigns-nvim;
        optional = true;
        config = ''
          packadd gitsigns.nvim
          lua << EOF
          require("gitsigns").setup {
            signs = {
              add =       {hl = 'GitSignsAdd'   , text = '┃' },
              change =    {hl = 'GitSignsChange', text = '┇' },
              delete =    {hl = 'GitSignsDelete', text = '_' },
              topdelete = {hl = 'GitSignsDelete', text = '‾' },
            }
          }
          EOF
        '';
      }
      # Treesitter.
      {
        plugin = plugins.nvim-treesitter;
        optional = true;
      }
      {
        plugin = plugins.nvim-treesitter-textobjects;
        optional = true;
      }
    ];
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  home.file =
    let
      jsCommon = ''
        nmap <buffer><leader>mf :Neoformat<cr>
        set shiftwidth=2
      '';
    in
    {
      ".config/nvim/lua".source = ./lua;
      ".config/nvim/colors".source = ./colors;
      ".config/nvim/ftplugin/nix.vim".text = ''
        nmap <buffer><leader>mf :Neoformat nixpkgsfmt<cr>
      '';
      ".config/nvim/ftplugin/rust.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/sh.vim".text = ''
        let g:shfmt_opt="-ci"
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/python.vim".text = ''
        nmap <buffer><leader>mf :Neoformat black<cr>
        nmap <buffer><leader>mi :Neoformat isort<cr>
      '';
      ".config/nvim/ftplugin/javascript.vim".text = ''
        ${jsCommon}
      '';
      ".config/nvim/ftplugin/typescript.vim".text = ''
        ${jsCommon}
      '';
      ".config/nvim/ftplugin/r.vim".text = ''
        nmap <buffer><leader>mf :Neoformat styler<cr>
      '';
      ".config/nvim/ftplugin/tex.vim".text = ''
        let g:neoformat_tex_mylatexindent = {
          \ 'exe': 'latexindent',
          \ 'args': ['-l'],
          \ 'stdin': 1,
          \ }
        let g:neoformat_enabled_tex = ['mylatexindent']
        nmap <buffer><leader>mf :Neoformat<cr>
        setlocal textwidth=79
        setlocal spell
      '';
      ".config/nvim/ftplugin/mail.vim".text = ''
        setlocal textwidth=79
        setlocal spell
      '';
      ".config/nvim/ftplugin/css.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/html.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftdetect/html.vim".text = ''
        autocmd BufNewFile,BufRead *.html.tera setf html
      '';
      ".config/nvim/ftplugin/htmldjango.vim".text = ''
        let g:neoformat_htmldjango_htmlbeautify = {
          \ 'exe': 'html-beautify',
          \ 'args': ['--indent-size ' .shiftwidth()],
          \ 'stdin': 1,
          \ }
        let g:neoformat_enabled_htmldjango = ['htmlbeautify']
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftdetect/toml.vim".text = ''
        " From: https://github.com/cespare/vim-toml/blob/master/ftdetect/toml.vim
        " Go dep and Rust use several TOML config files that are not named with .toml.
        autocmd BufNewFile,BufRead *.toml,Gopkg.lock,Cargo.lock,*/.cargo/config,*/.cargo/credentials,Pipfile setf toml
      '';
      # ABI incompatibilities. Should use https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lockfile.json
      # ".config/nvim/parser/bash.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
      # ".config/nvim/parser/javascript.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
      # ".config/nvim/parser/julia.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-julia}/parser";
      # ".config/nvim/parser/lua.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
      # ".config/nvim/parser/nix.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
      # ".config/nvim/parser/php.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-php}/parser";
      # ".config/nvim/parser/python.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
      # ".config/nvim/parser/rust.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
      # ".config/nvim/parser/toml.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-toml}/parser";
      # ".config/nvim/parser/typescript.so".source = "${patchedPkgs.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
    };

}

{ pkgs, stablePkgs, patchedPkgs, neovimPkg, neovimPlugins, hiNvimRsBuildColorscheme, ... }:
let
  plugins = pkgs.callPackage ./plugins.nix {
    inherit neovimPlugins;
    buildVimPluginFrom2Nix = pkgs.vimUtils.buildVimPluginFrom2Nix;
  };
in
{
  home.packages = [
    patchedPkgs.neovide
  ];

  programs.neovim = {
    enable = true;
    # package = neovimPkg;
    package = pkgs.neovim-unwrapped;
    extraPackages = (with stablePkgs; [
      python3Packages.black
      python3Packages.isort
      python3Packages.python-lsp-server
      nodePackages.typescript-language-server # tsserver
      nodePackages.prettier
      nodePackages.bash-language-server
    ]) ++ (with pkgs; [
      nixd # nix language server
      beancount
      beancount-language-server
      shfmt
      nodejs
      # rustfmt
      # rls
      rust-analyzer
      nixpkgs-fmt
      # PostgreSQL formatter
      pgformatter
      # rnix-lsp
      # (rWrapper.override { packages = with rPackages; [ readr styler ]; })
      # Preview for nvim telescope
      bat
    ]);
    plugins = (with plugins; [
      vim-monochrome
    ]) ++ (with pkgs.vimPlugins; [
      plenary-nvim
      # Impure manager.
      # vim-plug
      # Fuzzy finding.
      fzf-vim
      # Movement.
      leap-nvim
      # File system manipulation.
      oil-nvim
      vim-eunuch
      # Languages.
      vim-nix
      vim-javascript
      purescript-vim
      ### Currently not in repo:
      # vim-jsx-typescript
      vim-tsx
      typescript-vim
      # Comment regions.
      comment-nvim
      # Buffer formatting.
      neoformat
      # Themes.
      NeoSolarized
      awesome-vim-colorschemes
      # Fonts
      nvim-web-devicons
      # RGB string colorizer.
      nvim-colorizer-lua
      # Identation guide.
      indent-blankline-nvim
      # Popup finder.
      telescope-nvim
      telescope-ui-select-nvim

      # Keybinding reminder
      which-key-nvim

      # Aid completion
      luasnip
      cmp-nvim-lsp
      cmp-path
      nvim-cmp
      lspkind-nvim # cmp formatting

      # Signature help.
      lsp_signature-nvim

      # LSP.
      neoconf-nvim # per-project configuration of language servers
      nvim-lspconfig

      # Diagnostics
      trouble-nvim

      # Git
      gitsigns-nvim
      fugitive
      diffview-nvim

      # Treesitter.
      nvim-treesitter
      nvim-treesitter-textobjects

      nvim-treesitter-parsers.markdown
      nvim-treesitter-parsers.markdown_inline
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.wgsl
      nvim-treesitter-parsers.python
      nvim-treesitter-parsers.bash
      nvim-treesitter-parsers.toml
      nvim-treesitter-parsers.lua
      nvim-treesitter-parsers.julia
      nvim-treesitter-parsers.typescript
      nvim-treesitter-parsers.tsx
      nvim-treesitter-parsers.javascript
      nvim-treesitter-parsers.html
      nvim-treesitter-parsers.css
      nvim-treesitter-parsers.php
      nvim-treesitter-parsers.hcl # Terraform
      nvim-treesitter-parsers.beancount

      # Debug adapter protocol
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
    ]);
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
    NeovideMultiGrid = "1";
  };

  home.file =
    let
      jsCommon = ''
        nmap <buffer><leader>mf :Neoformat<cr>
        set shiftwidth=2
      '';
    in
    {
      ".config/nvim/init.vim".source = ./rc.vim;
      ".config/nvim/lua".source = ./lua;
      ".config/nvim/colors/highlow.vim".source = hiNvimRsBuildColorscheme {
        name = "highlow";
        colorschemeFile = ./highlow.toml;
        target = "neovim";
      };
      ".config/nvim/ftplugin/nix.vim".text = ''
        nmap <buffer><leader>mf :Neoformat nixpkgsfmt<cr>
      '';
      ".config/nvim/ftplugin/rust.vim".text = ''
        " nmap <buffer><leader>mf :Neoformat<cr>
        " Use LSP formatting for Rust. Maybe do something smarter for fallbacks in the future.
        nmap <buffer><leader>mf :lua vim.lsp.buf.format()<cr>
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
      ".config/nvim/ftplugin/scss.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/css.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/html.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/terraform.vim".text = ''
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
      ".config/nvim/ftplugin/sql.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      # nvim-dap requires configuring lldb-vscode at an absolute path, so just
      # symlink to a known place
      ".config/nvim/lldb-vscode".source = "${pkgs.lldb}/bin/lldb-vscode";
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

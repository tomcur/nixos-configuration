filetype plugin on
set mouse=a
syntax enable
set number
set signcolumn=yes
set foldcolumn=auto
set cmdheight=2
highlight LineNr ctermfg=white
set hidden
set statusline=%f%=%r%m%y\ %P\ %l,%c
set nojoinspaces
set spelllang=en_us,nl

" Searching
set ignorecase
set smartcase

" Some LSP servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Input tab as space
set shiftwidth=4
set expandtab smarttab

set wildignore+=*/tmp/*,*/target/*,*.obj,*.class,*.o,*.so

" Preview substitution
set inccommand=nosplit

" Key mappings
let mapleader="\<Space>"

"" Editing
" Also clear search highlight on escape
" nnoremap <esc> :noh<return><esc>

" Movement
lua << EOF
  -- Deal with word wrap
  vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
  vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })
  vim.api.nvim_set_keymap('v', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
  vim.api.nvim_set_keymap('v', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })
EOF

" map /         <cmd>HopPattern<cr> " only searches currently visible part
map <leader>d <cmd>HopChar1<cr>
map <leader>w <cmd>HopWord<cr>
map <leader>l <cmd>HopLine<cr>

""" Moving lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv


"" File opening
nmap <leader>b <cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({sort_lastused = true}))<cr>
nmap <leader>fo <cmd>lua require('telescope.builtin').find_files()<cr>
nmap <leader>fd :Explore<cr>
nmap <leader>fg <cmd>lua require('telescope.builtin').git_files()<cr>
nmap <leader>fr <cmd>lua require('telescope.builtin').live_grep()<cr>

"" Diagnostics
nnoremap <silent> <F5>  <cmd>TroubleToggle<CR>
inoremap <silent> <F5>  <cmd>TroubleToggle<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gy    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <silent> gs    <cmd>lua require'telescope.builtin'.treesitter{}<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
inoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

nnoremap <silent> <Leader>T <cmd>:lua require'lsp_extensions'.inlay_hints({prefix="⁖ ", enabled={"TypeHint", "ChainingHint"}})<CR>
nnoremap <silent> <Leader>t <cmd>:lua require'lsp_extensions'.inlay_hints({prefix="⁖ ", enabled={"TypeHint", "ChainingHint"}, only_current_line=true})<CR>

" Treesitter
packadd nvim-treesitter
packadd nvim-treesitter-textobjects
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "nix", "rust", "python", "bash", "toml", "lua", "julia", "typescript", "javascript", "php" },
  highlight = {
    enable = true,
    disable = { },
  },
  textobjects = {
    enable = true,
    swap = {
      enable = true,
      swap_previous = {
        ["<A-h>"] = "@parameter.inner",
      },
      swap_next = {
        ["<A-l>"] = "@parameter.inner",
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
EOF

" Default .tex to LaTeX
let g:tex_flavor = "latex"

" Theme
function! s:ui_enter()
  set guicursor=n-v-c:block-Cursor
  set guicursor+=i:ver25-Cursor
  set guicursor+=r-cr-o:hor20-Cursor
  if get(v:event, "chan") == 0
      set termguicolors
  else
      set guifont=iosevka:h14.0
  endif
  if exists("g:neovide")
      let g:neovide_cursor_animate_command_line=v:false
      let g:neovide_cursor_animate_in_insert_mode=v:false
      let g:neovide_cursor_animation_length=0.06
      let g:neovide_window_floating_blur=v:false
      let g:neovide_window_floating_opacity=1.0
  end
  " let g:neosolarized_vertSplitBgTrans = 1
  " let g:neosolarized_bold = 1
  " let g:neosolarized_underline = 1
  " set background=light
  " let g:neosolarized_italic = 1
  " colorscheme NeoSolarized
  colorscheme highlow
  set background=light

  " colorscheme PaperColor

  " colorscheme sierra
  " colorscheme anderson
  " colorscheme photon

  "" Monochrome:
  " let g:monochrome_italic_comments = 1
  " colorscheme monochrome
  " hi Normal guibg=#141414
  hi Type gui=bold
  hi Statement gui=bold
  hi Comment gui=italic

  " I'm not sure why this is necessary, but otherwise LSP diagnostics are not
  " highlighted:
  " lua require('vim.diagnostic')._define_default_signs_and_highlights()
  " Some things changed: https://github.com/neovim/neovim/pull/15585
  " https://github.com/neovim/neovim/commit/a5bbb932f9094098bd656d3f6be3c58344576709

  " Color string colorizer
  lua require'colorizer'.setup()
endfunction

au UIEnter * call s:ui_enter()

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

nmap <leader>s <cmd>call SynStack()<cr>

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({ higroup = "IncSearch", timeout = 1000 })
augroup END

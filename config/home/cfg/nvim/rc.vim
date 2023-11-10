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

lua require("config")

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
nnoremap          <leader>xx <cmd>TroubleToggle<CR>
nnoremap          <leader>xw <cmd>TroubleToggle workspace_diagnostics<CR>
nnoremap          <leader>xd <cmd>TroubleToggle document_diagnostics<CR>
nnoremap <silent> K          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd         <cmd>lua require'telescope.builtin'.lsp_definitions{}<CR>
nnoremap <silent> gy         <cmd>lua require'telescope.builtin'.lsp_type_definitions{}<CR>
nnoremap <silent> gr         <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <silent> gs         <cmd>lua require'telescope.builtin'.treesitter{}<CR>
nnoremap <silent> <c-k>      <cmd>lua vim.lsp.buf.signature_help()<CR>
inoremap <silent> <c-k>      <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>a  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> <leader>t <cmd>:lua vim.lsp.inlay_hint(0)<CR>

"" Git
noremap <expr> <leader>dp &diff ? ":diffput\<CR>" : ":Gitsigns stage_hunk\<CR>"
noremap <expr> <leader>do &diff ? ":diffget\<CR>" : ":Gitsigns reset_hunk\<CR>"
noremap <silent> <leader>du :Gitsigns undo_stage_hunk<CR>

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

  " indent-blankline
  " Currently must be called after colorscheme has been setup. It appears not
  " to update highlights on the fly.
  " " Seems to cause performance issues
  "  lua << EOF
  "    require'ibl'.setup({
  "      indent = {
  "        char = "▏",
  "      },
  "      scope = {
  "        show_start = false,
  "        show_end = false,
  "      },
  "    })
  "EOF
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

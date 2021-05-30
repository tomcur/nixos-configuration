filetype plugin on
set mouse=a
syntax on
set number
set signcolumn=yes
set foldcolumn=auto
set cmdheight=2
highlight LineNr ctermfg=white
set hidden
set statusline=%f%=%r%m%y\ %P\ %l,%c

function! s:ui_enter()
  set guicursor=n-v-c:block-Cursor
  set guicursor+=i:ver25-Cursor
  set guicursor+=r-cr-o:hor20-Cursor
  if get(v:event, "chan") == 0
      set termguicolors
  else
      set guifont=iosevka:h12.0
  endif
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
  lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights()

  " Color string colorizer
  lua require'colorizer'.setup()
endfunction

au UIEnter * call s:ui_enter()

" Input tab as space
set shiftwidth=4
set expandtab smarttab

let mapleader="\<Space>"

" File and buffer opening
nmap <leader>b <cmd>lua require('telescope.builtin').buffers({sort_lastused = true})<cr>
nmap <leader>fo <cmd>lua require('telescope.builtin').find_files()<cr>
nmap <leader>fd :Explore<cr>
nmap <leader>fg <cmd>lua require('telescope.builtin').git_files()<cr>
nmap <leader>fr <cmd>lua require('telescope.builtin').live_grep()<cr>

set wildignore+=*/tmp/*,*/target/*,*.obj,*.class,*.o,*.so

" Also clear search highlight on escape
" nnoremap <esc> :noh<return><esc>

" Moving lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Preview substitution
set inccommand=nosplit

" Easymotion
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

" Completion
packadd completion-nvim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" LSP
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

function! ToggleQflist()
    for winnr in range(1, winnr('$'))
        if getwinvar(winnr, '&syntax') == 'qf'
            cclose
            return
        endif
    endfor

    copen
    wincmd p
endfunction

nnoremap <silent> <F5>  <cmd>call ToggleQflist()<CR>
inoremap <silent> <F5>  <cmd>call ToggleQflist()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gy    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <silent> gs    <cmd>lua require'telescope.builtin'.treesitter{}<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
inoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

nnoremap <silent> <Leader>T <cmd>:lua require'lsp_extensions'.inlay_hints({prefix="⁖ ", enabled={"TypeHint", "ChainingHint"}})<CR>
nnoremap <silent> <Leader>t <cmd>:lua require'lsp_extensions'.inlay_hints({prefix="⁖ ", enabled={"TypeHint", "ChainingHint"}, only_current_line=true})<CR>

"" Some LSP servers have issues with backup files, see #649
set nobackup
set nowritebackup

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


nnoremap <silent> [l     <cmd>lprevious<CR>
nnoremap <silent> ]l     <cmd>lnext<CR>
nnoremap <silent> [q     <cmd>cprevious<CR>
nnoremap <silent> ]q     <cmd>cnext<CR>

" Location list following
packadd vim-loclist-follow
let g:loclist_follow = 1
let g:loclist_follow_modes = 'ni'
let g:loclist_follow_target = 'nearest'

" Telescope
lua <<EOF
require('telescope').setup{
  defaults = {
    preview_cutoff = 80,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new
  }
}
EOF

" minimap.vim
highlight Minimap gui=None
highlight MinimapBase gui=None
" let g:minimap_auto_start = 1
" let g:minimap_auto_start_win_enter = 1
let g:minimap_left = 0
let g:minimap_width = 8
let g:minimap_highlight = "Minimap"
let g:minimap_base_highlight = "MinimapBase"

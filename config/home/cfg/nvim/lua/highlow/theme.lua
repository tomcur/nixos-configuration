local M = {}

local function highlight(group, hi)
    if hi.link then
        vim.cmd("highlight! link " .. group .. " " .. hi.link)
    else
        local fg = "guifg=" .. (hi.fg or "NONE")
        local bg = "guibg=" .. (hi.bg or "NONE")
        local sp = "guisp=" .. (hi.sp or "NONE")
        local style = "gui=" .. (hi.style or "NONE")

        vim.cmd("highlight! " .. group .. " " .. fg .. " " .. bg .. " " .. sp .. " " .. style)
    end
end

function M.setupWithColors(colors)
    local groups = {}

    groups.Normal =       { fg = colors.fg, bg = colors.bg }
    groups.Comment =      { fg = colors.grey_d, style = "italic"} 
    groups.Operator =     { fg = colors.grey }
    groups.Delimiter =    { fg = colors.grey }
    groups.MatchParen =   { bg = colors.highlightbg }
    groups.Keyword =      { fg = colors.purple_a }
    groups.Conditional =  { fg = colors.purple, style = "bold" }
    groups.Repeat =       { link = "Conditional" }
    groups.Statement =    { link = "Conditional" }
    groups.Variable =     { link = "Normal" }
    groups.Function =     { fg = colors.blue_a }
    groups.Type =         { fg = colors.pink, style = "bold" }
    groups.Define =       { link = "Type" }
    groups.Include =      { fg = colors.pink_d }
    groups.Identifier =   { fg = colors.blue_d }
    groups.Label =        { link = "Identifier" }
    groups.Constant =     { fg = colors.blue }
    groups.Number =       { fg = colors.orange }
    groups.Float =        { link = "Number" }
    groups.String =       { link = "Constant" }
    groups.Character =    { link = "Constant" }
    groups.Boolean =      { link = "Conditional" }
    groups.Exception =    { fg = colors.red, style = "bold" }

    groups.Special = { fg = colors.yellow }
    groups.PreProc = { fg = colors.yellow }

    groups.Error =      { fg = colors.red_aa, style = "bold" }
    groups.ErrorMsg =   { link = "Error" }
    groups.Warning =    { fg = colors.orange, style = "bold" }
    groups.WarningMsg = { link = "Warning" }

    -- Vim coloring:
    groups.Cursor =  { fg = colors.bg, bg = colors.blue_d }
    groups.iCursor = { link = "Cursor" }
    groups.vCursor = { link = "Cursor" }
    groups.cCursor = { link = "Cursor" }
    groups.iCursor = { link = "Cursor" }
    groups.TermCursor = { link = "Cursor" }
    groups.VitalOverCommandLineCursor = { link = "Cursor" }

    groups.Visual = { fg = colors.bg, bg = colors.blue_d }

    groups.SpecialKey = { fg = colors.blue_a, style = "italic" }

    groups.CursorColumn = { bg = colors.highlightbg }
    groups.CursorLine =   { link = "CursorColumn" }
    groups.Warnings =     { fg = colors.orange, style = "bold "}

    groups.SignColumn =   { fg = colors.grey_d, bg = colors.darkbg }
    groups.LineNr =       { link = "SignColumn" }
    groups.CursorLineNr = { fg = colors.blue, bg = colors.bg, style = "bold" }

    groups.FoldColumn = { fg = colors.fg, bg = groups.SignColumn.bg }

    groups.Folded = { fg = colors.fg, bg = colors.verydarkbg }

    groups.StatusLine =   { fg = colors.bg, bg = colors.blue_d }
    groups.StatusLineNC = { fg = colors.fg, bg = colors.blue_pp }

    groups.VertSplit = { fg = colors.highlightbg, bg = colors.bg }

    groups.Search =     { fg = colors.fg, bg = colors.highlightbg, style = "bold" }
    groups.IncSearch =  { fg = colors.highlightbg, bg = colors.fg }
    groups.Substitute = { fg = colors.highlightbg, bg = colors.fg }

    groups.Directory = { link = "Include" }

    groups.Title =    { fg = colors.purple }
    groups.Question = { fg = colors.green }
    groups.MoreMsg =  { link = "Question" }
    groups.NonText =  { fg = colors.red_aa }

    groups.Pmenu =       { fg = colors.fg, bg = colors.verydarkbg }
    groups.NormalFloat = { fg = colors.fg, bg = colors.verydarkbg }

    -- Some plugin coloring:
    groups.TSVariableBuiltin = { link = "Constant" }

    groups.LSPDiagnosticsDefaultHint =        { link = "Comment" }
    groups.LSPDiagnosticsDefaultInformation = { link = "Normal" }
    groups.LSPDiagnosticsDefaultWarning =     { link = "Warning" }
    groups.LSPDiagnosticsDefaultError =       { link = "Error" }

    groups.HopNextKey =   { fg = colors.red_a, style = "bold" }
    groups.HopNextKey1 =  { fg = colors.red_a, style = "bold" }
    groups.HopNextKey2 =  { fg = colors.red_p, style = "bold" }
    groups.HopUnmatched = { fg = colors.grey_dd }

    groups.MinimapBase = { fg = colors.grey_dd }
    groups.Minimap =     { fg = colors.fg }

    groups.HighlightedyankRegion = { bg = colors.highlightbg }

    groups.GitSignsAdd =    { fg = colors.structural_green, bg = colors.darkbg }
    groups.GitSignsDelete = { fg = colors.structural_red,   bg = colors.darkbg }
    groups.GitSignsChange = { fg = colors.structural_blue,  bg = colors.darkbg }

    for group, hi in pairs(groups) do
        highlight(group, hi)
    end
end

return M

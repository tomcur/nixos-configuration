local M = {}

local function highlight(groups, group, hi)
    groups[group] = hi
    if hi.link then
        vim.cmd("highlight link " .. group .. " " .. hi.link)
    else
        local fg = "guifg=" .. (hi.fg or "NONE")
        local bg = "guibg=" .. (hi.bg or "NONE")
        local sp = "guisp=" .. (hi.sp or "NONE")
        local style = "gui=" .. (hi.style or "NONE")

        vim.cmd("highlight " .. group .. " " .. fg .. " " .. bg .. " " .. sp .. " " .. style)
    end
end

function M.setupWithColors(colors)
    local groups = {}

    -- For some reason, using `highlight link` sometimes fails.
    -- For now just "link" the tables in lua.

    highlight(groups, "Normal",        { fg = colors.fg, bg = colors.bg })
    highlight(groups, "Comment",       { fg = colors.grey_d, style = "italic"})
    highlight(groups, "Operator",      { fg = colors.grey })
    highlight(groups, "Delimiter",     { fg = colors.grey })
    highlight(groups, "MatchParen",    { bg = colors.highlightbg })
    highlight(groups, "Keyword",       { fg = colors.purple_a })
    highlight(groups, "Conditional",   { fg = colors.purple, style = "bold" })
    highlight(groups, "Repeat",        groups.Conditional) -- { link = "Conditional" })
    highlight(groups, "Statement",     groups.Conditional) -- { link = "Conditional" })
    highlight(groups, "Variable",      groups.Normal) -- { link = "Normal" })
    highlight(groups, "Function",      { fg = colors.blue_a })
    highlight(groups, "Type",          { fg = colors.pink, style = "bold" })
    highlight(groups, "Define",        groups.Type) -- { link = "Type" })
    highlight(groups, "Include",       { fg = colors.pink_d })
    highlight(groups, "Identifier",    { fg = colors.blue_d })
    highlight(groups, "Label",         groups.Identifier) -- { link = "Identifier" })
    highlight(groups, "Constant",      { fg = colors.blue })
    highlight(groups, "Number",        { fg = colors.orange })
    highlight(groups, "Float",         groups.Number) -- { link = "Number" })
    highlight(groups, "String",        groups.Constant) -- { link = "Constant" })
    highlight(groups, "Character",     groups.Constant) -- { link = "Constant" })
    highlight(groups, "Boolean",       groups.Conditional) -- { link = "Conditional" })
    highlight(groups, "Exception",     { fg = colors.red, style = "bold" })

    highlight(groups, "Special", { fg = colors.yellow })
    highlight(groups, "PreProc", { fg = colors.yellow })

    highlight(groups, "Error",      { fg = colors.red_aa, style = "bold" })
    highlight(groups, "ErrorMsg",   groups.Error) -- { link = "Error" })
    highlight(groups, "Warning",    { fg = colors.orange, style = "bold" })
    highlight(groups, "WarningMsg", groups.Warning) -- { link = "Warning" })

    -- Vim coloring:
    highlight(groups, "Cursor",  { fg = colors.bg, bg = colors.blue_d })
    highlight(groups, "iCursor", groups.Cursor) -- { link = "Cursor" })
    highlight(groups, "vCursor", groups.Cursor) -- { link = "Cursor" })
    highlight(groups, "cCursor", groups.Cursor) -- { link = "Cursor" })
    highlight(groups, "iCursor", groups.Cursor) -- { link = "Cursor" })
    highlight(groups, "TermCursor", groups.Cursor) -- { link = "Cursor" })
    highlight(groups, "VitalOverCommandLineCursor", groups.Cursor) -- { link = "Cursor" })

    highlight(groups, "Visual", { bg = colors.visualbg })

    highlight(groups, "SpecialKey", { fg = colors.blue_a, style = "italic" })

    highlight(groups, "CursorColumn", { bg = colors.highlightbg })
    highlight(groups, "CursorLine",   groups.CursorColumn) -- { link = "CursorColumn" })
    highlight(groups, "Warnings",     { fg = colors.orange, style = "bold "})

    highlight(groups, "SignColumn",   { fg = colors.grey_d, bg = colors.darkbg })
    highlight(groups, "LineNr",       groups.SignColumn) -- { link = "SignColumn" })
    highlight(groups, "CursorLineNr", { fg = colors.blue, bg = colors.bg, style = "bold" })

    highlight(groups, "FoldColumn", { fg = colors.fg, bg = groups.SignColumn.bg })

    highlight(groups, "Folded", { fg = colors.fg, bg = colors.verydarkbg })

    highlight(groups, "StatusLine",   { fg = colors.bg, bg = colors.blue_d })
    highlight(groups, "StatusLineNC", { fg = colors.fg, bg = colors.blue_pp })

    highlight(groups, "VertSplit", { fg = colors.highlightbg, bg = colors.bg })

    highlight(groups, "Search",     { fg = colors.fg, bg = colors.highlightbg, style = "bold" })
    highlight(groups, "IncSearch",  { fg = colors.highlightbg, bg = colors.fg })
    highlight(groups, "Substitute", { fg = colors.highlightbg, bg = colors.fg })

    highlight(groups, "Directory", groups.Include) -- { link = "Include" })

    highlight(groups, "Title",      { fg = colors.purple })
    highlight(groups, "Question",   { fg = colors.green })
    highlight(groups, "MoreMsg",    groups.Question) -- { link = "Question" })
    highlight(groups, "NonText",    { fg = colors.red_aa })
    highlight(groups, "Whitespace", { fg = colors.verydarkbg })

    highlight(groups, "Pmenu",       { fg = colors.fg, bg = colors.verydarkbg })
    highlight(groups, "NormalFloat", { fg = colors.fg, bg = colors.verydarkbg })

    -- Some plugin coloring:
    highlight(groups, "TSVariableBuiltin", groups.Constant) -- { link = "Constant" })

    highlight(groups, "LSPDiagnosticsDefaultHint",        groups.Comment) -- { link = "Comment" })
    highlight(groups, "LSPDiagnosticsDefaultInformation", groups.Normal) -- { link = "Normal" })
    highlight(groups, "LSPDiagnosticsDefaultWarning",     groups.Warning) -- { link = "Warning" })
    highlight(groups, "LSPDiagnosticsDefaultError",       groups.Error) -- { link = "Error" })

    highlight(groups, "TelescopeSelection", groups.Visual)
    highlight(groups, "TelescopeMatching", { fg = colors.red_a, style = "bold" })

    highlight(groups, "HopNextKey",   { fg = colors.red_a, style = "bold" })
    highlight(groups, "HopNextKey1",  { fg = colors.red_a, style = "bold" })
    highlight(groups, "HopNextKey2",  { fg = colors.red_p, style = "bold" })
    highlight(groups, "HopUnmatched", { fg = colors.grey_dd })

    highlight(groups, "MinimapBase", { fg = colors.grey_dd })
    highlight(groups, "Minimap",     { fg = colors.fg })

    highlight(groups, "HighlightedyankRegion", { bg = colors.highlightbg })

    highlight(groups, "GitSignsAdd",    { fg = colors.structural_green, bg = colors.darkbg })
    highlight(groups, "GitSignsDelete", { fg = colors.structural_red,   bg = colors.darkbg })
    highlight(groups, "GitSignsChange", { fg = colors.structural_blue,  bg = colors.darkbg })

    highlight(groups, "IndentBlanklineChar", groups.Whitespace) -- { link = "Whitespace" })
end

return M

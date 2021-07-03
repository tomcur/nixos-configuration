-- A high foreground-background contrast, low between-keyword contrast colorscheme.

local Color, colors, Group, groups, styles = require('colorbuddy').setup()
local hsluv = require("hsluv")

local M = {}

vim.api.nvim_command("hi! clear")

-- Pack
local function p(...)
    return {n = select("#", ...), ...}
end

-- Pale
local function pa(hsl)
    local l = hsl[3] + (100.0 - hsl[3]) * 0.32
    return { hsl[1], hsl[2], l }
end

-- Accentuate
local function a(hsl)
    local s = hsl[2] + 5.0 -- (100.0 - hsl[2]) * 0.4
    local l = hsl[3] + 4.0
    return { hsl[1], s, hsl[3] }
end

-- Dim
local function d(hsl)
    local s = hsl[2] * 0.5
    return { hsl[1], s, hsl[3] }
end

-- Color system suffixes:
-- `p`: pale (higher lightness)
-- `a`: accentuated
-- `d`: dimmed
--
-- Note that colorbuddy.lua sees "background" and "foreground" as special color names.
-- As such, we cannot use those.
local background_ =         p(86,  5.0, 94.0)
local darkbackground =      p(86, 10.0, 90.0)
local verydarkbackground =  p(86, 15.0, 86.0)
local highlightbackground = p(86, 45.0, 82.0)

local foreground_ =      p(281, 10.0, 10.0)
local foreground_a =     a(foreground_)
local foreground_aa =    a(a(foreground_))

local grey =    p(77, 19.0, 33.0)
local grey_d =  p(77, 19.0, 38.0)
local grey_dd = p(77, 19.0, 43.0)
-- local grey_d =  p(77, 21.0, 35.0)
-- local grey_dd = p(77, 23.0, 40.0)

local structural_red =    p( 12, 98.0, 40.0)
local structural_green =  p(124, 98.0, 40.0)
local structural_blue =   p(258, 98.0, 40.0)
local structural_purple = p(286, 98.0, 40.0)

local red =    p( 12, 82.0, 33.0)
local orange = p( 21, 82.0, 33.0)
local blue =   p(231, 82.0, 33.0)
local pink =   p(335, 82.0, 33.0)
local purple = p(286, 82.0, 33.0)
local yellow = p( 77, 82.0, 33.0)
local green =  p(126, 82.0, 33.0)

local red_a =     a(red)
local red_aa =    a(a(red))
local red_aaa =   a(a(a(red)))
local orange_a =  a(orange)
local orange_aa = a(a(orange))
local blue_a =    a(blue)
local blue_aa =   a(a(blue))
local blue_d =    d(blue)
local blue_pdd =  pa(d(d(blue)))
local pink_d =    d(pink)
local purple_a =  a(purple)
local green_a =   a(green)
local green_aa =  a(a(green))

local function hslToString(hsl)
    return hsluv.hsluv_to_hex(hsl)
end

-- Inverts colors for light-on-dark mode.
local function invertHslToString(hsl)
    local l = 100.0 - hsl[3]
    return hsluv.hsluv_to_hex({ hsl[1], hsl[2] * 0.5, l })
end

function M.setup()
    if vim.o.background == "dark" then
        Color.new('background_',         invertHslToString(background_))
        Color.new('darkbackground',      invertHslToString(darkbackground))
        Color.new('verydarkbackground',  invertHslToString(verydarkbackground))
        Color.new('highlightbackground', invertHslToString(highlightbackground))

        Color.new('foreground_',   invertHslToString(foreground_))
        Color.new('foreground_a',  invertHslToString(foreground_a))
        Color.new('foreground_aa', invertHslToString(foreground_aa))
        Color.new('grey',          invertHslToString(grey))
        Color.new('grey_d',        invertHslToString(grey_d))
        Color.new('grey_dd',       invertHslToString(grey_dd))

        Color.new('structural_red',    invertHslToString(structural_red))
        Color.new('structural_green',  invertHslToString(structural_green))
        Color.new('structural_blue',   invertHslToString(structural_blue))
        Color.new('structural_purple', invertHslToString(structural_purple))

        Color.new('red',       invertHslToString(red))
        Color.new('red_a',     invertHslToString(red_a))
        Color.new('red_aa',    invertHslToString(red_aa))
        Color.new('red_aaa',   invertHslToString(red_aaa))
        Color.new('orange',    invertHslToString(orange))
        Color.new('orange_a',  invertHslToString(orange_a))
        Color.new('orange_aa', invertHslToString(orange_aa))
        Color.new('blue',      invertHslToString(blue_a))
        Color.new('blue_a',    invertHslToString(blue_a))
        Color.new('blue_aa',   invertHslToString(blue_aa))
        Color.new('blue_d',    invertHslToString(blue_d))
        Color.new('blue_pdd',  invertHslToString(blue_pdd))
        Color.new('pink',      invertHslToString(pink))
        Color.new('pink_d',    invertHslToString(pink_d))
        Color.new('purple',    invertHslToString(purple))
        Color.new('purple_a',  invertHslToString(purple_a))
        Color.new('yellow',    invertHslToString(yellow))
        Color.new('green',     invertHslToString(green))
        Color.new('green_a',   invertHslToString(green_a))
        Color.new('green_aa',  invertHslToString(green_aa))
    else
        Color.new('background_',         hslToString(background_))
        Color.new('darkbackground',      hslToString(darkbackground))
        Color.new('verydarkbackground',  hslToString(verydarkbackground))
        Color.new('highlightbackground', hslToString(highlightbackground))

        Color.new('foreground_',   hslToString(foreground_))
        Color.new('foreground_a',  hslToString(foreground_a))
        Color.new('foreground_aa', hslToString(foreground_aa))
        Color.new('grey',          hslToString(grey))
        Color.new('grey_d',        hslToString(grey_d))
        Color.new('grey_dd',       hslToString(grey_dd))

        Color.new('structural_red',    hslToString(structural_red))
        Color.new('structural_green',  hslToString(structural_green))
        Color.new('structural_blue',   hslToString(structural_blue))
        Color.new('structural_purple', hslToString(structural_purple))

        Color.new('red',       hslToString(red))
        Color.new('red_a',     hslToString(red_a))
        Color.new('red_aa',    hslToString(red_aa))
        Color.new('red_aaa',   hslToString(red_aaa))
        Color.new('orange',    hslToString(orange))
        Color.new('orange_a',  hslToString(orange_a))
        Color.new('orange_aa', hslToString(orange_aa))
        Color.new('blue',      hslToString(blue))
        Color.new('blue_a',    hslToString(blue_a))
        Color.new('blue_aa',   hslToString(blue_aa))
        Color.new('blue_d',    hslToString(blue_d))
        Color.new('blue_pdd',  hslToString(blue_pdd))
        Color.new('pink',      hslToString(pink))
        Color.new('pink_d',    hslToString(pink_d))
        Color.new('purple',    hslToString(purple))
        Color.new('purple_a',  hslToString(purple_a))
        Color.new('yellow',    hslToString(yellow))
        Color.new('green',     hslToString(green))
        Color.new('green_a',   hslToString(green_a))
        Color.new('green_aa',  hslToString(green_aa))
    end

    Group.new('Normal',      colors.foreground_, colors.background_)
    Group.new('Comment',     colors.grey_dd, nil, styles.italic)
    Group.new('Operator',    colors.grey)
    Group.new('Delimiter',   colors.grey)
    Group.new('MatchParen',  nil, colors.highlightbackground)
    Group.new('Keyword',     colors.purple_a)
    Group.new('Conditional', colors.purple, nil, styles.bold)
    Group.new('Repeat',      groups.Conditional)
    Group.new('Statement',   groups.Conditional)
    Group.new('Variable',    groups.Normal)
    Group.new('Function',    colors.blue_a, nil, nil)
    Group.new('Type',        colors.pink, nil, styles.bold)
    Group.new('Define',      groups.Type)
    Group.new('Include',     colors.pink_d, nil, nil)
    Group.new('Identifier',  colors.blue_d)
    Group.new('Label',       groups.Identifier)
    Group.new('Constant',    colors.blue)
    Group.new('Number',      colors.orange)
    Group.new('Float',       groups.Number)
    Group.new('String',      groups.Constant)
    Group.new('Character',   groups.Constant)
    Group.new('Boolean',     groups.Conditional)
    Group.new('Exception',   colors.red, nil, styles.bold)

    Group.new('Special',   colors.yellow)
    Group.new('PreProc',   colors.yellow)

    Group.new('Error',     colors.red_aa, nil, styles.bold)
    Group.new('ErrorMsg',  groups.Error)
    Group.new('Warning',   colors.orange, nil, styles.bold)
    Group.new('WarningMsg', groups.Warning)

    -- Vim coloring:
    Group.new('Cursor',  colors.background_, colors.blue_d)
    Group.new('iCursor',                     groups.Cursor, groups.Cursor)
    Group.new('vCursor',                     groups.Cursor, groups.Cursor)
    Group.new('cCursor',                     groups.Cursor, groups.Cursor)
    Group.new('iCursor',                     groups.Cursor, groups.Cursor)
    Group.new('TermCursor',                  groups.Cursor, groups.Cursor)
    Group.new('VitalOverCommandLineCursor',  groups.Cursor, groups.Cursor)

    Group.new('Visual',  colors.background_, colors.blue_d)

    Group.new('SpecialKey', colors.blue_a, nil, styles.italic)

    Group.new('CursorColumn', colors.none, colors.highlightbackground)
    Group.new('CursorLine',  groups.CursorColumn)
    Group.new('Warnings', colors.orange, nil, styles.bold)

    Group.new('SignColumn',   colors.grey_d,     colors.darkbackground)
    Group.new('LineNr',       groups.SignColumn, groups.SignColumn)
    Group.new('CursorLineNr', colors.blue,       colors.background_, styles.bold)

    Group.new('FoldColumn',   colors.foreground_, groups.SignColumn)

    Group.new('Folded', colors.foreground_, colors.verydarkbackground)

    Group.new('StatusLine',   colors.background_, colors.blue_d)
    Group.new('StatusLineNC', colors.foreground_, colors.blue_pdd)

    Group.new('VertSplit', colors.highlightbackground, colors.background_)

    Group.new('Search',     colors.foreground_, colors.highlightbackground, styles.bold)
    Group.new('IncSearch',  colors.highlightbackground, colors.foreground_)
    Group.new('Substitute', colors.highlightbackground, colors.foreground_)

    Group.new('Directory', groups.Include)

    Group.new('Title', colors.purple)
    Group.new('Question', colors.green)
    Group.new('MoreMsg', groups.Question)
    Group.new('NonText', colors.red_aa)

    Group.new('Pmenu', colors.foreground_, colors.verydarkbackground)
    Group.new('NormalFloat', colors.foreground_, colors.verydarkbackground)

    -- Some plugin coloring:
    Group.new('TSVariableBuiltin', groups.Constant)

    Group.new("LSPDiagnosticsDefaultHint", groups.Comment)
    Group.new("LSPDiagnosticsDefaultInformation", groups.Normal)
    Group.new("LSPDiagnosticsDefaultWarning", groups.Warning)
    Group.new("LSPDiagnosticsDefaultError", groups.Error)

    Group.new("EasyMotionTarget", colors.red_a, nil, styles.bold)
    Group.new("EasyMotionIncSearch", colors.blue, nil, styles.bold)
    Group.new("EasyMotionShade", colors.grey_dd)
    Group.new("EasyMotionMoveHL", groups.Search, groups.Search, groups.Search)

    Group.new("MinimapBase",      colors.grey_dd)
    Group.new("Minimap", colors.foreground_)

    Group.new("HighlightedyankRegion", nil, colors.highlightbackground)

    Group.new("GitSignsAdd",    colors.structural_green, colors.darkbackground)
    Group.new("GitSignsDelete", colors.structural_red,   colors.darkbackground)
    Group.new("GitSignsChange", colors.structural_blue,  colors.darkbackground)
end

    -- Group.new('Tag',            colors.nord_4,       colors.none,    styles.NONE)
    -- Group.new('Todo',           colors.nord_13,      colors.none,    styles.NONE)

return M

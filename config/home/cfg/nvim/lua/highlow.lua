-- A high foreground-background contrast, low between-keyword contrast colorscheme.

local Color, colors, Group, groups, styles = require('colorbuddy').setup()

local M = {}

vim.api.nvim_command("hi! clear")

-- Pack
local function p(...)
    return {n = select("#", ...), ...}
end

-- Unpack
local function u(packed)
    return unpack(packed)
end

-- Pale
local function pa(h, s, l)
    return h, s, l + (0.91 - l) * 0.6
end

-- Accentuate
local function a(h, s, l)
    return h, s + (1 - s) * 0.4, l
end

-- Dim
local function d(h, s, l)
    return h, s * 0.6, l
end


-- Color system suffixes:
-- `p`: pale (higher lightness)
-- `a`: accentuated (more color saturation)
-- `d`: dimmed (less color saturation)
--
-- Note that colorbuddy.lua sees "background" and "foreground" as special color names.
-- As such, we cannot use those.
local background_ =         p(51 / 360, 0.10, 0.88)
local darkbackground =      p(51 / 360, 0.13, 0.82)
local verydarkbackground =  p(51 / 360, 0.16, 0.76)
local highlightbackground = p(37 / 360, 0.35, 0.74)

local foreground_ =      p(265 / 360, 0.07, 0.200)
local foreground_a =     p(a(u(foreground_)))
local foreground_aa =    p(a(a(u(foreground_))))

local grey =    p(51 / 360, 0.08, 0.310)
local grey_d =  p(51 / 360, 0.10, 0.360)
local grey_dd = p(51 / 360, 0.12, 0.410)

local red =    p(0, 0.6, 0.354)
local red_a =  p(a(u(red)))
local red_aa = p(a(a(u(red))))

local orange = p(14 / 360, 0.6, 0.313)

local blue =     p(198 / 360, 0.6, 0.267)
local blue_a =   p(a(u(blue)))
local blue_aa =  p(a(a(u(blue))))
local blue_d =   p(d(u(blue)))
local blue_pdd = p(pa(d(d(u(blue)))))
-- local blue_pa = p(198 / 360, 0.2, 0.50)
-- local blue_a =  p(198 / 360, 0.9, 0.25)
-- local blue_aa = p(198 / 360, 1.0, 0.35)
-- local blue_d =  p(198 / 360, 0.8, 0.05)
-- local blue_pa = p(198 / 360, 0.2, 0.50)

local pink =    p(322 / 360, 0.6, 0.342)
local pink_d =  p(d(u(pink)))

local purple =   p(278 / 370, 0.6, 0.372)
local purple_a = p(a(u(purple))) -- p(278 / 370, 0.9, 0.25)

local yellow = p(53 / 360, 0.6, 0.217)

local green =   p(114 / 360, 0.6, 0.227)
local green_a = p(a(u(green))) -- p(114 / 360, 0.9, 0.25)

local function rgbFromString(str)
    local r = tonumber(string.sub(str, 2, 3), 16) / 255
    local g = tonumber(string.sub(str, 4, 5), 16) / 255
    local b = tonumber(string.sub(str, 6, 7), 16) / 255
    return r, g, b
end

local function rgbToString(r, g, b)
    return string.format(
        "#%02X%02X%02X",
        math.floor(r * 255 + 0.5),
        math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5)
    )
end

-- Adapted from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
function rgbToHsl(r, g, b)
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    if l > 0.5 then s = d / (2 - max - min) else s = d / (max + min) end
    if max == r then
      h = (g - b) / d
      if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l
end

-- Adapted from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
function hslToRgb(h, s, l)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r, g, b
end

local function invert(str)
    local r, g, b = rgbFromString(str)
    local h, s, l = rgbToHsl(r, g, b)
    r, g, b = hslToRgb(h, s, (1.0 - l) * 0.8 + 0.1)
    return rgbToString(r, g, b)
end

local function hslToString(h, s, l)
    local r, g, b = hslToRgb(h, s, l)
    return rgbToString(r, g, b)
end

-- Inverts colors for light-on-dark mode.
-- Also somewhat reduces the global contrast.
local function invertHslToString(h, s, l)
    return hslToString(h, s * 0.68, (1.0 - l) * 0.92 + 0.04)
end

function M.setup()
    if vim.o.background == "dark" then
        Color.new('background_',         invertHslToString(u(background_)))
        Color.new('darkbackground',      invertHslToString(u(darkbackground)))
        Color.new('verydarkbackground',  invertHslToString(u(verydarkbackground)))
        Color.new('highlightbackground', invertHslToString(u(highlightbackground)))

        Color.new('foreground_',   invertHslToString(u(foreground_)))
        Color.new('foreground_a',  invertHslToString(u(foreground_a)))
        Color.new('foreground_aa', invertHslToString(u(foreground_aa)))
        Color.new('grey',          invertHslToString(u(grey)))
        Color.new('grey_d',        invertHslToString(u(grey_d)))
        Color.new('grey_dd',       invertHslToString(u(grey_dd)))

        Color.new('red',       invertHslToString(u(red)))
        Color.new('red_a',     invertHslToString(u(red_a)))
        Color.new('red_aa',    invertHslToString(u(red_aa)))
        Color.new('orange',    invertHslToString(u(orange)))
        Color.new('blue',      invertHslToString(u(blue_a)))
        Color.new('blue_a',    invertHslToString(u(blue_a)))
        Color.new('blue_aa',   invertHslToString(u(blue_aa)))
        Color.new('blue_d',    invertHslToString(u(blue_d)))
        Color.new('blue_pdd',  invertHslToString(u(blue_pdd)))
        Color.new('pink',      invertHslToString(u(pink)))
        Color.new('pink_d',    invertHslToString(u(pink_d)))
        Color.new('purple',    invertHslToString(u(purple)))
        Color.new('purple_a',  invertHslToString(u(purple_a)))
        Color.new('yellow',    invertHslToString(u(yellow)))
        Color.new('green',     invertHslToString(u(green)))
        Color.new('green_a',   invertHslToString(u(green_a)))
    else
        Color.new('background_',         hslToString(u(background_)))
        Color.new('darkbackground',      hslToString(u(darkbackground)))
        Color.new('verydarkbackground',  hslToString(u(verydarkbackground)))
        Color.new('highlightbackground', hslToString(u(highlightbackground)))

        Color.new('foreground_',   hslToString(u(foreground_)))
        Color.new('foreground_a',  hslToString(u(foreground_a)))
        Color.new('foreground_aa', hslToString(u(foreground_aa)))
        Color.new('grey',          hslToString(u(grey)))
        Color.new('grey_d',        hslToString(u(grey_d)))
        Color.new('grey_dd',       hslToString(u(grey_dd)))

        Color.new('red',       hslToString(u(red)))
        Color.new('red_a',     hslToString(u(red_a)))
        Color.new('red_aa',    hslToString(u(red_aa)))
        Color.new('orange',    hslToString(u(orange)))
        Color.new('blue',      hslToString(u(blue)))
        Color.new('blue_a',    hslToString(u(blue_a)))
        Color.new('blue_aa',   hslToString(u(blue_aa)))
        Color.new('blue_d',    hslToString(u(blue_d)))
        Color.new('blue_pdd',  hslToString(u(blue_pdd)))
        Color.new('pink',      hslToString(u(pink)))
        Color.new('pink_d',    hslToString(u(pink_d)))
        Color.new('purple',    hslToString(u(purple)))
        Color.new('purple_a',  hslToString(u(purple_a)))
        Color.new('yellow',    hslToString(u(yellow)))
        Color.new('green',     hslToString(u(green)))
        Color.new('green_a',   hslToString(u(green_a)))
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
end

    -- Group.new('Tag',            colors.nord_4,       colors.none,    styles.NONE)
    -- Group.new('Todo',           colors.nord_13,      colors.none,    styles.NONE)

return M

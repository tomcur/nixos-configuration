-- A high foreground-background contrast, low between-keyword contrast colorscheme.

local hsluv = require("highlow.hsluv")

local M = {}

--- Darken a color by some amount.
-- @param hsl color to darken
-- @param amount ratio within [0.0, 1.0] by which to darken the color:
-- 0.0 is unchanged, 1.0 is completely dark.
local function darken(hsl, amount)
    local l = hsl[3] * (1.0 - amount)
    return { hsl[1], hsl[2], l }
end

--- Brighten a color by some amount.
-- @param hsl color to brighten
-- @param amount ratio within [0.0, 1.0] by which to lighten the color.
-- 0.0 is unchanged, 1.0 is completely light.
local function brighten(hsl, amount)
    local l = hsl[3] + (100.0 - hsl[3]) * amount
    return { hsl[1], hsl[2], l }
end

--- Desaturate a color by some amount.
-- @param hsl color to desaturate
-- @param amount ratio within [0.0, 1.0] by which to desaturate the color:
-- 0.0 is unchanged, 1.0 is completely desaturated.
local function desaturate(hsl, amount)
    local s = hsl[2] * (1.0 - amount)
    return { hsl[1], s, hsl[3] }
end

--- Saturate a color by some amount.
-- @param hsl color to saturate
-- @param amount ratio within [0.0, 1.0] by which to saturate the color:
-- 0.0 is unchanged, 1.0 is completely saturated.
local function saturate(hsl, amount)
    local s = hsl[2] + (100.0 - hsl[2]) * amount
    return { hsl[1], s, hsl[3] }
end

--- Blend two colors. Moves hsl1 towards hsl2.
-- @param hsl1 base color
-- @param hsl2 color to blend with
-- @param hue_blend ratio within [0.0, 1.0] by which to blend the color hues:
-- 0.0 leaves hsl1 unchanged, 1.0 completely moves to hsl2. The transformation
-- is done in RGB color space, but saturation and lightness as unchanged
-- @param saturation_blend ratio within [0.0, 1.0] by which to blend color
-- saturation. 0.0 leaves hsl1 unchanged, 1.0 completely moves to hsl2's saturation
-- @param lightness_blend same as above but for lightness
local function blend(hsl1, hsl2, hue_blend, saturation_blend, lightness_blend)
    local r1, g1, b1 = unpack(hsluv.hsluv_to_rgb(hsl1))
    local r2, g2, b2 = unpack(hsluv.hsluv_to_rgb(hsl2))

    local hue = hsluv.rgb_to_hsluv({
        r1 + (r2 - r1) * hue_blend,
        g1 + (g2 - g1) * hue_blend,
        b1 + (b2 - b1) * hue_blend,
    })[1]

    local _h1, s1, l1 = unpack(hsl1)
    local _h2, s2, l2 = unpack(hsl2)
    return { 
        hue,
        s1 + (s2 - s1) * saturation_blend, 
        l1 + (l2 - l1) * lightness_blend, 
    }
end

-- Color system suffixes:
-- `p`: paled
-- `a`: accentuated
-- `d`: dimmed

-- Colors are tuples of { hue, saturation, value } in the HSLuv color space.
local colors = {}

colors.bg =         { 57,  7.0, 93.0 }
colors.darkbg =     darken(colors.bg, 0.05)
colors.verydarkbg = darken(colors.bg, 0.10)

colors.highlightbg = { colors.bg[1], 50.0, 82.0 }

colors.fg = { 281, 10.0, 7.0 }
colors.fg_a =  saturate(brighten(colors.fg, 0.1), 0.33)
colors.fg_aa = saturate(brighten(colors.fg, 0.2), 0.66)

colors.grey =    blend(colors.fg, colors.bg, 0.5, 0.2, 0.2)
colors.grey_d =  blend(colors.fg, colors.bg, 0.6, 0.3, 0.4)
colors.grey_dd = blend(colors.fg, colors.bg, 0.7, 0.4, 0.7)


colors.structural_red =    {  12, 98.0, 40.0 }
colors.structural_green =  { 124, 98.0, 40.0 }
colors.structural_blue =   { 258, 98.0, 40.0 }
colors.structural_purple = { 286, 98.0, 40.0 }

local hues = {
    red = 12,
    orange = 21,
    blue = 231,
    pink = 335,
    purple = 286,
    yellow = 77,
    green = 126,
}

for color, hue in pairs(hues) do
    hsl = { hue, 86.0, 29.0 }
    colors[color] = hsl

    colors[color .. "_a"] =   saturate(brighten(hsl, 0.05), 0.3)
    colors[color .. "_aa"] =  saturate(brighten(hsl, 0.1), 0.6)
    colors[color .. "_aaa"] = saturate(brighten(hsl, 0.2), 1.0)

    colors[color .. "_d"] = desaturate(hsl, 0.5)

    colors[color .. "_p"] =  desaturate(blend(hsl, colors.bg, 0.7, 0.0, 0.6), 0.6)
    colors[color .. "_pp"] = desaturate(blend(hsl, colors.bg, 0.9, 0.0, 0.8), 0.8)
end

M.colors = colors

function M.hslToString(hsl)
    return hsluv.hsluv_to_hex(hsl)
end

-- Inverts colors for light-on-dark mode.
function M.invertHslToString(hsl)
    local l = 100.0 - hsl[3]
    return hsluv.hsluv_to_hex({ hsl[1], hsl[2] * 0.5, l })
end

return M

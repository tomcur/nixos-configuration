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

local function modularDistance(a, b, m)
    return math.min((a - b) % m, (b - a) % m)
end

--- Calculate color distance of two hues and saturations
--- (distance is between -1.0 and 1.0).
-- @param hs1 table of { hue, saturation }
-- @param hs2 table of { hue, saturation }
local function colorDistance(hs1, hs2)
    local h1, s1 = unpack(hs1)
    local h2, s2 = unpack(hs2)

    local hueDist = modularDistance(h1, h2, 360) / 180 * 2.0 - 1.0
    local saturationDist = math.abs(s1 - s2) / 100.0
    return hueDist * saturationDist
end

-- Color system suffixes:
-- `p`: paled
-- `a`: accentuated
-- `d`: dimmed

-- Colors are tuples of { hue, saturation, value } in the HSLuv color space.
local colors = {}

colors.bg =         { 62,  41.0, 95.0 }
colors.darkbg =     saturate(darken(colors.bg, 0.04), 0.13)
colors.verydarkbg = saturate(darken(colors.bg, 0.08), 0.26)
colors.visualbg =   { 54, 68.0, 80.0 }

colors.highlightbg = saturate(darken(colors.bg, 0.2), 0.4)

-- colors.fg = { 240, 13.0, 22.0 }
colors.fg = { (colors.bg[1] + 180) % 360, 22.0, 22.0 }
colors.fg_a =  saturate(brighten(colors.fg, 0.033), 0.33)
colors.fg_aa = saturate(brighten(colors.fg, 0.066), 0.66)

colors.grey =    blend(colors.fg, colors.bg, 0.5, 0.2, 0.2)
colors.grey_d =  blend(colors.fg, colors.bg, 0.6, 0.3, 0.4)
colors.grey_dd = blend(colors.fg, colors.bg, 0.7, 0.4, 0.7)


colors.structural_red =    {  12, 98.0, 40.0 }
colors.structural_green =  { 124, 98.0, 40.0 }
colors.structural_blue =   { 258, 98.0, 40.0 }
colors.structural_purple = { 286, 98.0, 40.0 }

local hues = {
    red = 15,
    orange = 31,
    yellow = 77,
    green = 101,
    blue = 257,
    purple = 287,
    pink = 335,
}

for color, hue in pairs(hues) do
    local saturation = 37.0
    local bgDistance = colorDistance(
        { colors.bg[1], colors.bg[2] },
        { hue, saturation }
    )

    hsl = {
        hue,
        saturation,
        37.0 - (bgDistance > 0.0 and 0.0 or 4.0),
    }
    colors[color] = hsl

    colors[color .. "_a"] =   saturate(brighten(hsl, 0.00), 0.40)
    colors[color .. "_aa"] =  saturate(brighten(hsl, 0.04), 0.50)
    colors[color .. "_aaa"] = saturate(brighten(hsl, 0.06), 1.00)

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
    return hsluv.hsluv_to_hex({ hsl[1], hsl[2], l })
end

return M

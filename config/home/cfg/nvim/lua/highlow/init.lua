local colors = require("highlow.colors")
local theme = require("highlow.theme")

local M = {}

local function activate(theme, hexColors)
    vim.api.nvim_command("hi! clear")

    vim.g.colors_name = "highlow"
    vim.o.termguicolors = true

    theme.setupWithColors(hexColors)
end

function M.colorscheme()
    local hexColors = {}

    if vim.o.background == "dark" then
        for color, hsl in pairs(colors.colors) do
            hexColors[color] = colors.invertHslToString(hsl)
        end
    else
        for color, hsl in pairs(colors.colors) do
            hexColors[color] = colors.hslToString(hsl)
        end
    end

    activate(theme, hexColors)
end

return M

--
-- Copyright (c) 2020 Tim Winchester
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local defaults = require("defaults")

local ModeIndicator = {}

local mode_indicator_settings = {}
mode_indicator_settings.pos = {}
mode_indicator_settings.pos.x = 0
mode_indicator_settings.pos.y = windower.get_windower_settings().ui_y_res - 36
mode_indicator_settings.bg = {}
mode_indicator_settings.bg.alpha = 255
mode_indicator_settings.bg.blue = 255
mode_indicator_settings.bg.green = 128
mode_indicator_settings.bg.red = 0
mode_indicator_settings.bg.visible = true
mode_indicator_settings.padding = 2
mode_indicator_settings.text = {}
mode_indicator_settings.text.font = "MS UI Gothic"
mode_indicator_settings.text.size = 12
ModeIndicator.text = require("texts").new(mode_indicator_settings, defaults)

ModeIndicator.activate_kana_mode = (function()
    ModeIndicator.text:text("あ")
    ModeIndicator.text:visible(true)
end)

ModeIndicator.deactivate_kana_mode = (function()
    ModeIndicator.text:text("A")
    ModeIndicator.text:visible(true)
end)

return ModeIndicator
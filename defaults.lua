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

function createDefaults()
    local defaults = {}
    defaults.text = {}
    defaults.text.pos = {}
    defaults.text.pos.x = 18
    defaults.text.pos.y = windower.get_windower_settings().ui_y_res - 36
    defaults.text.bg = {}
    defaults.text.bg.alpha = 255
    defaults.text.bg.blue = 0
    defaults.text.bg.green = 0
    defaults.text.bg.red = 0
    defaults.text.bg.visible = true
    defaults.text.padding = 0
    defaults.text.text = {}
    defaults.text.text.font = "MS UI Gothic"
    defaults.text.text.size = 12
    defaults.visible = true
    defaults.colors = {}
    defaults.colors.bg = {}
    defaults.colors.bg.red = 0
    defaults.colors.bg.green = 0
    defaults.colors.bg.blue = 0
    defaults.colors.bg.alpha = 255
    return defaults
end

return createDefaults()
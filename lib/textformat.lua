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

local res = require("resources")

local textformat = {}

textformat.handle_autotranslates = (function(text)
    local output = text

    local autotranslate_pattern = string.char(0xFD, 0x02, 0x02) .. "(..)" .. string.char(0xFD)
    for match in windower.to_shift_jis(text):gmatch(autotranslate_pattern) do
        local autotranslate_number = match:byte(1) * 256 + match:byte(2)
        local replacement_pattern = windower.from_shift_jis(string.char(0xFD, 0x02, 0x02, match:byte(1), match:byte(2), 0xFD))

        output = output:gsub(replacement_pattern, textformat.make_autotranslate_phrase(autotranslate_number))
    end

    return output
end)

textformat.make_autotranslate_phrase = (function(autotranslate_number)
    local phrase = "autotranslate phrase " .. autotranslate_number
    local entry = res.auto_translates[autotranslate_number]
    if (entry ~= nil) then
        phrase = entry.en
    end
    return " " .. textformat.start_green_text() .. "◀" .. textformat.start_white_text() .. phrase .. textformat.start_red_text() .. "▶" .. textformat.start_white_text()
end)

textformat.start_green_text = (function()
    return "\\cs(0,255,0)"
end)

textformat.start_red_text = (function()
    return "\\cs(255,0,0)"
end)

textformat.start_blue_text = (function()
    return "\\cs(0,128,255)"
end)

textformat.start_white_text = (function()
    return "\\cs(255,255,255)"
end)

return textformat

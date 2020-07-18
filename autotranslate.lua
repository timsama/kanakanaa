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

require("lists")

local strings = require("strings")
local res = require("resources")
local autotranslate_json = res.auto_translates

local autotranslate = {}

autotranslate.lookup = (function(text)
    local autotranslate_words = L{}
    if (#text > 0) then
        for i, entry in pairs(autotranslate_json) do
            if (#autotranslate_words < 20 and string.startswith(entry.en:lower(), text:lower())) then
                autotranslate_words:append(entry)
            end
        end
    end

    return autotranslate_words
end)

autotranslate.to_pending_buffer_format = (function(autotranslate_number)
    local second_byte = autotranslate_number % 256
    local first_byte = math.floor(autotranslate_number / 256)

    local autotranslate_phrase = string.char(0xFD, 0x02, 0x02, first_byte, second_byte, 0xFD)

    return windower.from_shift_jis(autotranslate_phrase)
end)

return autotranslate

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

local utf8slim = {}
require("lists")

local AUTOTRANSLATE_INDICATOR = windower.from_shift_jis(string.char(0xFD))

-- returns the length in bytes needed to hold the character at the given string index
utf8slim.get_char_bytelength = (function(str, index)
    local bytelength = nil

    local byteval = string.byte(str, index or 1)

    if (byteval == nil) then
        return nil
    elseif (byteval == AUTOTRANSLATE_INDICATOR) then
        bytelength = 6
    elseif (byteval < 0x80) then
        bytelength = 1
    elseif (byteval < 0xE0) then
        bytelength = 2
    elseif (byteval < 0xF0) then
        bytelength = 3
    elseif (byteval < 0xF8) then
        bytelength = 4
    elseif (byteval < 0xFC) then
        bytelength = 5
    elseif (byteval < 0xFF) then
        bytelength = 6
    end

    return bytelength
end)

-- if given "abc", it will return {"a", "b", "c"}, but works on kana/kanji too
utf8slim.explode = (function(str)
    local output = L{}
    local start_index = 1
    local end_index = 1

    -- return an empty list if we received an empty string
    if (utf8slim.get_char_bytelength(str, start_index) ~= nil) then
        repeat
            local bytelength = utf8slim.get_char_bytelength(str, start_index)
            end_index = start_index + bytelength - 1
            local char = string.sub(str, start_index, end_index)
            list.append(output, char)
            start_index = end_index + 1
        until (end_index == #str)
    end

    return output
end)

return utf8slim
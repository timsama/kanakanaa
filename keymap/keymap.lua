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

local jsonfiles = require("jsonfiles")
local CONFIG = jsonfiles.read("config/config.json")
local KEYS = require(CONFIG.localefile)

-- DirectInput key codes to romaji characters
local keymap = {}
-- vowels
keymap[KEYS.A] = "a"
keymap[KEYS.I] = "i"
keymap[KEYS.U] = "u"
keymap[KEYS.E] = "e"
keymap[KEYS.O] = "o"
-- consonants
keymap[KEYS.K] = "k"
keymap[KEYS.G] = "g"
keymap[KEYS.S] = "s"
keymap[KEYS.Z] = "z"
keymap[KEYS.T] = "t"
keymap[KEYS.D] = "d"
keymap[KEYS.N] = "n"
keymap[KEYS.H] = "h"
keymap[KEYS.B] = "b"
keymap[KEYS.P] = "p"
keymap[KEYS.M] = "m"
keymap[KEYS.Y] = "y"
keymap[KEYS.R] = "r"
keymap[KEYS.W] = "w"
-- irregular
keymap[KEYS.J] = "j"
keymap[KEYS.C] = "c"
keymap[KEYS.F] = "f"
keymap[KEYS.V] = "v"
-- punctuation
if (not KEYS.PERIOD_NEEDS_SHIFT) then
    keymap[KEYS.PERIOD] = "."
end
if (not KEYS.COMMA_NEEDS_SHIFT) then
    keymap[KEYS.COMMA] = ","
end
if (not KEYS.HYPHEN_NEEDS_SHIFT) then
    keymap[KEYS.HYPHEN] = "-"
end
if (not KEYS.EXCLAMATION_POINT_NEEDS_SHIFT) then
    keymap[KEYS.EXCLAMATION_POINT] = "!"
end
if (not KEYS.SLASH_NEEDS_SHIFT) then
    keymap[KEYS.SLASH] = "/"
end
if (not KEYS.QUESTION_MARK_NEEDS_SHIFT) then
    keymap[KEYS.QUESTION_MARK] = "?"
end
if (not KEYS.DOUBLE_QUOTATION_MARK_NEEDS_SHIFT) then
    keymap[KEYS.DOUBLE_QUOTATION_MARK] = "\""
end
-- special
keymap[KEYS.X] = "x"
-- unused (but we still want to catch their input)
keymap[KEYS.Q] = "" -- Q
keymap[KEYS.L] = "" -- L
-- numbers
keymap[KEYS.ONE] = "1"
keymap[KEYS.TWO] = "2"
keymap[KEYS.THREE] = "3"
keymap[KEYS.FOUR] = "4"
keymap[KEYS.FIVE] = "5"
keymap[KEYS.SIX] = "6"
keymap[KEYS.SEVEN] = "7"
keymap[KEYS.EIGHT] = "8"
keymap[KEYS.NINE] = "9"
keymap[KEYS.ZERO] = "0"

-- Shift-modified DirectInput key codes (the codes don't change, but the characters do)
keymap.shiftmap = {}
if (KEYS.PERIOD_NEEDS_SHIFT) then
    keymap.shiftmap[KEYS.PERIOD] = "."
end
if (KEYS.COMMA_NEEDS_SHIFT) then
    keymap.shiftmap[KEYS.COMMA] = ","
end
if (KEYS.HYPHEN_NEEDS_SHIFT) then
    keymap.shiftmap[KEYS.HYPHEN] = "-"
end
if (KEYS.EXCLAMATION_POINT_NEEDS_SHIFT) then
    keymap.shiftmap[KEYS.EXCLAMATION_POINT] = "!"
end
if (KEYS.SLASH_NEEDS_SHIFT) then
    keymap.shiftmap[KEYS.SLASH] = "/"
end
if (KEYS.QUESTION_MARK_NEEDS_SHIFT) then
    keymap.shiftmap[KEYS.QUESTION_MARK] = "?"
end
if (KEYS.DOUBLE_QUOTATION_MARK_NEEDS_SHIFT) then
    keymap.shiftmap[KEYS.DOUBLE_QUOTATION_MARK] = "\""
end

keymap.get_key = function(keycode, shift_down)
    if (shift_down) then
        return keymap.shiftmap[keycode]
    else
        return keymap[keycode]
    end
end

-- DirectInput key codes
keymap.backspace = KEYS.BACKSPACE
keymap.escape = KEYS.ESCAPE
keymap.enter = KEYS.ENTER
keymap.spacebar = KEYS.SPACEBAR
keymap.tab = KEYS.TAB
keymap.ctrl = KEYS.CTRL
keymap.shift = KEYS.SHIFT
keymap.up_arrow = KEYS.UP_ARROW
keymap.down_arrow = KEYS.DOWN_ARROW
keymap.left_arrow = KEYS.LEFT_ARROW
keymap.right_arrow = KEYS.RIGHT_ARROW
keymap.home = KEYS.HOME
keymap["end"] = KEYS.END -- end is a reserved word in LUA, so we can't use dot notation
keymap.delete = KEYS.DELETE
keymap.panic = KEYS[CONFIG.panickey:upper()]

local fullwidth_letters = {}
fullwidth_letters[KEYS.A] = "Ａ"
fullwidth_letters[KEYS.B] = "Ｂ"
fullwidth_letters[KEYS.C] = "Ｃ"
fullwidth_letters[KEYS.D] = "Ｄ"
fullwidth_letters[KEYS.E] = "Ｅ"
fullwidth_letters[KEYS.F] = "Ｆ"
fullwidth_letters[KEYS.G] = "Ｇ"
fullwidth_letters[KEYS.H] = "Ｈ"
fullwidth_letters[KEYS.I] = "Ｉ"
fullwidth_letters[KEYS.J] = "Ｊ"
fullwidth_letters[KEYS.K] = "Ｋ"
fullwidth_letters[KEYS.L] = "Ｌ"
fullwidth_letters[KEYS.M] = "Ｍ"
fullwidth_letters[KEYS.N] = "Ｎ"
fullwidth_letters[KEYS.O] = "Ｏ"
fullwidth_letters[KEYS.P] = "Ｐ"
fullwidth_letters[KEYS.Q] = "Ｑ"
fullwidth_letters[KEYS.R] = "Ｒ"
fullwidth_letters[KEYS.S] = "Ｓ"
fullwidth_letters[KEYS.T] = "Ｔ"
fullwidth_letters[KEYS.U] = "Ｕ"
fullwidth_letters[KEYS.V] = "Ｖ"
fullwidth_letters[KEYS.W] = "Ｗ"
fullwidth_letters[KEYS.X] = "Ｘ"
fullwidth_letters[KEYS.Y] = "Ｙ"
fullwidth_letters[KEYS.Z] = "Ｚ"

keymap.is_fullwidth_letter = (function(keycode)
    return fullwidth_letters[keycode] ~= nil
end)

keymap.get_fullwidth_letter = (function(keycode)
    return fullwidth_letters[keycode]
end)

local lowercase_letters = {}
lowercase_letters[KEYS.A] = "a"
lowercase_letters[KEYS.B] = "b"
lowercase_letters[KEYS.C] = "c"
lowercase_letters[KEYS.D] = "d"
lowercase_letters[KEYS.E] = "e"
lowercase_letters[KEYS.F] = "f"
lowercase_letters[KEYS.G] = "g"
lowercase_letters[KEYS.H] = "h"
lowercase_letters[KEYS.I] = "i"
lowercase_letters[KEYS.J] = "j"
lowercase_letters[KEYS.K] = "k"
lowercase_letters[KEYS.L] = "l"
lowercase_letters[KEYS.M] = "m"
lowercase_letters[KEYS.N] = "n"
lowercase_letters[KEYS.O] = "o"
lowercase_letters[KEYS.P] = "p"
lowercase_letters[KEYS.Q] = "q"
lowercase_letters[KEYS.R] = "r"
lowercase_letters[KEYS.S] = "s"
lowercase_letters[KEYS.T] = "t"
lowercase_letters[KEYS.U] = "u"
lowercase_letters[KEYS.V] = "v"
lowercase_letters[KEYS.W] = "w"
lowercase_letters[KEYS.X] = "x"
lowercase_letters[KEYS.Y] = "y"
lowercase_letters[KEYS.Z] = "z"

local uppercase_letters = {}
uppercase_letters[KEYS.A] = "A"
uppercase_letters[KEYS.B] = "B"
uppercase_letters[KEYS.C] = "C"
uppercase_letters[KEYS.D] = "D"
uppercase_letters[KEYS.E] = "E"
uppercase_letters[KEYS.F] = "F"
uppercase_letters[KEYS.G] = "G"
uppercase_letters[KEYS.H] = "H"
uppercase_letters[KEYS.I] = "I"
uppercase_letters[KEYS.J] = "J"
uppercase_letters[KEYS.K] = "K"
uppercase_letters[KEYS.L] = "L"
uppercase_letters[KEYS.M] = "M"
uppercase_letters[KEYS.N] = "N"
uppercase_letters[KEYS.O] = "O"
uppercase_letters[KEYS.P] = "P"
uppercase_letters[KEYS.Q] = "Q"
uppercase_letters[KEYS.R] = "R"
uppercase_letters[KEYS.S] = "S"
uppercase_letters[KEYS.T] = "T"
uppercase_letters[KEYS.U] = "U"
uppercase_letters[KEYS.V] = "V"
uppercase_letters[KEYS.W] = "W"
uppercase_letters[KEYS.X] = "X"
uppercase_letters[KEYS.Y] = "Y"
uppercase_letters[KEYS.Z] = "Z"

keymap.is_letter = (function(keycode)
    return lowercase_letters[keycode] ~= nil
end)

keymap.get_letter = (function(keycode, is_shifted)
    if (is_shifted) then
        return uppercase_letters[keycode]
    else
        return lowercase_letters[keycode]
    end
end)

local numbers = {}
numbers[KEYS.ONE] = "1"
numbers[KEYS.TWO] = "2"
numbers[KEYS.THREE] = "3"
numbers[KEYS.FOUR] = "4"
numbers[KEYS.FIVE] = "5"
numbers[KEYS.SIX] = "6"
numbers[KEYS.SEVEN] = "7"
numbers[KEYS.EIGHT] = "8"
numbers[KEYS.NINE] = "9"
numbers[KEYS.ZERO] = "0"

keymap.is_number = (function(keycode)
    return numbers[keycode] ~= nil
end)

keymap.get_number = (function(keycode)
    return numbers[keycode]
end)

local autotranslate_punctuation = {}
autotranslate_punctuation.shiftmap = {}

if (not KEYS.SINGLE_QUOTATION_MARK_NEEDS_SHIFT) then
    autotranslate_punctuation[KEYS.SINGLE_QUOTATION_MARK] = "'"
else
    autotranslate_punctuation.shiftmap[KEYS.SINGLE_QUOTATION_MARK] = "'"
end


keymap.is_autotranslate_punctuation = (function(keycode, shift_down)
    if (shift_down) then
        return autotranslate_punctuation.shiftmap[keycode] ~= nil
    else
        return autotranslate_punctuation[keycode] ~= nil
    end
end)

keymap.get_autotranslate_punctuation = (function(keycode, shift_down)
    if (shift_down) then
        return autotranslate_punctuation.shiftmap[keycode]
    else
        return autotranslate_punctuation[keycode]
    end
end)

return keymap
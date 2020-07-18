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

local hiragana = {}
-- vowels
hiragana["a"] = "あ"
hiragana["i"] = "い"
hiragana["u"] = "う"
hiragana["e"] = "え"
hiragana["o"] = "お"
-- small vowels
hiragana["xa"] = "ぁ"
hiragana["xi"] = "ぃ"
hiragana["xu"] = "ぅ"
hiragana["xe"] = "ぇ"
hiragana["xo"] = "ぉ"
hiragana["xya"] = "ゃ"
hiragana["xyu"] = "ゅ"
hiragana["xyo"] = "ょ"
-- small tsu
hiragana["xtsu"] = "っ"
hiragana["xtu"] = "っ"
-- extender
hiragana["-"] = "ー"
-- consonants
hiragana["ka"] = "か"
hiragana["ki"] = "き"
hiragana["kya"] = "きゃ"
hiragana["kyu"] = "きゅ"
hiragana["kyo"] = "きょ"
hiragana["ku"] = "く"
hiragana["ke"] = "け"
hiragana["ko"] = "こ"
hiragana["ga"] = "が"
hiragana["gi"] = "ぎ"
hiragana["gya"] = "ぎゃ"
hiragana["gyu"] = "ぎゅ"
hiragana["gyo"] = "ぎょ"
hiragana["gu"] = "ぐ"
hiragana["ge"] = "げ"
hiragana["go"] = "ご"
hiragana["sa"] = "さ"
hiragana["si"] = "し"
hiragana["sya"] = "しゃ"
hiragana["syu"] = "しゅ"
hiragana["syo"] = "しょ"
hiragana["shi"] = "し"
hiragana["shya"] = "しゃ"
hiragana["shyu"] = "しゅ"
hiragana["shyo"] = "しょ"
hiragana["sha"] = "しゃ"
hiragana["shu"] = "しゅ"
hiragana["sho"] = "しょ"
hiragana["su"] = "す"
hiragana["se"] = "せ"
hiragana["so"] = "そ"
hiragana["za"] = "ざ"
hiragana["zi"] = "じ"
hiragana["zya"] = "じゃ"
hiragana["zyu"] = "じゅ"
hiragana["zyo"] = "じょ"
hiragana["ji"] = "じ"
hiragana["jya"] = "じゃ"
hiragana["jyu"] = "じゅ"
hiragana["jyo"] = "じょ"
hiragana["ja"] = "じゃ"
hiragana["ju"] = "じゅ"
hiragana["jo"] = "じょ"
hiragana["zu"] = "ず"
hiragana["ze"] = "ぜ"
hiragana["zo"] = "ぞ"
hiragana["ta"] = "た"
hiragana["ti"] = "ち"
hiragana["tya"] = "ちゃ"
hiragana["tyu"] = "ちゅ"
hiragana["tyo"] = "ちょ"
hiragana["chi"] = "ち"
hiragana["cha"] = "ちゃ"
hiragana["chu"] = "ちゅ"
hiragana["che"] = "ちぇ"
hiragana["cho"] = "ちょ"
hiragana["tu"] = "つ"
hiragana["tsu"] = "つ"
hiragana["te"] = "て"
hiragana["to"] = "と"
hiragana["da"] = "だ"
hiragana["di"] = "ぢ"
hiragana["dya"] = "ぢゃ"
hiragana["dyu"] = "ぢゅ"
hiragana["dyo"] = "ぢょ"
hiragana["dji"] = "ぢ"
hiragana["dja"] = "ぢゃ"
hiragana["dju"] = "ぢゅ"
hiragana["djo"] = "ぢょ"
hiragana["du"] = "づ"
hiragana["dzu"] = "づ"
hiragana["de"] = "で"
hiragana["do"] = "ど"
hiragana["na"] = "な" 
hiragana["ni"] = "に"
hiragana["nya"] = "にゃ"
hiragana["nyu"] = "にゅ"
hiragana["nyo"] = "にょ"
hiragana["nu"] = "ぬ"
hiragana["ne"] = "ね"
hiragana["no"] = "の"
hiragana["ha"] = "は"
hiragana["hi"] = "ひ"
hiragana["hya"] = "ひゃ"
hiragana["hyu"] = "ひゅ"
hiragana["hyo"] = "ひょ"
hiragana["hu"] = "ふ"
hiragana["fu"] = "ふ"
hiragana["he"] = "へ"
hiragana["ho"] = "ほ"
hiragana["ba"] = "ば"
hiragana["bi"] = "び"
hiragana["bya"] = "びゃ"
hiragana["byu"] = "びゅ"
hiragana["byo"] = "びょ"
hiragana["bu"] = "ぶ"
hiragana["be"] = "べ"
hiragana["bo"] = "ぼ"
hiragana["pa"] = "ぱ"
hiragana["pi"] = "ぴ"
hiragana["pya"] = "ぴゃ"
hiragana["pyu"] = "ぴゅ"
hiragana["pyo"] = "ぴょ"
hiragana["pu"] = "ぷ"
hiragana["pe"] = "ぺ"
hiragana["po"] = "ぽ"
hiragana["ma"] = "ま"
hiragana["mi"] = "み"
hiragana["mya"] = "みゃ"
hiragana["myu"] = "みゅ"
hiragana["myo"] = "みょ"
hiragana["mu"] = "む"
hiragana["me"] = "め"
hiragana["mo"] = "も"
hiragana["ya"] = "や"
hiragana["yu"] = "ゆ"
hiragana["yo"] = "よ"
hiragana["ra"] = "ら"
hiragana["ri"] = "り"
hiragana["rya"] = "りゃ"
hiragana["ryu"] = "りゅ"
hiragana["ryo"] = "りょ"
hiragana["ru"] = "る"
hiragana["re"] = "れ"
hiragana["ro"] = "ろ"
hiragana["wa"] = "わ"
hiragana["wo"] = "を"
hiragana["nn"] = "ん"
-- irregular or modified
hiragana["vu"] = "ゔ"

-- numbers
hiragana["1"] = "1"
hiragana["2"] = "2"
hiragana["3"] = "3"
hiragana["4"] = "4"
hiragana["5"] = "5"
hiragana["6"] = "6"
hiragana["7"] = "7"
hiragana["8"] = "8"
hiragana["9"] = "9"
hiragana["0"] = "0"

-- punctuation
hiragana["."] = "。"
hiragana[","] = "、"
hiragana["?"] = "?"
hiragana["!"] = "!"
hiragana["\""] = "\"" -- this has to be handled in a context-aware function

hiragana.from_romaji = (function(romaji_buffer)
    local output = ""
    if (romaji_buffer ~= nil) then
        for i, character in ipairs(romaji_buffer) do
            local hiragana_character = hiragana[character]
            if (hiragana_character ~= nil) then
                output = output .. hiragana_character
            else
                output = output .. character
            end
        end
    end
    return output
end)

local compound_characters = {}
compound_characters["kya"] = L{"ki", "xya"}
compound_characters["kyu"] = L{"ki" , "xyu"}
compound_characters["kyo"] = L{"ki" , "xyo"}
compound_characters["gya"] = L{"gi" , "xya"}
compound_characters["gyu"] = L{"gi" , "xyu"}
compound_characters["gyo"] = L{"gi" , "xyo"}
compound_characters["sya"] = L{"si" , "xya"}
compound_characters["syu"] = L{"si" , "xyu"}
compound_characters["syo"] = L{"si" , "xyo"}
compound_characters["shya"] = L{"shi" , "xya"}
compound_characters["shyu"] = L{"shi" , "xyu"}
compound_characters["shyo"] = L{"shi" , "xyo"}
compound_characters["sha"] = L{"shi" , "xya"}
compound_characters["shu"] = L{"shi" , "xyu"}
compound_characters["sho"] = L{"shi" , "xyo"}
compound_characters["zya"] = L{"zi" , "xya"}
compound_characters["zyu"] = L{"zi" , "xyu"}
compound_characters["zyo"] = L{"zi" , "xyo"}
compound_characters["jya"] = L{"ji" , "xya"}
compound_characters["jyu"] = L{"ji" , "xyu"}
compound_characters["jyo"] = L{"ji" , "xyo"}
compound_characters["ja"] =  L{"ji", "xya"}
compound_characters["ju"] =  L{"ji", "xyu"}
compound_characters["jo"] =  L{"ji", "xyo"}
compound_characters["tya"] = L{"ti" , "xya"}
compound_characters["tyu"] = L{"ti" , "xyu"}
compound_characters["tyo"] = L{"ti" , "xyo"}
compound_characters["cha"] = L{"chi" , "xya"}
compound_characters["chu"] = L{"chi" , "xyu"}
compound_characters["che"] = L{"chi" , "xye"}
compound_characters["cho"] = L{"chi" , "xyo"}
compound_characters["dya"] = L{"di" , "xya"}
compound_characters["dyu"] = L{"di" , "xyu"}
compound_characters["dyo"] = L{"di" , "xyo"}
compound_characters["dja"] = L{"di" , "xya"}
compound_characters["dju"] = L{"di" , "xyu"}
compound_characters["djo"] = L{"di" , "xyo"}
compound_characters["nya"] = L{"ni" , "xya"}
compound_characters["nyu"] = L{"ni" , "xyu"}
compound_characters["nyo"] = L{"ni" , "xyo"}
compound_characters["hya"] = L{"hi" , "xya"}
compound_characters["hyu"] = L{"hi" , "xyu"}
compound_characters["hyo"] = L{"hi" , "xyo"}
compound_characters["bya"] = L{"bi" , "xya"}
compound_characters["byu"] = L{"bi" , "xyu"}
compound_characters["byo"] = L{"bi" , "xyo"}
compound_characters["pya"] = L{"pi" , "xya"}
compound_characters["pyu"] = L{"pi" , "xyu"}
compound_characters["pyo"] = L{"pi" , "xyo"}
compound_characters["mya"] = L{"mi" , "xya"}
compound_characters["myu"] = L{"mi" , "xyu"}
compound_characters["myo"] = L{"mi" , "xyo"}
compound_characters["rya"] = L{"ri" , "xya"}
compound_characters["ryu"] = L{"ri" , "xyu"}
compound_characters["ryo"] = L{"ri" , "xyo"}

hiragana.maybe_split_compound_character = (function(keystroke_buffer)
    if (compound_characters[keystroke_buffer] ~= nil) then
        return compound_characters[keystroke_buffer]
    else
        return L{keystroke_buffer}
    end
end)

return hiragana
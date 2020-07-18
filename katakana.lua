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

local katakana = {}
-- vowels
katakana["a"] = "ア"
katakana["i"] = "イ"
katakana["u"] = "ウ"
katakana["e"] = "エ"
katakana["o"] = "オ"
-- small vowels
katakana["xa"] = "ァ"
katakana["xi"] = "ィ"
katakana["xu"] = "ゥ"
katakana["xe"] = "ェ"
katakana["xo"] = "ォ"
-- small tsu
katakana["xtsu"] = "ッ"
katakana["xtu"] = "ッ"
-- extender
katakana["-"] = "ー"
-- consonants
katakana["ka"] = "カ"
katakana["ki"] = "キ"
katakana["kya"] = "キャ"
katakana["kyu"] = "キュ"
katakana["kyo"] = "キョ"
katakana["ku"] = "ク"
katakana["ke"] = "ケ"
katakana["ko"] = "コ"
katakana["ga"] = "ガ"
katakana["gi"] = "ギ"
katakana["gya"] = "ギャ"
katakana["gyu"] = "ギュ"
katakana["gyo"] = "ギョ"
katakana["gu"] = "グ"
katakana["ge"] = "ゲ"
katakana["go"] = "ゴ"
katakana["sa"] = "サ"
katakana["si"] = "シ"
katakana["sya"] = "シャ"
katakana["syu"] = "シュ"
katakana["syo"] = "ショ"
katakana["shi"] = "シ"
katakana["shya"] = "シャ"
katakana["shyu"] = "シュ"
katakana["shyo"] = "ショ"
katakana["sha"] = "シャ"
katakana["shu"] = "シュ"
katakana["sho"] = "ショ"
katakana["su"] = "ス"
katakana["se"] = "セ"
katakana["so"] = "ソ"
katakana["za"] = "ザ"
katakana["zi"] = "ジ"
katakana["zya"] = "ジャ"
katakana["zyu"] = "ジュ"
katakana["zyo"] = "ジョ"
katakana["ji"] = "ジ"
katakana["jya"] = "ジャ"
katakana["jyu"] = "ジュ"
katakana["jyo"] = "ジョ"
katakana["ja"] = "ジャ"
katakana["ju"] = "ジュ"
katakana["jo"] = "ジョ"
katakana["ja"] = "ジャ"
katakana["ju"] = "ジュ"
katakana["jo"] = "ジョ"
katakana["zu"] = "ズ"
katakana["ze"] = "ゼ"
katakana["zo"] = "ゾ"
katakana["ta"] = "タ"
katakana["ti"] = "チ"
katakana["tya"] = "チャ"
katakana["tyu"] = "チュ"
katakana["tyo"] = "チョ"
katakana["chi"] = "チ"
katakana["cha"] = "チャ"
katakana["chu"] = "チュ"
katakana["che"] = "チェ"
katakana["cho"] = "チョ"
katakana["tu"] = "ツ"
katakana["tsu"] = "ツ"
katakana["te"] = "テ"
katakana["to"] = "ト"
katakana["da"] = "ダ"
katakana["di"] = "ヂ"
katakana["dya"] = "ヂャ"
katakana["dyu"] = "ヂュ"
katakana["dyo"] = "ヂョ"
katakana["dji"] = "ヂ"
katakana["dja"] = "ヂャ"
katakana["dju"] = "ヂュ"
katakana["djo"] = "ヂョ"
katakana["du"] = "ヅ"
katakana["dzu"] = "ヅ"
katakana["de"] = "デ"
katakana["do"] = "ド"
katakana["na"] = "ナ"
katakana["ni"] = "ニ"
katakana["nya"] = "ニャ"
katakana["nyu"] = "ニュ"
katakana["nyo"] = "ニョ"
katakana["nu"] = "ヌ"
katakana["ne"] = "ネ"
katakana["no"] = "ノ"
katakana["ha"] = "ハ"
katakana["hi"] = "ヒ"
katakana["hya"] = "ヒャ"
katakana["hyu"] = "ヒュ"
katakana["hyo"] = "ヒョ"
katakana["hu"] = "フ"
katakana["fu"] = "フ"
katakana["fa"] = "ファ"
katakana["fi"] = "フィ"
katakana["fe"] = "フェ"
katakana["fo"] = "フォ"
katakana["he"] = "ヘ"
katakana["ho"] = "ホ"
katakana["ba"] = "バ"
katakana["bi"] = "ビ"
katakana["bya"] = "ビャ"
katakana["byu"] = "ビュ"
katakana["byo"] = "ビョ"
katakana["bu"] = "ブ"
katakana["be"] = "ベ"
katakana["bo"] = "ボ"
katakana["pa"] = "パ"
katakana["pi"] = "ピ"
katakana["pya"] = "ピャ"
katakana["pyu"] = "ピュ"
katakana["pyo"] = "ピョ"
katakana["pu"] = "プ"
katakana["pe"] = "ペ"
katakana["po"] = "ポ"
katakana["ma"] = "マ"
katakana["mi"] = "ミ"
katakana["mya"] = "ミャ"
katakana["myu"] = "ミュ"
katakana["myo"] = "ミョ"
katakana["mu"] = "ム"
katakana["me"] = "メ"
katakana["mo"] = "モ"
katakana["ya"] = "ヤ"
katakana["yu"] = "ユ"
katakana["yo"] = "ヨ"
katakana["ra"] = "ラ"
katakana["ri"] = "リ"
katakana["rya"] = "リャ"
katakana["ryu"] = "リュ"
katakana["ryo"] = "リョ"
katakana["ru"] = "ル"
katakana["re"] = "レ"
katakana["ro"] = "ロ"
katakana["wa"] = "ワ"
katakana["wo"] = "ヲ"
katakana["nn"] = "ン"
-- irregular or modified
katakana["vu"] = "ヴ"

-- numbers
katakana["1"] = "1"
katakana["2"] = "2"
katakana["3"] = "3"
katakana["4"] = "4"
katakana["5"] = "5"
katakana["6"] = "6"
katakana["7"] = "7"
katakana["8"] = "8"
katakana["9"] = "9"
katakana["0"] = "0"

-- punctuation
katakana["."] = "。"
katakana[","] = "、"
katakana["?"] = "?"
katakana["!"] = "!"
katakana["\""] = "\"" -- this has to be handled in a context-aware function

katakana.maybe_change_to_extender = (function(kana, prev_kana)
    if (kana == "ア") then
        -- "aa" case
        if (prev_kana == "カ" or prev_kana == "キャ" or prev_kana == "ガ"or
            prev_kana == "ギャ" or prev_kana == "サ" or prev_kana == "シャ" or
            prev_kana == "ザ" or prev_kana == "ジャ" or prev_kana == "タ" or
            prev_kana == "チャ" or prev_kana == "ダ" or prev_kana == "ヂャ" or
            prev_kana == "ナ" or prev_kana == "ニャ" or prev_kana == "ハ" or
            prev_kana == "ヒャ" or prev_kana == "ファ" or prev_kana == "バ" or
            prev_kana == "ビャ" or prev_kana == "パ" or prev_kana == "ピャ" or
            prev_kana == "マ" or prev_kana == "ミャ" or prev_kana == "ヤ" or
            prev_kana == "ラ" or prev_kana == "リャ") then
            return "ー"
        end
    elseif (kana == "イ") then
        -- "ii" case
        if (prev_kana == "キ" or prev_kana == "ギ" or prev_kana == "シ" or
            prev_kana == "ジ" or prev_kana == "チ" or prev_kana == "ヂ" or
            prev_kana == "ニ" or prev_kana == "ヒ" or prev_kana == "フィ" or
            prev_kana == "ビ" or prev_kana == "ピ" or prev_kana == "ミ" or
            prev_kana == "リ") then
            return "ー"
        end
        -- "ei" case
        if (prev_kana == "ケ" or prev_kana == "ゲ" or prev_kana == "セ" or
            prev_kana == "ゼ" or prev_kana == "チェ" or prev_kana == "テ" or
            prev_kana == "デ" or prev_kana == "ネ" or prev_kana == "フェ" or
            prev_kana == "ヘ" or prev_kana == "ベ" or prev_kana == "ペ" or
            prev_kana == "メ" or prev_kana == "レ") then
            return "ー"
        end
    elseif (kana == "ウ") then
        -- "uu" case
        if (prev_kana == "キュ" or prev_kana == "ク" or prev_kana == "ギュ" or
            prev_kana == "グ" or prev_kana == "シュ" or prev_kana == "ス" or
            prev_kana == "ジュ" or prev_kana == "ズ" or prev_kana == "チュ" or
            prev_kana == "ツ" or prev_kana == "ヂュ" or prev_kana == "ヅ" or
            prev_kana == "ニュ" or prev_kana == "ヌ" or prev_kana == "ヒュ" or
            prev_kana == "フ" or prev_kana == "ビュ" or prev_kana == "ブ" or
            prev_kana == "ピュ" or prev_kana == "プ" or prev_kana == "ミュ" or
            prev_kana == "ム" or prev_kana == "ユ" or prev_kana == "リュ" or
            prev_kana == "ル") then
            return "ー"
        end
        -- "ou" case
        if (prev_kana == "キョ" or prev_kana == "コ" or prev_kana == "ギョ" or
            prev_kana == "ゴ" or prev_kana == "ショ" or prev_kana == "ソ" or
            prev_kana == "ジョ" or prev_kana == "ゾ" or prev_kana == "チョ" or
            prev_kana == "ト" or prev_kana == "ヂョ" or prev_kana == "ド" or 
            prev_kana == "ニョ" or prev_kana == "ノ" or prev_kana == "ヒョ" or
            prev_kana == "フォ" or prev_kana == "ホ" or prev_kana == "ビョ" or
            prev_kana == "ボ" or prev_kana == "ピョ" or prev_kana == "ポ" or
            prev_kana == "ミョ" or prev_kana == "モ" or prev_kana == "ヨ" or
            prev_kana == "リョ" or prev_kana == "ロ" or prev_kana == "ヲ") then
            return "ー"
        end
    end

    return kana
end)

katakana.from_romaji = (function(romaji_buffer)
    local output = ""
    local prev_kana = ""
    if (romaji_buffer ~= nil) then
        for i, character in ipairs(romaji_buffer) do
            local katakana_character = katakana.maybe_change_to_extender(katakana[character], prev_kana)
            if (katakana_character ~= nil) then
                output = output .. katakana_character
            else
                output = output .. character
            end
            prev_kana = katakana_character
        end
    end
    return output
end)

return katakana
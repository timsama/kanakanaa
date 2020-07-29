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

require("tables")
require("lists")

local strings = require("strings")
local JSON = require("jsonfiles")

local kanji_json = JSON.read("dict/kanji.json")

local kanji = {}

local KANJI_LIST_LIMIT = 30

kanji.lookup_by_reading = (function(kana)
    if (#kana > 0 and kanji_json ~= nil) then
        local kanji_words = L{}
        local kana_words = L{}

        for i=1,#kanji_json do
            local entry = kanji_json[i]
            if (#kanji_words < KANJI_LIST_LIMIT) then
                local is_typing = string.startswith(entry.kana, kana)
                local has_typed = kanji.is_valid_conjugation(kana, entry)
                if (is_typing or has_typed) then
                    if (#entry.kanji > 0) then
                        for j=1,#entry.kanji do
                            if (#kanji_words < KANJI_LIST_LIMIT) then
                                local kanji_word = {}
                                if (string.match(kana, entry.kana)) then
                                    kanji_word.text = string.gsub(kana, entry.kana, entry.kanji[j], 1)
                                else
                                    kanji_word.text = entry.kanji[j]
                                end

                                kanji_word.parts_of_speech = {}
                                for k, pos in ipairs(entry.pos) do
                                    kanji_word.parts_of_speech[pos] = true
                                end

                                kanji_words:append(kanji_word)
                            end
                        end
                    elseif (is_typing and not has_typed and #kana_words < 5) then
                        local kana_word = {}
                        kana_word.text = entry.kana

                        kana_word.parts_of_speech = {}
                        for k, pos in ipairs(entry.pos) do
                            kana_word.parts_of_speech[pos] = true
                        end

                        kana_words:append(kana_word)
                    end
                end
            end
        end

        return kana_words, kanji_words
    else
        return L{}, L{}
    end
end)

local ichidan_conjugations_plain = {
    "る",
    "ない",
    "よう",
    "ないだろう",
    "ろ",
    "るな",
    "た",
    "なかった",
    "たろう",
    "ただろう",
    "なかっただろう",
    "て",
    "ている",
    "ていた",
    "れば",
    "なければ",
    "たら",
    "なかったら",
    "られる",
    "られない",
    "られた",
    "られなかった",
    "させる",
    "させない",
    "させた",
    "させなかった",
    "たい",
    "たくない",
    "たかった",
    "たくなかった",
}

local ichidan_conjugations_polite = {
    "ます",
    "ません",
    "ましょう",
    "るでしょう",
    "ないでしょう",
    "てください",
    "ないでください",
    "ました",
    "ませんでした",
    "たでしょう",
    "なかったでしょう",
    "ています",
    "ていません",
    "ていました",
    "ていませんでした",
    "ましたら",
    "ませんでしたら",
    "られます",
    "られません",
    "られました",
    "られませんでした",
    "させます",
    "させません",
    "させました",
    "させませんでした",
}

local ichidan_kureru_special_conjugations_plain = {
    "る",
    "ない",
    "よう",
    "ないだろう",
    "",
    "るな",
    "た",
    "なかった",
    "たろう",
    "ただろう",
    "なかっただろう",
    "て",
    "ている",
    "ていた",
    "れば",
    "なければ",
    "たら",
    "なかったら",
    "られる",
    "られない",
    "られた",
    "られなかった",
    "させる",
    "させない",
    "させた",
    "させなかった",
    "たい",
    "たくない",
    "たかった",
    "たくなかった",
}

local godan_mu_conjugations_plain = {
    "む",
    "まない",
    "もう",
    "まないだろう",
    "め",
    "むな",
    "んだ",
    "まなかった",
    "んだろう",
    "んだだろう",
    "まなかっただろう",
    "んで",
    "んでいる",
    "んでいた",
    "めま",
    "まなけれま",
    "んだら",
    "まなかったら",
    "める",
    "めない",
    "めた",
    "めなかった",
    "ませる",
    "ませない",
    "ませた",
    "ませなかった",
    "まれる",
    "まれない",
    "まれた",
    "まれなかった",
    "みたい",
    "みたくない",
    "みたかった",
    "みたくなかった",
}

local godan_mu_conjugations_polite = {
    "みます",
    "みません",
    "みましょう",
    "むでしょう",
    "まないでしょう",
    "んでください",
    "まないでください",
    "みました",
    "みませんでした",
    "んだでしょう",
    "まなかったでしょう",
    "んでいます",
    "んでいません",
    "んでいました",
    "んでいませんでした",
    "みましたら",
    "みませんでしたら",
    "めます",
    "めません",
    "めました",
    "めませんでした",
    "ませます",
    "ませません",
    "ませました",
    "ませませんでした",
    "まれます",
    "まれません",
    "まれました",
    "まれませんでした",
}

local godan_nu_conjugations_plain = {
    "ぬ",
    "なない",
    "のう",
    "なないだろう",
    "ね",
    "ぬな",
    "んだ",
    "ななかった",
    "んだろう",
    "んだだろう",
    "ななかっただろう",
    "んで",
    "んでいる",
    "んでいた",
    "ねな",
    "ななけれな",
    "んだら",
    "ななかったら",
    "ねる",
    "ねない",
    "ねた",
    "ねなかった",
    "なせる",
    "なせない",
    "なせた",
    "なせなかった",
    "なれる",
    "なれない",
    "なれた",
    "なれなかった",
    "にたい",
    "にたくない",
    "にたかった",
    "にたくなかった",
}

local godan_nu_conjugations_polite = {
    "にます",
    "にません",
    "にましょう",
    "ぬでしょう",
    "なないでしょう",
    "んでください",
    "なないでください",
    "にました",
    "にませんでした",
    "んだでしょう",
    "ななかったでしょう",
    "んでいます",
    "んでいません",
    "んでいました",
    "んでいませんでした",
    "にましたら",
    "にませんでしたら",
    "ねます",
    "ねません",
    "ねました",
    "ねませんでした",
    "なせます",
    "なせません",
    "なせました",
    "なせませんでした",
    "なれます",
    "なれません",
    "なれました",
    "なれませんでした",
}

local godan_bu_conjugations_plain = {
    "ぶ",
    "ばない",
    "ぼう",
    "ばないだろう",
    "べ",
    "ぶな",
    "んだ",
    "ばなかった",
    "んだろう",
    "んだだろう",
    "ばなかっただろう",
    "んで",
    "んでいる",
    "んでいた",
    "べば",
    "ばなければ",
    "んだら",
    "ばなかったら",
    "べる",
    "べない",
    "べた",
    "べなかった",
    "ばせる",
    "ばせない",
    "ばせた",
    "ばせなかった",
    "ばれる",
    "ばれない",
    "ばれた",
    "ばれなかった",
    "びたい",
    "びたくない",
    "びたかった",
    "びたくなかった",
}

local godan_bu_conjugations_polite = {
    "びます",
    "びません",
    "びましょう",
    "ぶでしょう",
    "ばないでしょう",
    "んでください",
    "ばないでください",
    "びました",
    "びませんでした",
    "んだでしょう",
    "ばなかったでしょう",
    "んでいます",
    "んでいません",
    "んでいました",
    "んでいませんでした",
    "びましたら",
    "びませんでしたら",
    "べます",
    "べません",
    "べました",
    "べませんでした",
    "ばせます",
    "ばせません",
    "ばせました",
    "ばせませんでした",
    "ばれます",
    "ばれません",
    "ばれました",
    "ばれませんでした",
}

local godan_u_conjugations_plain = {
    "う",
    "わない",
    "おう",
    "わないだろう",
    "え",
    "うな",
    "った",
    "わなかった",
    "ったろう",
    "っただろう",
    "わなかっただろう",
    "って",
    "っている",
    "っていた",
    "えば",
    "わなければ",
    "ったら",
    "わなかったら",
    "える",
    "えない",
    "えた",
    "えなかった",
    "わせる",
    "わせない",
    "わせた",
    "わせなかった",
    "われる",
    "われない",
    "われた",
    "われなかった",
    "いたい",
    "いたくない",
    "いたかった",
    "いたくなかった",
}

local godan_u_conjugations_polite = {
    "います",
    "いません",
    "いましょう",
    "うでしょう",
    "わないでしょう",
    "ってください",
    "わないでください",
    "いました",
    "いませんでした",
    "ったでしょう",
    "わなかったでしょう",
    "っています",
    "っていません",
    "っていました",
    "っていませんでした",
    "いましたら",
    "いませんでしたら",
    "えます",
    "えません",
    "えました",
    "えませんでした",
    "わせます",
    "わせません",
    "わせました",
    "わせませんでした",
    "われます",
    "われません",
    "われました",
    "われませんでした",
}

local godan_tsu_conjugations_plain = {
    "つ",
    "たない",
    "とう",
    "たないだろう",
    "て",
    "つな",
    "った",
    "たなかった",
    "ったろう",
    "っただろう",
    "たなかっただろう",
    "って",
    "っている",
    "っていた",
    "てば",
    "たなければ",
    "ったら",
    "たなかったら",
    "てる",
    "てない",
    "てた",
    "てなかった",
    "たせる",
    "たせない",
    "たせた",
    "たせなかった",
    "たれる",
    "たれない",
    "たれた",
    "たれなかった",
    "ちたい",
    "ちたくない",
    "ちたかった",
    "ちたくなかった",
}

local godan_tsu_conjugations_polite = {
    "ちます",
    "ちません",
    "ちましょう",
    "つでしょう",
    "たないでしょう",
    "ってください",
    "たないでください",
    "ちました",
    "ちませんでした",
    "ったでしょう",
    "たなかったでしょう",
    "っています",
    "っていません",
    "っていました",
    "っていませんでした",
    "ちましたら",
    "ちませんでしたら",
    "てます",
    "てません",
    "てました",
    "てませんでした",
    "たせます",
    "たせません",
    "たせました",
    "たせませんでした",
    "たれます",
    "たれません",
    "たれました",
    "たれませんでした",
}

local godan_ru_conjugations_plain = {
    "る",
    "らない",
    "ろう",
    "らないだろう",
    "れ",
    "るな",
    "った",
    "らなかった",
    "ったろう",
    "っただろう",
    "らなかっただろう",
    "って",
    "っている",
    "っていた",
    "れば",
    "らなければ",
    "ったら",
    "らなかったら",
    "れる",
    "れない",
    "れた",
    "れなかった",
    "らせる",
    "らせない",
    "らせた",
    "らせなかった",
    "られる",
    "られない",
    "られた",
    "られなかった",
    "りたい",
    "りたくない",
    "りたかった",
    "りたくなかった",
}

local godan_ru_conjugations_polite = {
    "ります",
    "りません",
    "りましょう",
    "るでしょう",
    "らないでしょう",
    "ってください",
    "らないでください",
    "りました",
    "りませんでした",
    "ったでしょう",
    "らなかったでしょう",
    "っています",
    "っていません",
    "っていました",
    "っていませんでした",
    "りましたら",
    "りませんでしたら",
    "れます",
    "れません",
    "れました",
    "れませんでした",
    "らせます",
    "らせません",
    "らせました",
    "らせませんでした",
    "られます",
    "られません",
    "られました",
    "られませんでした",
}

local godan_ku_conjugations_plain = {
    "く",
    "かない",
    "こう",
    "かないだろう",
    "け",
    "くな",
    "いた",
    "かなかった",
    "いたろう",
    "いただろう",
    "かなかっただろう",
    "いて",
    "いている",
    "いていた",
    "けば",
    "かなければ",
    "いたら",
    "かなかったら",
    "ける",
    "けない",
    "けた",
    "けなかった",
    "かせる",
    "かせない",
    "かせた",
    "かせなかった",
    "かれる",
    "かれない",
    "かれた",
    "かれなかった",
    "きたい",
    "きたくない",
    "きたかった",
    "きたくなかった",
}

local godan_ku_conjugations_polite = {
    "きます",
    "きません",
    "きましょう",
    "くでしょう",
    "かないでしょう",
    "いてください",
    "かないでください",
    "きました",
    "きませんでした",
    "いたでしょう",
    "かなかったでしょう",
    "いています",
    "いていません",
    "いていました",
    "いていませんでした",
    "きましたら",
    "きませんでしたら",
    "けます",
    "けません",
    "けました",
    "けませんでした",
    "かせます",
    "かせません",
    "かせました",
    "かせませんでした",
    "かれます",
    "かれません",
    "かれました",
    "かれませんでした",
}

local godan_gu_conjugations_plain = {
    "ぐ",
    "がない",
    "ごう",
    "がないだろう",
    "げ",
    "ぐな",
    "いだ",
    "がなかった",
    "いだろう",
    "いだだろう",
    "がなかっただろう",
    "いで",
    "いでいる",
    "いでいた",
    "げば",
    "がなければ",
    "いだら",
    "がなかったら",
    "げる",
    "げない",
    "げた",
    "げなかった",
    "がせる",
    "がせない",
    "がせた",
    "がせなかった",
    "がれる",
    "がれない",
    "がれた",
    "がれなかった",
    "ぎたい",
    "ぎたくない",
    "ぎたかった",
    "ぎたくなかった",
}

local godan_gu_conjugations_polite = {
    "ぎます",
    "ぎません",
    "ぎましょう",
    "ぐでしょう",
    "がないでしょう",
    "いでください",
    "がないでください",
    "ぎました",
    "ぎませんでした",
    "いだでしょう",
    "がなかったでしょう",
    "いでいます",
    "いでいません",
    "いでいました",
    "いでいませんでした",
    "ぎましたら",
    "ぎませんでしたら",
    "げます",
    "げません",
    "げました",
    "げませんでした",
    "がせます",
    "がせません",
    "がせました",
    "がせませんでした",
    "がれます",
    "がれません",
    "がれました",
    "がれませんでした",
}

local godan_su_conjugations_plain = {
    "す",
    "さない",
    "そう",
    "さないだろう",
    "せ",
    "すな",
    "した",
    "さなかった",
    "したろう",
    "しただろう",
    "さなかっただろう",
    "して",
    "している",
    "していた",
    "せば",
    "さなければ",
    "したら",
    "さなかったら",
    "せる",
    "せない",
    "せた",
    "せなかった",
    "させる",
    "させない",
    "させた",
    "させなかった",
    "される",
    "されない",
    "された",
    "されなかった",
    "したい",
    "したくない",
    "したかった",
    "したくなかった",
}

local godan_su_conjugations_polite = {
    "します",
    "しません",
    "しましょう",
    "すでしょう",
    "さないでしょう",
    "してください",
    "さないでください",
    "しました",
    "しませんでした",
    "したでしょう",
    "さなかったでしょう",
    "しています",
    "していません",
    "していました",
    "していませんでした",
    "しましたら",
    "しませんでしたら",
    "せます",
    "せません",
    "せました",
    "せませんでした",
    "させます",
    "させません",
    "させました",
    "させませんでした",
    "されます",
    "されません",
    "されました",
    "されませんでした",
}

local godan_aru_special_conjugations_plain = {
    "る",
    "らない",
    "ろう",
    "らないだろう",
    "い",
    "るな",
    "った",
    "らなかった",
    "ったろう",
    "っただろう",
    "らなかっただろう",
    "って",
    "っている",
    "っていた",
    "れば",
    "らなければ",
    "ったら",
    "らなかったら",
    "れる",
    "れない",
    "れた",
    "れなかった",
    "れせる",
    "らせない",
    "らせた",
    "らせなかった",
    "られる",
    "られない",
    "られた",
    "られなかった",
    "いたい",
    "いたくない",
    "いたかった",
    "いたくなかった",
}

local godan_aru_special_conjugations_polite = {
    "います",
    "いません",
    "いましょう",
    "るでしょう",
    "らないでしょう",
    "ってください",
    "らないでください",
    "いました",
    "いませんでした",
    "ったでしょう",
    "らなかったでしょう",
    "っています",
    "っていません",
    "っていました",
    "っていませんでした",
    "いましたら",
    "いませんでしたら",
    "れます",
    "れません",
    "れました",
    "れませんでした",
    "らせます",
    "らせません",
    "らせました",
    "らあせませんでした",
    "られます",
    "られません",
    "られました",
    "られませんでした",
}

local godan_iku_special_conjugations_plain = {
    "く",
    "かない",
    "こう",
    "かないだろう",
    "け",
    "くな",
    "った",
    "かなかった",
    "ったろう",
    "っただろう",
    "かなかっただろう",
    "って",
    "っている",
    "っていた",
    "けば",
    "かなければ",
    "ったら",
    "かなかったら",
    "ける",
    "けない",
    "けた",
    "けなかった",
    "かせる",
    "かせない",
    "かせた",
    "かせなかった",
    "かれる",
    "かれない",
    "かれた",
    "かれなかった",
    "きたい",
    "きたくない",
    "きたかった",
    "きたくなかった",
}

local godan_iku_special_conjugations_polite = {
    "きます",
    "きません",
    "きましょう",
    "くでしょう",
    "かないでしょう",
    "ってください",
    "かないでください",
    "きました",
    "きませんでした",
    "ったでしょう",
    "かなかったでしょう",
    "っています",
    "っていません",
    "っていました",
    "っていませんでした",
    "きましたら",
    "きませんでしたら",
    "けます",
    "けません",
    "けました",
    "けませんでした",
    "かせます",
    "かせません",
    "かせました",
    "かせませんでした",
    "かれます",
    "かれません",
    "かれました",
    "かれませんでした",
}

local godan_ru_irregular_conjugations_plain = {
    "ある",
    "ない",
    "あろう",
    "ないだろう",
    "あれ",
    "な",
    "あった",
    "なかった",
    "あったろう",
    "あっただろう",
    "なかっただろう",
    "あって",
    "あっている",
    "あっていた",
    "あれば",
    "なければ",
    "あったら",
    "なかったら",
    "あれる",
    "あれない",
    "あれた",
    "あれなかった",
    "あらせる",
    "あらせない",
    "あらせた",
    "あらせなかった",
    "あられる",
    "あられない",
    "あられた",
    "あられなかった",
    "ありたい",
    "ありたくない",
    "ありたかった",
    "ありたくなかった",
}

local godan_ru_irregular_conjugations_polite = {
    "あります",
    "ありません",
    "ありましょう",
    "あるでしょう",
    "ないでしょう",
    "あってください",
    "ないでください",
    "ありました",
    "ありませんでした",
    "あったでしょう",
    "なかったでしょう",
    "あっています",
    "あっていません",
    "あっていました",
    "あっていませんでした",
    "ありましたら",
    "ありませんでしたら",
    "あれます",
    "あれません",
    "あれました",
    "あれませんでした",
    "あらせます",
    "あらせません",
    "あらせました",
    "あらせませんでした",
    "あられます",
    "あられません",
    "あられました",
    "あられませんでした",
}

local godan_u_special_conjugations_plain = {
    "う",
    "わない",
    "おう",
    "わないだろう",
    "え",
    "うな",
    "うた",
    "わなかった",
    "うたろう",
    "うただろう",
    "わなかっただろう",
    "うて",
    "うている",
    "うていた",
    "えば",
    "わなければ",
    "うたら",
    "わなかったら",
    "える",
    "えない",
    "えた",
    "えなかった",
    "わせる",
    "わせない",
    "わせた",
    "わせなかった",
    "われる",
    "われない",
    "われた",
    "われなかった",
    "いたい",
    "いたくない",
    "いたかった",
    "いたくなかった",
}

local godan_u_special_conjugations_polite = {
    "います",
    "いません",
    "いましょう",
    "うでしょう",
    "わないでしょう",
    "うてください",
    "わないでください",
    "いました",
    "いませんでした",
    "うたでしょう",
    "わなかったでしょう",
    "うています",
    "うていません",
    "うていました",
    "うていませんでした",
    "いましたら",
    "いませんでしたら",
    "えます",
    "えません",
    "えました",
    "えませんでした",
    "わせます",
    "わせません",
    "わせました",
    "わせませんでした",
    "われます",
    "われません",
    "われました",
    "われませんでした",
}

local suru_conjugations_plain = {
    "する",
    "しない",
    "しよう",
    "しないだろう",
    "しろ",
    "するな",
    "した",
    "しなかった",
    "したろう",
    "しただろう",
    "しなかっただろう",
    "して",
    "している",
    "していた",
    "すれば",
    "しなければ",
    "したら",
    "しなかったら",
    "できる",
    "できない",
    "できた",
    "できなかった",
    "させる",
    "させない",
    "させた",
    "させなかった",
    "される",
    "されない",
    "された",
    "されなかった",
    "したい",
    "したくない",
    "したかった",
    "したくなかった",
}

local suru_conjugations_polite = {
    "します",
    "しません",
    "しましょう",
    "しないでしょう",
    "してください",
    "しないでください",
    "しました",
    "しませんでした",
    "したでしょう",
    "しなかったでしょう",
    "しています",
    "していません",
    "していました",
    "していませんでした",
    "しましたら",
    "しませんでしたら",
    "できます",
    "できません",
    "できました",
    "できませんでした",
    "させます",
    "させません",
    "させました",
    "させませんでした",
    "されます",
    "されません",
    "されました",
    "されませんでした",
}

local zuru_conjugations_plain = {
    "ずる",
    "じない",
    "じよう",
    "じないだろう",
    "じろ",
    "ずるな",
    "じた",
    "じなかった",
    "じたろう",
    "じただろう",
    "じなかっただろう",
    "じて",
    "じている",
    "じていた",
    "ずれば",
    "じなければ",
    "じたら",
    "じなかったら",
    "じさせる",
    "じさせない",
    "じさせた",
    "じさせなかった",
    "じられる",
    "じられない",
    "じられた",
    "じられなかった",
    "ぜられる",
    "ぜられない",
    "ぜられた",
    "ぜられなかった",
    "じたい",
    "じたくない",
    "じたかった",
    "じたくなかった",
}

local zuru_conjugations_polite = {
    "じます",
    "じません",
    "じましょう",
    "じないでしょう",
    "じてください",
    "じないでください",
    "じました",
    "じませんでした",
    "じたでしょう",
    "じなかったでしょう",
    "じています",
    "じていません",
    "じていました",
    "じていませんでした",
    "じましたら",
    "じませんでしたら",
    "じさせます",
    "じさせません",
    "じさせました",
    "じさせませんでした",
    "じられます",
    "じられません",
    "じられました",
    "じられませんでした",
    "ぜられます",
    "ぜられません",
    "ぜられました",
    "ぜられませんでした",
}

local kuru_ki_conjugations_plain = {
    "た",
    "たろう",
    "ただろう",
    "て",
    "ている",
    "ていた",
    "たら",
    "たい",
    "たくない",
    "たかった",
    "たくなかった"
}

local kuru_ku_conjugations_plain = {
    "る",
    "るだろう",
    "るな",
    "れば"
}

local kuru_ko_conjugations_plain = {
    "ない",
    "よう",
    "ないだろう",
    "い",
    "なかった",
    "なかっただろう",
    "なければ",
    "なかったら",
    "られる",
    "られない",
    "られた",
    "られなかった",
    "させる",
    "させない",
    "させた",
    "させなかった",
    "される",
    "されない",
    "された",
    "されなかった",
}

local kuru_ki_conjugations_polite = {
    "ます",
    "ません",
    "ましょう",
    "てください",
    "ました",
    "ませんでした",
    "たでしょう",
    "ています",
    "ていません",
    "ていました",
    "ていませんでした",
    "ましたら",
    "ませんでしたら"
}

local kuru_ko_conjugations_polite = {
    "ないでしょう",
    "ないでください",
    "なかったでしょう",
    "られます",
    "られません",
    "られました",
    "られませんでした",
    "させます",
    "させません",
    "させました",
    "させませんでした",
    "されます",
    "されません",
    "されました",
    "されませんでした",
}

local ii_adjective_conjugations_plain = {
    "い",
    "くない",
    "かった",
    "くなかった"
}

local ii_adjective_conjugations_polite = {
    "いです",
    "くないです",
    "かったです",
    "くなかったです"
}

local yoi_ii_adjective_conjugations_plain = {
    "いい",
    "よくない",
    "よかった",
    "よくなかった"
}

local yoi_ii_adjective_conjugations_polite = {
    "いいです",
    "よくないです",
    "よかったです",
    "よくなかったです"
}

kanji.is_valid_conjugation = (function(kana, entry)
    local stem_matches = string.startswith(kana, entry.kana)
    if (not stem_matches) then
        return false
    end

    local parts_of_speech = {}
    if (entry.pos ~= nil and #entry.pos > 0) then
        for i, value in ipairs(entry.pos) do
            parts_of_speech[value] = true
        end
    end

    function try_conjugate(plain_conj, polite_conj)
        for i, conj in ipairs(plain_conj) do
            if (string.startswith(kana, entry.kana .. conj) or string.startswith(entry.kana .. conj, kana)) then
                return true
            end
        end
        if (polite_conj) then
            for i, conj in ipairs(polite_conj) do
                if (string.startswith(kana, entry.kana .. conj) or string.startswith(entry.kana .. conj, kana)) then
                    return true
                end
            end
        end
    end

    -- SPECIAL VERBS --
    -- Godan aru special verb
    if (parts_of_speech["v5aru"] and try_conjugate(godan_aru_special_conjugations_plain, godan_aru_special_conjugations_polite)) then
        return true
    end
    -- Godan iku/yuku special verb
    if (parts_of_speech["v5k-s"] and try_conjugate(godan_iku_special_conjugations_plain, godan_iku_special_conjugations_polite)) then
        return true
    end
    -- Godan ru irregular verb
    if (parts_of_speech["v5r-i"] and try_conjugate(godan_ru_irregular_conjugations_plain, godan_ru_irregular_conjugations_polite)) then
        return true
    end
    -- Godan u special verb
    if (parts_of_speech["v5u-s"] and try_conjugate(godan_u_special_conjugations_plain, godan_u_special_conjugations_polite)) then
        return true
    end
    -- Suru verb
    if (parts_of_speech["vs"] and try_conjugate(suru_conjugations_plain, suru_conjugations_polite)) then
        return true
    end
    -- Zuru verb
    if (parts_of_speech["vz"] and try_conjugate(zuru_conjugations_plain, zuru_conjugations_polite)) then
        return true
    end
    -- Kuru verb (3 stem types)
    if (parts_of_speech["vk-ki"] and try_conjugate(kuru_ki_conjugations_plain, kuru_ki_conjugations_polite)) then
        return true
    end
    if (parts_of_speech["vk-ku"] and try_conjugate(kuru_ku_conjugations_plain)) then
        return true
    end
    if (parts_of_speech["vk-ko"] and try_conjugate(kuru_ko_conjugations_plain, kuru_ko_conjugations_polite)) then
        return true
    end
    -- Ichidan kureru special verb
    if (parts_of_speech["v1-s"] and try_conjugate(ichidan_kureru_special_conjugations_plain, ichidan_conjugations_polite)) then
        return true
    end

    -- REGULAR VERBS --
    -- Ichidan verb
    if (parts_of_speech["v1"] and try_conjugate(ichidan_conjugations_plain, ichidan_conjugations_polite)) then
        return true
    end
    -- Godan mu verb
    if (parts_of_speech["v5m"] and try_conjugate(godan_mu_conjugations_plain, godan_mu_conjugations_polite)) then
        return true
    end
    -- Godan nu verb
    if (parts_of_speech["v5n"] and try_conjugate(godan_nu_conjugations_plain, godan_nu_conjugations_polite)) then
        return true
    end
    -- Godan bu verb
    if (parts_of_speech["v5b"] and try_conjugate(godan_bu_conjugations_plain, godan_bu_conjugations_polite)) then
        return true
    end
    -- Godan u verb
    if (parts_of_speech["v5u"] and try_conjugate(godan_u_conjugations_plain, godan_u_conjugations_polite)) then
        return true
    end
    -- Godan tsu verb
    if (parts_of_speech["v5t"] and try_conjugate(godan_tsu_conjugations_plain, godan_tsu_conjugations_polite)) then
        return true
    end
    -- Godan ru verb
    if (parts_of_speech["v5r"] and try_conjugate(godan_ru_conjugations_plain, godan_ru_conjugations_polite)) then
        return true
    end
    -- Godan ku verb
    if (parts_of_speech["v5k"] and try_conjugate(godan_ku_conjugations_plain, godan_ku_conjugations_polite)) then
        return true
    end
    -- Godan gu verb
    if (parts_of_speech["v5g"] and try_conjugate(godan_gu_conjugations_plain, godan_gu_conjugations_polite)) then
        return true
    end
    -- Godan su verb
    if (parts_of_speech["v5s"] and try_conjugate(godan_su_conjugations_plain, godan_su_conjugations_polite)) then
        return true
    end

    -- ADJECTIVES --
    if (parts_of_speech["adj-i"] and try_conjugate(ii_adjective_conjugations_plain, ii_adjective_conjugations_polite)) then
        return true
    end
    if (parts_of_speech["adj-ix"] and try_conjugate(yoi_ii_adjective_conjugations_plain, yoi_ii_adjective_conjugations_polite)) then
        return true
    end

    return false
end)

kanji.get_valid_conjugations = (function(kana, entry)
    local stem_matches = string.startswith(kana, entry.kana)
    if (not stem_matches) then
        return false
    end

    local stemless_kana = string.slice(kana, #entry.kana)

    local parts_of_speech = {}
    for i, value in ipairs(entry.pos) do
        parts_of_speech[value] = true
    end

    local valid_conjugations = L{}

    -- Ichidan verb
    if (parts_of_speech["v1"]) then
        for i, conj in ipairs(ichidan_conjugations_plain) do
            if (string.startswith(kana, entry.kana .. conj) or string.startswith(entry.kana .. conj, kana)) then
                valid_conjugations:append(conj)
            end
        end
        for i, conj in ipairs(ichidan_conjugations_polite) do
            if (string.startswith(kana, entry.kana .. conj) or string.startswith(entry.kana .. conj, kana)) then
                valid_conjugations:append(conj)
            end
        end
    end

    return valid_conjugations
end)

return kanji

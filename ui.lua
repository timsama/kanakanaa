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

local texts = require("texts")
local images = require("images")
local textformat = require("lib/textformat")
local hiragana = require("hiragana")
local katakana = require("katakana")
local kanji = require("kanji")
local autotranslate = require("autotranslate")
local utf8slim = require("utf8slim")


local jsonfiles = require("jsonfiles")
local CONFIG = jsonfiles.read("config/config.json")

local ZERO_WIDTH_SPACE = "​" -- Yes, there really is a character in between the quotes
local HAIRLINE_SPACE = " "

local Ui = {}

Ui.ModeIndicator = require("modeindicator")

Ui.selected_index = 1
Ui.autocomplete_entries = {}
Ui.autotranslate_entries = L{}

local IMETextBar = {}
IMETextBar.settings = {}
IMETextBar.settings.text = {}
IMETextBar.settings.text.pos = {}
IMETextBar.settings.text.pos.x = 18
IMETextBar.settings.text.pos.y = windower.get_windower_settings().ui_y_res - 36
IMETextBar.settings.text.bg = {}
IMETextBar.settings.text.bg.alpha = 0
IMETextBar.settings.text.bg.blue = 0
IMETextBar.settings.text.bg.green = 0
IMETextBar.settings.text.bg.red = 0
IMETextBar.settings.text.bg.visible = true
IMETextBar.settings.text.padding = 0
IMETextBar.settings.text.text = {}
IMETextBar.settings.text.text.font = "MS UI Gothic"
IMETextBar.settings.text.text.size = 12
IMETextBar.settings.visible = true
IMETextBar.text = texts.new(IMETextBar.settings.text, IMETextBar.settings)

local IMETextBarFillout = {}
IMETextBarFillout.settings = {}
IMETextBarFillout.settings.text = {}
IMETextBarFillout.settings.text.pos = {}
IMETextBarFillout.settings.text.pos.x = 18
IMETextBarFillout.settings.text.pos.y = windower.get_windower_settings().ui_y_res - 36
IMETextBarFillout.settings.text.bg = {}
IMETextBarFillout.settings.text.bg.alpha = 0
IMETextBarFillout.settings.text.bg.blue = 0
IMETextBarFillout.settings.text.bg.green = 0
IMETextBarFillout.settings.text.bg.red = 0
IMETextBarFillout.settings.text.bg.visible = true
IMETextBarFillout.settings.text.padding = 0
IMETextBarFillout.settings.text.text = {}
IMETextBarFillout.settings.text.text.font = "MS UI Gothic"
IMETextBarFillout.settings.text.text.size = 12
IMETextBarFillout.settings.visible = true
IMETextBarFillout.text = texts.new(IMETextBarFillout.settings.text, IMETextBarFillout.settings)

local AutocompleteSpacer = {}
AutocompleteSpacer.settings = {}
AutocompleteSpacer.settings.text = {}
AutocompleteSpacer.settings.text.pos = {}
AutocompleteSpacer.settings.text.pos.x = 18
AutocompleteSpacer.settings.text.pos.y = windower.get_windower_settings().ui_y_res - 36
AutocompleteSpacer.settings.text.bg = {}
AutocompleteSpacer.settings.text.bg.alpha = 0
AutocompleteSpacer.settings.text.bg.blue = 0
AutocompleteSpacer.settings.text.bg.green = 0
AutocompleteSpacer.settings.text.bg.red = 0
AutocompleteSpacer.settings.text.bg.visible = true
AutocompleteSpacer.settings.text.padding = 0
AutocompleteSpacer.settings.text.text = {}
AutocompleteSpacer.settings.text.text.font = "MS UI Gothic"
AutocompleteSpacer.settings.text.text.size = 12
AutocompleteSpacer.settings.visible = true
AutocompleteSpacer.text = texts.new(AutocompleteSpacer.settings.text, AutocompleteSpacer.settings)

local CursorAndSpacer = {}
CursorAndSpacer.settings = {}
CursorAndSpacer.settings.text = {}
CursorAndSpacer.settings.text.pos = {}
CursorAndSpacer.settings.text.pos.x = 18
CursorAndSpacer.settings.text.pos.y = windower.get_windower_settings().ui_y_res - 36
CursorAndSpacer.settings.text.bg = {}
CursorAndSpacer.settings.text.bg.alpha = 0
CursorAndSpacer.settings.text.bg.blue = 0
CursorAndSpacer.settings.text.bg.green = 0
CursorAndSpacer.settings.text.bg.red = 0
CursorAndSpacer.settings.text.bg.visible = true
CursorAndSpacer.settings.text.padding = 0
CursorAndSpacer.settings.text.text = {}
CursorAndSpacer.settings.text.text.font = "MS UI Gothic"
CursorAndSpacer.settings.text.text.size = 12
CursorAndSpacer.settings.visible = true
CursorAndSpacer.text = texts.new(CursorAndSpacer.settings.text, CursorAndSpacer.settings)

local Autocomplete = {}
Autocomplete.settings = {}
Autocomplete.settings.text = {}
Autocomplete.settings.text.pos = {}
Autocomplete.settings.text.pos.x = 18
Autocomplete.settings.text.pos.y = windower.get_windower_settings().ui_y_res - 36
Autocomplete.settings.text.bg = {}
Autocomplete.settings.text.bg.alpha = 255
Autocomplete.settings.text.bg.blue = 0
Autocomplete.settings.text.bg.green = 0
Autocomplete.settings.text.bg.red = 0
Autocomplete.settings.text.bg.visible = true
Autocomplete.settings.text.padding = 0
Autocomplete.settings.text.text = {}
Autocomplete.settings.text.text.font = "MS UI Gothic"
Autocomplete.settings.text.text.size = 12
Autocomplete.settings.visible = true
Autocomplete.settings.colors = {}
Autocomplete.settings.colors.bg = {}
Autocomplete.settings.colors.bg.red = 0
Autocomplete.settings.colors.bg.green = 0
Autocomplete.settings.colors.bg.blue = 0
Autocomplete.settings.colors.bg.alpha = 255
Autocomplete.text = texts.new(Autocomplete.settings.text, Autocomplete.settings)

local Autotranslate = {}
Autotranslate.settings = {}
Autotranslate.settings.text = {}
Autotranslate.settings.text.pos = {}
Autotranslate.settings.text.pos.x = 18
Autotranslate.settings.text.pos.y = windower.get_windower_settings().ui_y_res - 36
Autotranslate.settings.text.bg = {}
Autotranslate.settings.text.bg.alpha = 255
Autotranslate.settings.text.bg.blue = 0
Autotranslate.settings.text.bg.green = 0
Autotranslate.settings.text.bg.red = 0
Autotranslate.settings.text.bg.visible = true
Autotranslate.settings.text.padding = 0
Autotranslate.settings.text.text = {}
Autotranslate.settings.text.text.font = "MS UI Gothic"
Autotranslate.settings.text.text.size = 12
Autotranslate.settings.visible = true
Autotranslate.settings.colors = {}
Autotranslate.settings.colors.bg = {}
Autotranslate.settings.colors.bg.red = 0
Autotranslate.settings.colors.bg.green = 0
Autotranslate.settings.colors.bg.blue = 0
Autotranslate.settings.colors.bg.alpha = 255
Autotranslate.text = texts.new(Autotranslate.settings.text, Autotranslate.settings)

local chat_bg = images.new()

Ui.set_chat_bar_width = (function(width)
    if (width ~= nil) then
        chat_bg:size(width, 16)
    else
        chat_bg:size(windower.get_windower_settings().ui_x_res - 150, 16)
    end
end)

chat_bg:repeat_xy(1, 1)
chat_bg:draggable(false)
chat_bg:alpha(255)
chat_bg:pos(18, windower.get_windower_settings().ui_y_res - 36)
Ui.set_chat_bar_width(CONFIG.chatbarwidth)
chat_bg:fit(false)
chat_bg:path(windower.addon_path .. "/img/black.png")
chat_bg:hide()

Ui.initialize = (function()
    blink_cursor()
end)

local cursor_character = ""
local cursor_spacer_text = ""

function blink_cursor()
    if (cursor_character == "") then
        cursor_character = "|"
    else
        cursor_character = ""
    end

    render_cursor_spacer()
    coroutine.schedule(blink_cursor, 0.5)
end

Ui.display = (function(should_show)
    IMETextBar.text:visible(should_show)
    IMETextBarFillout.text:visible(should_show)
    CursorAndSpacer.text:visible(should_show)
    AutocompleteSpacer.text:visible(should_show)
    if (not should_show) then
        Autocomplete.text:visible(false)
        Autotranslate.text:visible(false)
    end
end)

-- Splits text across the cursor for ease of rendering. Order of use is as follows:
-- before.pending > before.autocomplete > before.keystroke > CURSOR > after.keystroke > after.autocomplete > after.pending
-- Unless the cursor is back "in the weeds" somewhere, this degenerates to:
-- before.pending > before.autocomplete > before.keystroke > CURSOR
function split_text(keystroke_buffer, autocomplete_text, pending_buffer, pending_offset, romaji_offset, keystroke_offset)
    local text = {}

    local autocomplete_buffer = utf8slim.explode(autocomplete_text)

    -- compile pre-cursor text
    text.before_cursor = {}
    text.before_cursor.pending = "" .. ZERO_WIDTH_SPACE
    text.before_cursor.autocomplete = "" .. ZERO_WIDTH_SPACE
    text.before_cursor.keystroke = "" .. ZERO_WIDTH_SPACE

    local characters_before_split = 0
    for i, character in ipairs(pending_buffer) do
        if (i < pending_offset + 1) then
            text.before_cursor.pending = text.before_cursor.pending .. textformat.handle_autotranslates(character)
            characters_before_split = characters_before_split + 1
        end
    end

    for i, character in ipairs(autocomplete_buffer) do
        if (i < romaji_offset + 1) then
            text.before_cursor.autocomplete = text.before_cursor.autocomplete .. character
            characters_before_split = characters_before_split + 1
        end
    end

    text.before_cursor.keystroke = keystroke_buffer:sub(1, keystroke_offset)

    -- compile post-cursor text
    text.after_cursor = {}
    text.after_cursor.keystroke = "" .. ZERO_WIDTH_SPACE
    text.after_cursor.autocomplete = "" .. ZERO_WIDTH_SPACE
    text.after_cursor.pending = "" .. ZERO_WIDTH_SPACE

    text.after_cursor.keystroke = keystroke_buffer:sub(keystroke_offset + 1)

    for i, character in ipairs(autocomplete_buffer) do
        if (i >= romaji_offset + 1) then
            text.after_cursor.autocomplete = text.after_cursor.autocomplete .. character
        end
    end

    for i, character in ipairs(pending_buffer) do
        if (i >= pending_offset + 1) then
            text.after_cursor.pending = text.after_cursor.pending .. textformat.handle_autotranslates(character)
        end
    end

    return text
end

Ui.update = (function(keystroke_buffer, romaji_buffer, pending_buffer, pending_offset, romaji_offset, keystroke_offset)
    local autocomplete_text = ""
    if (Ui.get_selected_autocomplete_entry() ~= nil) then
        autocomplete_text = Ui.get_selected_autocomplete_entry().text
    end
    local splittext = split_text(keystroke_buffer, autocomplete_text, pending_buffer, pending_offset, romaji_offset, keystroke_offset)

    render_autocomplete_spacer(splittext)
    render_cursor_spacer(splittext)

    render_autocomplete(romaji_buffer)
    render_autotranslate(keystroke_buffer)
    render_ime_text_bar(splittext)
end)

-- Displays the text that has been entered, color-coded based on its status
function render_ime_text_bar(splittext)
    local ime_text = HAIRLINE_SPACE ..
        textformat.start_white_text() .. ZERO_WIDTH_SPACE ..
        splittext.before_cursor.pending ..
        textformat.start_blue_text() .. ZERO_WIDTH_SPACE ..
        splittext.before_cursor.autocomplete ..
        textformat.start_green_text() .. ZERO_WIDTH_SPACE ..
        splittext.before_cursor.keystroke ..
        splittext.after_cursor.keystroke ..
        textformat.start_blue_text() .. ZERO_WIDTH_SPACE ..
        splittext.after_cursor.autocomplete ..
        textformat.start_white_text() .. ZERO_WIDTH_SPACE ..
        splittext.after_cursor.pending

    IMETextBar.text:text(ime_text)
    IMETextBar.text:visible(true)
    IMETextBarFillout.text:text(ime_text)
    IMETextBarFillout.text:visible(true)
end

-- "Displays" an invisible text bar that's only used to find the correct spacing for the autocomplete list
function render_autocomplete_spacer(splittext)
    local spacer_text = HAIRLINE_SPACE ..
        textformat.start_white_text() .. ZERO_WIDTH_SPACE ..
        splittext.before_cursor.pending

    AutocompleteSpacer.text:text(spacer_text)
    AutocompleteSpacer.text:visible(true)
end

-- Displays the autocomplete list
function render_autocomplete(romaji_buffer)
    if (#romaji_buffer > 0) then
        local autocomplete_text = ""
        local entry_count = #Ui.autocomplete_entries
        for i=1,entry_count do
            local line_text = HAIRLINE_SPACE .. textformat.start_white_text() .. ZERO_WIDTH_SPACE
            if (i == Ui.selected_index) then
                line_text = line_text .. textformat.start_green_text() .. ZERO_WIDTH_SPACE .. Ui.autocomplete_entries[i].text
            else
                line_text = line_text .. textformat.start_white_text() .. ZERO_WIDTH_SPACE .. Ui.autocomplete_entries[i].text
            end
            if (i > 1) then
                line_text = line_text .. "\n"
            end
            autocomplete_text = line_text .. autocomplete_text
        end

        local pos_x, pos_y = texts.pos(AutocompleteSpacer.text)
        local x, y = texts.extents(AutocompleteSpacer.text)

        Autocomplete.text:pos_x(pos_x + x)
        Autocomplete.text:pos_y(pos_y - 16 * #Ui.autocomplete_entries)
        Autocomplete.text:text(autocomplete_text)
        Autocomplete.text:visible(true)
    else
        Autocomplete.text:visible(false)
    end
end

-- Displays the autotranslate list
function render_autotranslate(keystroke_buffer)
    if (#keystroke_buffer > 0) then
        local autotranslate_text = ""
        local entry_count = #Ui.autotranslate_entries
        for i=1,entry_count do
            local line_text = HAIRLINE_SPACE .. textformat.start_white_text() .. ZERO_WIDTH_SPACE
            if (i == Ui.selected_index) then
                line_text = line_text .. textformat.start_green_text() .. ZERO_WIDTH_SPACE .. Ui.autotranslate_entries[i].en
            else
                line_text = line_text .. textformat.start_white_text() .. ZERO_WIDTH_SPACE .. Ui.autotranslate_entries[i].en
            end
            if (i > 1) then
                line_text = line_text .. "\n"
            end
            autotranslate_text = line_text .. autotranslate_text
        end

        local pos_x, pos_y = texts.pos(AutocompleteSpacer.text)
        local x, y = texts.extents(AutocompleteSpacer.text)

        Autotranslate.text:pos_x(pos_x + x)
        Autotranslate.text:pos_y(pos_y - 16 * #Ui.autotranslate_entries)
        Autotranslate.text:text(autotranslate_text)
        Autotranslate.text:visible(true)
    else
        Autotranslate.text:visible(false)
    end
end

-- "Displays" an invisible text bar that's only used to find the correct location to display the cursor
function render_cursor_spacer(splittext)
    if (splittext ~= nil) then
        cursor_spacer_text = HAIRLINE_SPACE ..
            textformat.start_white_text() .. ZERO_WIDTH_SPACE ..
            splittext.before_cursor.pending ..
            textformat.start_blue_text() .. ZERO_WIDTH_SPACE ..
            splittext.before_cursor.autocomplete ..
            textformat.start_green_text() .. ZERO_WIDTH_SPACE ..
            splittext.before_cursor.keystroke ..
            textformat.start_white_text() .. ZERO_WIDTH_SPACE
    end

    CursorAndSpacer.text:text(cursor_spacer_text .. cursor_character)
end

Ui.update_autocomplete = (function(romaji_buffer)
    Ui.autocomplete_entries = {}

    if (#romaji_buffer > 0) then
        local hiragana_entry = {}
        hiragana_entry.text = hiragana.from_romaji(romaji_buffer)
        hiragana_entry.pos = {}
        local katakana_entry = {}
        katakana_entry.text = katakana.from_romaji(romaji_buffer)
        katakana_entry.pos = {}
        table.insert(Ui.autocomplete_entries, hiragana_entry)
        table.insert(Ui.autocomplete_entries, katakana_entry)

        local kana_words, kanji_words = kanji.lookup_by_reading(hiragana_entry.text)
        local word_count = 0

        for i, word in ipairs(kana_words) do
            if (word_count < 20) then
                table.insert(Ui.autocomplete_entries, word)
            end
        end

        for i, word in ipairs(kanji_words) do
            if (word_count < 20) then
                table.insert(Ui.autocomplete_entries, word)
            end
        end
    end
end)

Ui.update_autotranslate = (function(text)
    if (#text > 0) then
        Ui.autotranslate_entries = autotranslate.lookup(text)
    else
        Ui.autotranslate_entries = L{}
    end
end)

Ui.move_selection_down = (function()
    Ui.selected_index = Ui.selected_index - 1
    if (#Ui.autocomplete_entries > 0) then
        if (Ui.selected_index == 0) then
            Ui.selected_index = #Ui.autocomplete_entries
        end
    elseif (#Ui.autotranslate_entries > 0) then
        if (Ui.selected_index == 0) then
            Ui.selected_index = #Ui.autotranslate_entries
        end
    end
end)

Ui.move_selection_up = (function()
    Ui.selected_index = Ui.selected_index + 1
    if (#Ui.autocomplete_entries > 0) then
        if (Ui.selected_index > #Ui.autocomplete_entries) then
            Ui.selected_index = 1
        end
    elseif (#Ui.autotranslate_entries > 0) then
        if (Ui.selected_index > #Ui.autotranslate_entries) then
            Ui.selected_index = 1
        end
    end
end)

-- reset selection to plain Hiragana so we don't have "cursor memory" in the menu
Ui.reset_selection = (function()
    Ui.selected_index = 1
end)

-- reset selection to plain kana when deleting characters. No changes needed if we already have kana selected
Ui.reset_selection_to_kana = (function()
    if (Ui.selected_index > 2) then
        Ui.selected_index = 1
    end
end)

-- reset selection to hiragana; used when typing characters after selecting an autocomplete entry
Ui.reset_selection_to_hiragana = (function()
    Ui.selected_index = 1
end)

Ui.get_selected_autocomplete_entry = (function()
    return Ui.autocomplete_entries[Ui.selected_index]
end)

Ui.get_selected_autotranslate_entry = (function()
    return Ui.autotranslate_entries[Ui.selected_index]
end)

Ui.show_chat_bg = (function()
    chat_bg:show()
end)

Ui.hide_chat_bg = (function()
    chat_bg:hide()
end)

return Ui

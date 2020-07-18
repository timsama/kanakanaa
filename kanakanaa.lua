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

-- Addon description
_addon.name = "KanaKanaa Japanese IME"
_addon.author = "Tim Winchester"
_addon.version = "0.1"
_addon.language = "english"
_addon.commands = {"kanakanaa", "kkn"}

require("lists")

local jsonfiles = require("jsonfiles")

local CONFIG = jsonfiles.read("config/config.json")

-- Import Kana
local hiragana = require("hiragana")
local katakana = require("katakana")

-- UTF8 Character handling
local utf8slim = require("utf8slim")

-- Import Delivery Box
local deliverybox = require("lib/deliverybox")
local chatmodes = require("lib/chatmodes")

-- Import UI pieces
local Ui = require("ui")
Ui.initialize()

-- Autotranslate handling
local autotranslate = require("autotranslate")
local AUTOTRANSLATE_MESSAGE = "<Start typing to display autotranslate entries>"

-- We should always start deactivated
Ui.ModeIndicator.deactivate_kana_mode()

-- DirectInput key codes to romaji characters
local keymap = require("keymap/keymap")

-- State variables
local kana_mode = false
local autotranslate_mode = false
local ctrl_down = false
local shift_down = false
local panic_down = false
local keystroke_buffer = ""
local romaji_buffer = L{}
local pending_buffer = L{}
local new_line = false
local should_restore_kana_mode_after_command = false
local should_restore_kana_mode_after_delivery = false
local most_recent_parts_of_speech = {}
local chat_mode_input = ""

local pending_insertion_offset = 0
local romaji_insertion_offset = 0
local keystroke_insertion_offset = 0

local consonant_map = {}
consonant_map["k"] = true
consonant_map["g"] = true
consonant_map["s"] = true
consonant_map["z"] = true
consonant_map["j"] = true
consonant_map["t"] = true
consonant_map["c"] = true
consonant_map["d"] = true
consonant_map["n"] = true
consonant_map["h"] = true
consonant_map["f"] = true
consonant_map["b"] = true
consonant_map["p"] = true
consonant_map["m"] = true
consonant_map["r"] = true
consonant_map["w"] = true
consonant_map["v"] = true

function is_valid_consonant(keystroke)
    return consonant_map[keystroke]
end

local punctuation_map = {}
punctuation_map[","] = true
punctuation_map["."] = true
punctuation_map["?"] = true
punctuation_map["!"] = true
punctuation_map["\""] = true

function is_valid_punctuation(keystroke)
    return punctuation_map[keystroke]
end

deliverybox.register_event("on open send", (function()
    if (kana_mode) then
        should_restore_kana_mode_after_delivery = true
        kana_mode = false
        Ui.ModeIndicator.deactivate_kana_mode()
    end
end))

deliverybox.register_event("on close", (function()
    if (should_restore_kana_mode_after_delivery) then
        should_restore_kana_mode_after_delivery = false
        kana_mode = true
        Ui.ModeIndicator.activate_kana_mode()
    end
end))

function should_split_connector(kana, next_character, preceding_part_of_speech)
    if (next_character == nil) then
        return false
    end

    local was_valid = is_valid_connector(kana, preceding_part_of_speech)
    local is_valid = is_valid_connector(kana .. next_character, preceding_part_of_speech)
    return was_valid and not is_valid
end

function is_valid_connector(kana, preceding_part_of_speech)
    if (preceding_part_of_speech.n) then
        local noun_connectors = {}
        noun_connectors["を"] = true
        noun_connectors["は"] = true
        noun_connectors["が"] = true
        noun_connectors["の"] = true
        noun_connectors["で"] = true
        noun_connectors["も"] = true
        noun_connectors["と"] = true
        noun_connectors["や"] = true
        noun_connectors["に"] = true
        noun_connectors["へ"] = true
        noun_connectors["から"] = true
        noun_connectors["くらい"] = true
        noun_connectors["ぐらい"] = true
        noun_connectors["とか"] = true
        noun_connectors["とも"] = true
        noun_connectors["だけ"] = true
        noun_connectors["でも"] = true
        noun_connectors["では"] = true
        noun_connectors["じゃ"] = true
        noun_connectors["じゃあ"] = true
        noun_connectors["など"] = true
        noun_connectors["ので"] = true
        noun_connectors["のに"] = true
        noun_connectors["のが"] = true
        noun_connectors["のは"] = true
        noun_connectors["より"] = true
        noun_connectors["まで"] = true
        noun_connectors["です"] = true -- not really a connector, but we still want to split there.

        return noun_connectors[kana]
    end
end

function clear_buffers()
    clear_keystroke_buffer()
    clear_romaji_buffer()
    clear_pending_buffer()
end

function clear_keystroke_buffer()
    keystroke_buffer = ""
    keystroke_insertion_offset = 0
end

function clear_romaji_buffer()
    romaji_buffer = L{}
    romaji_insertion_offset = 0
end

function clear_pending_buffer()
    pending_buffer = L{}
    pending_insertion_offset = 0
end

function get_insertion_buffer()
    if (autotranslate_mode) then
        local entry = Ui.get_selected_autotranslate_entry()
        local insertion_buffer = {}
        if (entry == nil) then
            insertion_buffer.text = ""
        else
            insertion_buffer.text = autotranslate.to_pending_buffer_format(entry.id)
        end
        insertion_buffer.pos = {}

        clear_keystroke_buffer()
        Ui.update_autotranslate(keystroke_buffer)

        return insertion_buffer
    else
        local entry = Ui.get_selected_autocomplete_entry()
        local insertion_buffer = {}
        if (entry == nil) then
            insertion_buffer.text = ""
            insertion_buffer.pos = {}
        else
            insertion_buffer.text = entry.text
            insertion_buffer.pos = entry.pos
        end

        if (keystroke_buffer == "n") then
            merge_into_romaji_buffer("nn", romaji_insertion_offset)
            move_romaji_offset_right()

            insertion_buffer.text = insertion_buffer.text .. "ん"

            Ui.update_autocomplete(romaji_buffer)
        end

        return insertion_buffer
    end
end

function merge_into_pending_buffer(buffer_to_merge, insertion_offset)
    local new_pending_buffer = L{}

    -- copy in pending buffer characters before the insertion point
    for i, character in ipairs(pending_buffer) do
        if (i <= insertion_offset) then
            list.append(new_pending_buffer, character)
        end
    end

    -- copy in buffer_to_merge characters at the insertion point
    for i, character in ipairs(buffer_to_merge) do
        list.append(new_pending_buffer, character)
    end

    -- copy in pending buffer characters after the insertion point
    for i, character in ipairs(pending_buffer) do
        if (i > insertion_offset) then
            list.append(new_pending_buffer, character)
        end
    end

    pending_buffer = new_pending_buffer
    
    clear_romaji_buffer()
    Ui.reset_selection()
    Ui.update_autocomplete(romaji_buffer)
end

function merge_into_romaji_buffer(character_to_merge, insertion_offset)
    local new_romaji_buffer = L{}

    -- copy in romaji buffer characters before the insertion point
    for i, character in ipairs(romaji_buffer) do
        if (i <= insertion_offset) then
            list.append(new_romaji_buffer, character)
        end
    end

    -- copy in character at the insertion point
    list.append(new_romaji_buffer, character_to_merge)

    -- copy in romaji buffer characters after the insertion point
    for i, character in ipairs(romaji_buffer) do
        if (i > insertion_offset) then
            list.append(new_romaji_buffer, character)
        end
    end

    romaji_buffer = new_romaji_buffer

    Ui.update_autocomplete(romaji_buffer)
end

function merge_autocomplete()
    local autocomplete_entry = Ui.get_selected_autocomplete_entry()
    if (autocomplete_entry ~= nil) then
        local autocomplete_buffer = utf8slim.explode(autocomplete_entry.text)
        merge_into_pending_buffer(autocomplete_buffer, pending_insertion_offset)
        move_pending_offset_right(#autocomplete_buffer)
    end

    clear_keystroke_buffer()
    clear_romaji_buffer()
end

function move_cursor_left()
    local is_handled = false

    if (keystroke_buffer == AUTOTRANSLATE_MESSAGE) then
        return true
    end

    -- keystroke buffer disappears when the cursor leaves it
    if (keystroke_insertion_offset == 0 and #keystroke_buffer > 0) then
        clear_keystroke_buffer()
    elseif (keystroke_insertion_offset > 0) then
        keystroke_insertion_offset = keystroke_insertion_offset - 1
        is_handled = true
    end

    -- romaji_buffer becomes part of pending_buffer when the cursor leaves it
    if (not is_handled and romaji_insertion_offset == 0 and #romaji_buffer > 0) then
        local autocomplete_entry = Ui.get_selected_autocomplete_entry()
        if (autocomplete_entry ~= nil) then
            merge_into_pending_buffer(utf8slim.explode(autocomplete_entry.text), pending_insertion_offset)
        end

        clear_romaji_buffer()
        Ui.reset_selection()
        Ui.update_autocomplete(romaji_buffer)
    elseif (not is_handled and romaji_insertion_offset > 0) then
        romaji_insertion_offset = romaji_insertion_offset - 1
        is_handled = true
    end

    -- the cursor can't really leave pending_buffer, it just moves around in it
    if (not is_handled and pending_insertion_offset > 0) then
        pending_insertion_offset = pending_insertion_offset - 1
    end

    Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
end

function move_cursor_right()
    local is_handled = false

    if (keystroke_buffer == AUTOTRANSLATE_MESSAGE) then
        return true
    end

    -- keystroke buffer disappears when the cursor leaves it
    if (#keystroke_buffer > 0 and keystroke_insertion_offset == #keystroke_buffer) then
        clear_keystroke_buffer()
    elseif (#keystroke_buffer > 0 and keystroke_insertion_offset < #keystroke_buffer) then
        keystroke_insertion_offset = keystroke_insertion_offset + 1
        is_handled = true
    end

    -- romaji_buffer becomes part of pending_buffer when the cursor leaves it
    if (not is_handled and romaji_insertion_offset == #romaji_buffer) then
        local autocomplete_entry = Ui.get_selected_autocomplete_entry()
        if (autocomplete_entry ~= nil) then
            local autocomplete_buffer = utf8slim.explode(autocomplete_entry.text)
            merge_into_pending_buffer(autocomplete_buffer, pending_insertion_offset)
            move_pending_offset_right(#autocomplete_buffer)
        end

        clear_romaji_buffer()
        Ui.reset_selection()
        Ui.update_autocomplete(romaji_buffer)
    elseif (not is_handled and #romaji_buffer > 0 and romaji_insertion_offset < #romaji_buffer) then
        romaji_insertion_offset = romaji_insertion_offset + 1
        is_handled = true
    end

    -- the cursor can't really leave pending_buffer, it just moves around in it
    if (not is_handled and pending_insertion_offset < #pending_buffer) then
        pending_insertion_offset = pending_insertion_offset + 1
    end

    Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
end

function move_keystroke_offset_right()
    if (#keystroke_buffer > 0 and keystroke_insertion_offset < #keystroke_buffer) then
        keystroke_insertion_offset = keystroke_insertion_offset + 1
    end
end

function move_romaji_offset_right()
    if (#romaji_buffer > 0 and romaji_insertion_offset < #romaji_buffer) then
        romaji_insertion_offset = romaji_insertion_offset + 1
    end
end

function move_pending_offset_right(spaces)
    pending_insertion_offset = pending_insertion_offset + spaces
    if (pending_insertion_offset > #pending_buffer + 1) then
        pending_insertion_offset = #pending_buffer + 1
    end
end

function handle_backspace()
    local handled_backspace = false

    if (keystroke_insertion_offset > 0) then
        local new_keystroke_buffer = ""
        for i, character in ipairs(utf8slim.explode(keystroke_buffer)) do
            if (i ~= keystroke_insertion_offset) then
                new_keystroke_buffer = new_keystroke_buffer .. character
            end
        end
        keystroke_insertion_offset = keystroke_insertion_offset - 1
        keystroke_buffer = new_keystroke_buffer
        if (autotranslate_mode) then
            Ui.update_autotranslate(keystroke_buffer)
        end
        handled_backspace = true
    elseif (romaji_insertion_offset > 0) then
        local new_romaji_buffer = L{}
        for i, character in ipairs(romaji_buffer) do
            if (i ~= romaji_insertion_offset) then
                table.insert(new_romaji_buffer, character)
            end
        end
        romaji_insertion_offset = romaji_insertion_offset - 1
        romaji_buffer = new_romaji_buffer
        if (not autotranslate_mode) then
            Ui.update_autocomplete(romaji_buffer)
        end
        handled_backspace = true
    elseif (pending_insertion_offset > 0) then
        -- deleting anything from the pending buffer means we can't know what the most recent part of speech is
        most_recent_parts_of_speech = {}

        local new_pending_buffer = L{}
        for i, character in ipairs(pending_buffer) do
            if (i ~= pending_insertion_offset) then
                list.append(new_pending_buffer, character)
            end
        end
        pending_insertion_offset = pending_insertion_offset - 1
        pending_buffer = new_pending_buffer
        handled_backspace = true
        maybe_update_chat_mode(pending_buffer)
    end

    Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)

    return handled_backspace
end

function handle_delete()
    local handled_delete = false

    if (keystroke_buffer == AUTOTRANSLATE_MESSAGE) then
        return true
    end

    if (#keystroke_buffer > 0 and keystroke_insertion_offset < #keystroke_buffer) then
        local new_keystroke_buffer = ""
        for i, character in ipairs(utf8slim.explode(keystroke_buffer)) do
            if (i ~= keystroke_insertion_offset + 1) then
                new_keystroke_buffer = new_keystroke_buffer .. character
            end
        end
        keystroke_buffer = new_keystroke_buffer
        if (autotranslate_mode) then
            Ui.update_autotranslate(keystroke_buffer)
        end
        handled_delete = true
    elseif (#romaji_buffer > 0 and romaji_insertion_offset < #romaji_buffer) then
        local new_romaji_buffer = L{}
        for i, character in ipairs(romaji_buffer) do
            if (i ~= romaji_insertion_offset + 1) then
                table.insert(new_romaji_buffer, character)
            end
        end
        romaji_buffer = new_romaji_buffer
        if (not autotranslate_mode) then
            Ui.update_autocomplete(romaji_buffer)
        end
        handled_delete = true
    elseif (pending_insertion_offset < #pending_buffer) then
        -- deleting anything from the pending buffer means we can't know what the most recent part of speech is
        most_recent_parts_of_speech = {}

        local new_pending_buffer = L{}
        for i, character in ipairs(pending_buffer) do
            if (i ~= pending_insertion_offset + 1) then
                list.append(new_pending_buffer, character)
            end
        end
        pending_buffer = new_pending_buffer
        handled_delete = true
        maybe_update_chat_mode(pending_buffer)
    end

    Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)

    return handled_delete
end

-- Makes sure the correct chat mode is displayed, based on pending_buffer contents
function maybe_update_chat_mode(pending_buffer)
    if (chat_mode_input ~= "") then
        local pending_buffer_string = ""
        for i, character in ipairs(pending_buffer) do
            pending_buffer_string = pending_buffer_string .. character
        end
        if (not chatmodes.has_mode_prefix(pending_buffer_string)) then
            windower.chat.set_input(chat_mode_input:sub(1, -3)) -- have to get rid of the trailing space
            chat_mode_input = ""
            clear_buffers()
            kana_mode = false
            should_restore_kana_mode_after_command = true
            Ui.ModeIndicator.deactivate_kana_mode()
        end
    end
end


local last_chat_text = ""

-- ON KEY
windower.register_event("keyboard", function(dik, pressed, flags, blocked)
    -- windower.send_command("@input /echo "..dik)

    if (dik == keymap.ctrl) then
        ctrl_down = pressed
    end
    if (dik == keymap.shift) then
        shift_down = pressed
    end
    if (dik == keymap.panic) then
        panic_down = pressed
    end

    if (ctrl_down and shift_down and panic_down) then
        windower.send_command("lua reload kanakanaa")
    end

    -- allow game commands to be typed regardless of kana mode, but restore kana mode afterward if it's on
    if (kana_mode and dik == keymap.slash and not shift_down) then
        should_restore_kana_mode_after_command = true
        kana_mode = false
        Ui.ModeIndicator.deactivate_kana_mode()
    end

    local should_display = (#pending_buffer > 0 or #romaji_buffer > 0 or #keystroke_buffer > 0) and kana_mode
    Ui.display(should_display)

    if (kana_mode and windower.chat.is_open()) then
        Ui.show_chat_bg()
    else
        Ui.hide_chat_bg()
    end

    if (not kana_mode and dik == keymap.enter) then
        if (pressed) then
            last_chat_text = windower.chat.get_input()
        else
            new_line = last_chat_text == windower.chat.get_input()
            last_chat_text = ""
        end
    end

    if (pressed and not kana_mode and should_restore_kana_mode_after_command) then
        local chat_input = windower.chat.get_input()

        local clearing_chat_input = dik == keymap.escape or dik == keymap.enter
        local deleting_leading_slash = dik == keymap.backspace and #chat_input == 1
        local starting_chat_command = dik == keymap.spacebar and chatmodes.has_mode_prefix(chat_input)


        if (clearing_chat_input or deleting_leading_slash or starting_chat_command) then
            if (starting_chat_command) then
                local chat_command, message_body = chatmodes.split_prefix(chat_input)
                flush_chat_text_to_pending_buffer()
                list.append(pending_buffer, " ")
                move_pending_offset_right(1)

                chat_mode_input = chat_command .. " "
                if (chat_mode_input ~= " ") then
                    windower.chat.set_input(chat_mode_input)
                else
                    chat_mode_input = ""
                end
                Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
            else
                chat_mode_input = ""
            end

            kana_mode = true
            should_restore_kana_mode_after_command = false
            Ui.ModeIndicator.activate_kana_mode()
            return starting_chat_command
        end
    end

    -- handle toggling the IME
    if (pressed and shift_down and dik == keymap.spacebar) then
        kana_mode = not kana_mode
        if (kana_mode) then
            Ui.ModeIndicator.activate_kana_mode()
            flush_chat_text_to_pending_buffer()
        else
            Ui.ModeIndicator.deactivate_kana_mode()
            flush_pending_buffer_to_chat_text()
        end
        return windower.chat.is_open() -- call it handled if chat is already open
    elseif (kana_mode and pressed) then
        -- ESCAPE KEY: Clear all buffers and hide UI
        if (dik == keymap.escape) then
            clear_buffers()
            chat_mode_input = ""
            Ui.update_autocomplete(romaji_buffer)
            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
            Ui.display(false)
            return true -- doesn't count as handled for Escape for some reason
        end

        -- ENTER KEY: Input buffer text, then clear all buffers
        if (dik == keymap.enter) then
            local insertion_buffer = get_insertion_buffer()
            local preview_buffer = ""

            for i, val in ipairs(pending_buffer) do
                preview_buffer = preview_buffer .. val
            end

            windower.chat.input(windower.to_shift_jis(preview_buffer .. insertion_buffer.text))
            windower.chat.set_input("")

            most_recent_parts_of_speech = {}
            clear_buffers()
            chat_mode_input = ""
            Ui.update_autocomplete(romaji_buffer)
            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
            return true
        end

        -- SPACEBAR: Add autocomplete text to pending buffer, then clear keystroke and romaji buffers
        if (dik == keymap.spacebar and (((not autotranslate_mode) and #romaji_buffer > 0) or (autotranslate_mode and #keystroke_buffer > 0))) then
            local insertion_buffer = get_insertion_buffer()

            if (autotranslate_mode) then
                autotranslate_mode = false
                merge_into_pending_buffer(L{insertion_buffer.text}, pending_insertion_offset)
                move_pending_offset_right(1)
            else
                local exploded_insertion_buffer = utf8slim.explode(insertion_buffer.text)
                merge_into_pending_buffer(exploded_insertion_buffer, pending_insertion_offset)
                move_pending_offset_right(#exploded_insertion_buffer)
            end

            most_recent_parts_of_speech = insertion_buffer.pos or {}
            clear_keystroke_buffer()
            clear_romaji_buffer()
            Ui.reset_selection()
            Ui.update_autocomplete(romaji_buffer)
            Ui.update_autotranslate(keystroke_buffer)
            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)

            -- open the chat if it's closed, but prevent a space character from being inserted if it's open
            return windower.chat.is_open()
        elseif (dik == keymap.spacebar) then
            if (windower.chat.is_open()) then
                list.append(pending_buffer, "　")
                move_pending_offset_right(1)
                Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
            end
            return windower.chat.is_open()
        end

        -- TAB KEY: Open autotranslate menu
        if (dik == keymap.tab) then
            -- first, insert whatever was already selected
            local insertion_buffer = get_insertion_buffer()
            merge_into_pending_buffer(L{insertion_buffer.text}, pending_insertion_offset)
            move_pending_offset_right(1)

            most_recent_parts_of_speech = insertion_buffer.pos or {}
            clear_keystroke_buffer()
            clear_romaji_buffer()
            Ui.reset_selection()

            if (not autotranslate_mode) then
                keystroke_buffer = AUTOTRANSLATE_MESSAGE
            end

            Ui.update_autocomplete(romaji_buffer)
            Ui.update_autotranslate(keystroke_buffer)
            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)

            autotranslate_mode = not autotranslate_mode

            return true
        end

        -- UP ARROW KEY/DOWN ARROW KEY: Cycle through autocomplete selections
        if (dik == keymap.up_arrow) then
            if ((not autotranslate_mode) and #romaji_buffer > 0 or autotranslate_mode and #keystroke_buffer > 0) then
                Ui.move_selection_up()

                Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
            end

            -- prevent accidentally cycling through old chat text
            return true
        end
        if (dik == keymap.down_arrow) then
            if ((not autotranslate_mode) and #romaji_buffer > 0 or autotranslate_mode and #keystroke_buffer > 0) then
                Ui.move_selection_down()

                Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
            end

            -- prevent accidentally cycling through old chat text
            return true
        end

        -- LEFT ARROW KEY/RIGHT ARROW KEY: Move the text cursor
        if (dik == keymap.left_arrow and should_display) then
            move_cursor_left()

            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)

            return true
        end
        if (dik == keymap.right_arrow and should_display) then
            move_cursor_right()

            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)

            return true
        end

        -- HOME KEY: Move cursor to the beginning of the line. Clear the keystroke buffer, and autoinsert the current autocomplete selection
        if (dik == keymap.home) then
            merge_autocomplete()
            pending_insertion_offset = 0

            Ui.reset_selection()
            Ui.update_autocomplete(romaji_buffer)
            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
            return true
        end

        -- END KEY: Move cursor to the end of the line. Clear the keystroke buffer, and autoinsert the current autocomplete selection
        if (dik == keymap["end"]) then -- end is a reserved word in LUA, so we can't use dot notation
            merge_autocomplete()
            pending_insertion_offset = #pending_buffer + 1

            Ui.reset_selection()
            Ui.update_autocomplete(romaji_buffer)
            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
            return true
        end

        -- BACKSPACE KEY: Delete the character immediately before the cursor
        if (dik == keymap.backspace) then
            return handle_backspace()
        end

        -- DELETE KEY: Delete the character immediately after the cursor
        if (dik == keymap.delete) then
            return handle_delete()
        end

        local keystroke = nil
        if (autotranslate_mode) then
            handle_autotranslate(dik)
        else
            keystroke = handle_kana_input(dik)
        end

        Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
        -- hack to fix text offsets because the chat_text size hasn't been determined yet
        coroutine.schedule((function() Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset) end), 0.1)        

        return windower.chat.is_open()
    end
end)

function handle_autotranslate(dik)
    if (keymap.is_letter(dik) or keymap.is_autotranslate_punctuation(dik)) then
        if (keystroke_buffer == AUTOTRANSLATE_MESSAGE) then
            keystroke_buffer = ""
        end

        if (keymap.is_letter(dik)) then
            local letter = keymap.get_letter(dik, shift_down)
            keystroke_buffer = keystroke_buffer .. letter
        end

        if (keymap.is_autotranslate_punctuation(dik)) then
            local punct = keymap.get_autotranslate_punctuation(dik)
            keystroke_buffer = keystroke_buffer .. punct
        end

        move_keystroke_offset_right()
        Ui.update_autotranslate(keystroke_buffer)
    end
end

function handle_kana_input(dik)
    -- Get the keystroke, if valid
    local keystroke = nil
    if (shift_down) then
        keystroke = keymap.shiftmap[dik]
    else
        keystroke = keymap[dik]
    end

    if (chat_mode_input ~= "") then
        windower.chat.set_input(chat_mode_input)
    else
        windower.chat.set_input("")
    end

    -- Handle "nn" => "ん", "nde" => "んで", and "tte" => "って"
    if (keystroke ~= nil and (keystroke_buffer .. keystroke) == "nn") then
        if (Ui.selected_index == 1) then
            merge_into_romaji_buffer("nn", romaji_insertion_offset)
            move_romaji_offset_right()
            Ui.update_autocomplete(romaji_buffer)
        end
        
        clear_keystroke_buffer()
        Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
        return true
    elseif (keystroke_buffer == "n" and (is_valid_consonant(keystroke) or is_valid_punctuation(keystroke))) then
        if (Ui.selected_index == 1) then
            merge_into_romaji_buffer("nn", romaji_insertion_offset)
            move_romaji_offset_right()
            Ui.update_autocomplete(romaji_buffer)
        end

        clear_keystroke_buffer()
        Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
    elseif (keystroke_buffer == keystroke and is_valid_consonant(keystroke)) then
        if (Ui.selected_index == 1) then
            merge_into_romaji_buffer("xtsu", romaji_insertion_offset)
            move_romaji_offset_right()
            Ui.update_autocomplete(romaji_buffer)
        end

        clear_keystroke_buffer()
        Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
    end

    -- Handle all other valid keystrokes
    if (keystroke ~= nil) then
        if (keystroke ~= "\"") then
            keystroke_buffer = keystroke_buffer .. keystroke
            move_keystroke_offset_right()
        end

        local output = hiragana[keystroke_buffer]
        if (output ~= nil or keystroke == "\"") then
            if (Ui.selected_index > 1 or is_valid_punctuation(keystroke)) then
                local merged_buffer = ""

                local autocomplete_entry = Ui.get_selected_autocomplete_entry()
                if (autocomplete_entry ~= nil) then
                    merged_buffer = autocomplete_entry.text
                end

                if (is_valid_punctuation(keystroke)) then
                    if (keystroke == "\"") then
                        merged_buffer = merged_buffer .. get_quotation_mark()
                    else
                        merged_buffer = merged_buffer .. output
                    end

                    most_recent_parts_of_speech = {}
                    most_recent_parts_of_speech.prt = true
                else
                    if (autocomplete_entry ~= nil) then
                        most_recent_parts_of_speech = autocomplete_entry.parts_of_speech or {}
                    end
                end

                local exploded_merged_buffer = utf8slim.explode(merged_buffer)
                merge_into_pending_buffer(exploded_merged_buffer, pending_insertion_offset)
                move_pending_offset_right(#exploded_merged_buffer)

                clear_romaji_buffer()

                Ui.reset_selection()
            end

            local hiragana_buffer = hiragana.from_romaji(romaji_buffer)
            local maybe_output = nil
            if (not (is_valid_punctuation(keystroke))) then
                maybe_output = hiragana.from_romaji({keystroke_buffer})
            end

            if (should_split_connector(hiragana_buffer, maybe_output, most_recent_parts_of_speech)) then
                local exploded_hiragana_buffer = utf8slim.explode(hiragana_buffer)
                merge_into_pending_buffer(exploded_hiragana_buffer, pending_insertion_offset)
                move_pending_offset_right(#exploded_hiragana_buffer)

                clear_romaji_buffer()
            end

            if (not (is_valid_punctuation(keystroke))) then
                local split_keystroke_buffer = hiragana.maybe_split_compound_character(keystroke_buffer)
                for i, romaji in ipairs(split_keystroke_buffer) do
                    merge_into_romaji_buffer(romaji, romaji_insertion_offset)
                    move_romaji_offset_right()
                end
            end

            clear_keystroke_buffer()

            Ui.reset_selection_to_kana()
            Ui.update_autocomplete(romaji_buffer)
        elseif (Ui.selected_index > 1) then
            local autocomplete_entry = Ui.get_selected_autocomplete_entry()
            if (autocomplete_entry ~= nil) then
                local autocomplete_buffer = utf8slim.explode(autocomplete_entry.text)
                merge_into_pending_buffer(autocomplete_buffer, pending_insertion_offset)
                move_pending_offset_right(#autocomplete_buffer)
            end
            
            if (autocomplete_entry ~= nil) then
                most_recent_parts_of_speech = autocomplete_entry.parts_of_speech or {}
            end

            clear_romaji_buffer()

            Ui.reset_selection()
            Ui.update_autocomplete(romaji_buffer)
        end
    elseif (shift_down and (keymap.is_fullwidth_letter(dik) or keymap.is_number(dik))) then
        if (keymap.is_fullwidth_letter(dik)) then
            merge_into_romaji_buffer(keymap.get_fullwidth_letter(dik), romaji_insertion_offset)
        elseif (keymap.is_number(dik)) then
            merge_into_romaji_buffer(keymap.get_number(dik), romaji_insertion_offset)
        end
        move_pending_offset_right(1)

        Ui.update_autocomplete(romaji_buffer)

        move_cursor_right()
    end

    return keystroke
end

-- Gets the correct quotation mark based on the most recent preceding quotation mark
function get_quotation_mark()
    local is_quote_open = false

    for i, character in ipairs(pending_buffer) do
        if (character == "「") then
            is_quote_open = true
        elseif (character == "」") then
            is_quote_open = false
        end
    end

    local autocomplete_entry = Ui.get_selected_autocomplete_entry().text
    if (autocomplete_entry ~= nil) then
        for i, character in ipairs(utf8slim.explode(autocomplete_entry)) do
            if (character == "「") then
                is_quote_open = true
            elseif (character == "」") then
                is_quote_open = false
            end
        end
    end

    if (is_quote_open) then
        return "」"
    else
        return "「"
    end
end

function flush_chat_text_to_pending_buffer()
    if (new_line) then
        windower.chat.set_input("")
        new_line = false
    else
        local raw_chat_text, raw_cursor_pos = windower.chat.get_input()

        if (raw_chat_text ~= nil and raw_chat_text ~= "") then
            windower.chat.set_input("")
            local new_pending_buffer = L{}
            local cursor_bytes_so_far = 1

            for i, raw_character in ipairs(utf8slim.explode(raw_chat_text)) do
                cursor_bytes_so_far = cursor_bytes_so_far + utf8slim.get_char_bytelength(raw_character)
                if (cursor_bytes_so_far == raw_cursor_pos) then
                    pending_insertion_offset = i
                end
                list.append(new_pending_buffer, windower.from_shift_jis(raw_character))
            end

            for i, character in ipairs(pending_buffer) do
                list.append(new_pending_buffer, character)
            end

            pending_buffer = new_pending_buffer
            Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
        end
    end
end

function flush_pending_buffer_to_chat_text()
    local transfer_buffer = ""
    local cursor_bytes_so_far = 1
    for i, character in ipairs(pending_buffer) do
        transfer_buffer = transfer_buffer .. character
    end
    local insertion_buffer = get_insertion_buffer()
    if (insertion_buffer ~= nil) then
        transfer_buffer = transfer_buffer .. insertion_buffer.text
    end

    local cursor_pos = pending_insertion_offset + romaji_insertion_offset + keystroke_insertion_offset + 1

    for i, character in ipairs(utf8slim.explode(transfer_buffer)) do
        if (i < cursor_pos) then
            cursor_bytes_so_far = cursor_bytes_so_far + utf8slim.get_char_bytelength(windower.to_shift_jis(character))
        end
    end

    windower.chat.set_input(windower.to_shift_jis(transfer_buffer), cursor_bytes_so_far)
    clear_buffers()
    Ui.update_autocomplete(romaji_buffer)
    Ui.update(keystroke_buffer, romaji_buffer, pending_buffer, pending_insertion_offset, romaji_insertion_offset, keystroke_insertion_offset)
end

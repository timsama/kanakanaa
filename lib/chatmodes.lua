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
require("tables")

local strings = require("strings")

local ChatModes = {}

local ChatModePrefixes = T{
    ["/l"] = true,
    ["/l2"] = true,
    ["/linkshell"] = true,
    ["/linkshell2"] = true,
    ["/lsmes"] = true,
    ["/ls2mes"] = true,
    ["/p"] = true,
    ["/party"] = true,
    ["/s"] = true,
    ["/say"] = true,
    ["/sh"] = true,
    ["/shout"] = true,
    ["/yell"] = true,
    ["/echo"] = true,
}

ChatModes.has_mode_prefix = (function(chat_string)
    local words = chat_string:split(" ")
    local has_prefix = ChatModePrefixes[words[1]] ~= nil

    if (has_prefix) then
        return true
    end

    local is_tell = words[1] == "/tell" or words[1] == "/t"
    local is_tell_directed = #words >= 2

    if (is_tell and is_tell_directed) then
        return true
    end

    return false
end)

ChatModes.split_prefix = (function(chat_string)
    local words = chat_string:split(" ")
    local has_prefix = ChatModePrefixes[words[1]] ~= nil

    if (has_prefix) then
        local prefix = words[1]
        return prefix, chat_string:gsub(prefix .. " ", "", 1)
    end

    local is_tell = words[1] == "/tell" or words[1] == "/t"
    local is_tell_directed = #words >= 2

    if (is_tell and is_tell_directed) then
        local tell_command = words[1]
        local recipient = words[2]
        local prefix = tell_command .. " " .. recipient
        return prefix, chat_string:gsub(prefix .. " ", "", 1)
    end

    return "", chat_string
end)

return ChatModes

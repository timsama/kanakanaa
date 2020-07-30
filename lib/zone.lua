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

local packets = require("packets")
require("tables")

local callback = require("lib/callback")

local zone = {}

zone.register_event = (function(name, func)
    return callback.register(name, func)
end)

zone.unregister_event = (function(name, id)
    return callback.unregister(name, id)
end)

windower.register_event("outgoing chunk", function(id, original, modified, injected, blocked)
    if (not blocked) then
        -- crossing zone line
        if (id == 0x05E) then
            callback.execute("on leave")
        end

        -- Temporarily commented out until I can determine why it doesn't come back after zoning
        -- -- warp request (NPC or Door/Gate/Homepoint/Waypoint)
        -- if (id == 0x05C) then
        --     callback.execute("on leave")
        -- end

        -- entering zone
        if (id == 0x00C) then
            callback.execute("on enter")
        end
    end
end)

return zone

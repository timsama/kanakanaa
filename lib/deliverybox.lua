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

local deliverybox = {}

deliverybox.register_event = (function(name, func)
    return callback.register(name, func)
end)

deliverybox.unregister_event = (function(name, id)
    return callback.unregister(name, id)
end)

windower.register_event("incoming chunk", function(id, original, modified, injected, blocked)
    if (not injected and id == 0x04B) then
        local packet = packets.parse("incoming", original)

        if (packet["Type"] == 0x0D) then
            callback.execute("on open")
            callback.execute("on open send")
        elseif (packet["Type"] == 0x0E) then
            callback.execute("on open")
            callback.execute("on open receive")
        elseif (packet["Type"] == 0x0F) then
            callback.execute("on close")
        end
    end
end)

return deliverybox

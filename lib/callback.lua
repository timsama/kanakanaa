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

local callback = {}

local registered_callbacks = {}

callback.register = (function(name, func)
    local id = nil
    if (registered_callbacks[name] == nil) then
        registered_callbacks[name] = {}
        registered_callbacks[name].next_id = 1
        registered_callbacks[name].listeners = {}
    end

    id = registered_callbacks[name].next_id
    registered_callbacks[name].listeners[id] = func

    registered_callbacks[name].next_id = registered_callbacks[name].next_id + 1

    return id
end)

callback.unregister = (function(name, id)
    if (registered_callbacks[name] ~= nil) then
        registered_callbacks[name].listeners[id] = nil
        return true
    end

    return false
end)

callback.execute = (function(name)
    if (registered_callbacks[name] ~= nil) then
        for i, func in pairs(registered_callbacks[name].listeners) do
            func()
        end
    end
end)

return callback

--[[@diagnostic disable:duplicate-set-field]]

--- Wrapper for Love2D.
-- @module lpresence.love

--- Shortcut to this module. Exported to 'love' namespace.
-- @type love.rpc

if not love then
    error("This module is intended for Love2D!")
end

love.rpc = {
    initialized = false,
}

local signals = {
    CONNECT = 1,
    CLOSE = 2,
    UPDATE = 3,
    CLEAR = 4,
}
local chunk = [=[
local RPC = require("lpresence").RPC
local ffi = require("ffi")

local getpid
if ffi.os == "Windows" then
    ffi.cdef[[
    uint32_t GetCurrentProcessId();
    ]]
    getpid = ffi.load("kernel32.dll").GetCurrentProcessId
else
    ffi.cdef[[
    int getpid();
    ]]
    getpid = ffi.C.getpid
end

local signals = {
    CONNECT = 1,
    CLOSE = 2,
    UPDATE = 3,
    CLEAR = 4,
}
local rpc_channel = love.thread.getChannel("RPCData")

local rpc = RPC("%s")

while 1 do
    local signal = rpc_channel:demand()

    if signal == signals.CONNECT then
        rpc:connect()
    elseif signal == signals.CLOSE then
        rpc:close()
        break
    elseif signal == signals.UPDATE then
        rpc:update(rpc_channel:demand(), getpid())
    elseif signal == signals.CLEAR then
        rpc:clear(getpid())
    end
end
]=]
local rpc_channel = love.thread.getChannel("RPCData")

--- Initialize RPC thread.
-- @param[type=string] application_id [Application ID](https://en.wikipedia.org/wiki/Snowflake_ID)
function love.rpc.init(application_id)
    if love.rpc.initialized then error("RPC thread has already been initialized") end

    love.rpc.initialized = true

    local thread = love.thread.newThread(chunk:format(application_id))
    thread:start()
    love.rpc.thread = thread
end

--- Connect to the Rich Presence.
function love.rpc.connect()
    if not love.rpc.initialized then error("RPC thread hasn't been initialized yet") end
    rpc_channel:push(signals.CONNECT)
end

--- Update Rich Presence.
-- @param[type=table] activity [Activity](https://discord.com/developers/docs/topics/gateway-events#activity-object) object
function love.rpc.update(activity)
    if not love.rpc.initialized then error("RPC thread hasn't been initialized yet") end
    rpc_channel:push(signals.UPDATE)
    rpc_channel:push(activity)
end

--- Clear Rich Presence.
function love.rpc.clear()
    if not love.rpc.initialized then error("RPC thread hasn't been initialized yet") end
    rpc_channel:push(signals.CLEAR)
end

--- Close connection to Rich Presence.
--- Also close thread holding the connection.
function love.rpc.close()
    if not love.rpc.initialized then error("RPC thread hasn't been initialized yet") end
    rpc_channel:push(signals.CLOSE)
    love.rpc.thread:wait()
    love.rpc.thread:release()
    love.rpc.initialized = false
end

return love.rpc

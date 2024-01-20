love.rpc = {
    initialized = false
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
    elseif signal == signals.UPDATE then
        rpc:update(rpc_channel:demand(), getpid())
    elseif signal == signals.CLEAR then
        rpc:clear(getpid())
    end
end
]=]
local rpc_channel = love.thread.getChannel("RPCData")

---@param application_id lpresence.snowflake
---@return boolean ok
--
-- Initialize RPC thread.
--
function love.rpc.init(application_id)
    if love.rpc.initialized then
        error("RPC thread has already been initialized")
    end

    love.rpc.initialized = true

    local thread = love.thread.newThread(chunk:format(application_id))
    thread:start()
    love.rpc.thread = thread

    return true
end

-- 
-- Connect to the Rich Presence.
--
function love.rpc.connect()
    rpc_channel:push(signals.CONNECT)
end

---@param activity lpresence.Activity
--
-- Update Rich Presence.
--
function love.rpc.update(activity)
    rpc_channel:push(signals.UPDATE)
    rpc_channel:push(activity)
end

function love.rpc.clear()
    rpc_channel:push(signals.CLEAR)
end

function love.rpc.close()
    rpc_channel:push(signals.CLOSE)
    love.rpc.thread:wait()
    love.rpc.thread:release()
end

return love.rpc

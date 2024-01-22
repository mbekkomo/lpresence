---@meta

love.rpc = {
    initialized = false,
}

---@param application_id lpresence.snowflake
---@return boolean ok
--
-- Initialize RPC thread.
--
function love.rpc.init(application_id) end

--
-- Connect to the Rich Presence.
--
function love.rpc.connect() end

---@param activity lpresence.Activity
--
-- Update Rich Presence.
--
function love.rpc.update(activity) end

--
-- Clear Rich Presence.
--
function love.rpc.clear() end

--
-- Close connection to Rich Presence.
-- Also close thread holding the connection.
--
function love.rpc.close() end

return love.rpc

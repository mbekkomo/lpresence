---@meta

---@class lpresence.BaseClient_params
---@field client_id lpresence.snowflake The OAuth2 Client ID
---@field timeout integer? Poll timeout in miliseconds (POSIX only)
---@field pipe integer? An ID for the IPC, e.g `discord-ipc-{pipe}`

---@class lpresence.BaseClient
---@overload fun(params: lpresence.snowflake|lpresence.BaseClient_params): lpresence.BaseClient
--
-- Base class.
--
local BaseClient = {}

---@return table
-- 
-- Read the payload and return as table.
function BaseClient:read()
end

---@param op integer
---@param payload table
--
-- Send a payload with op code.
--
function BaseClient:send(op, payload)
end

--
-- Initialize connection.
--
function BaseClient:handshake()
end

return BaseClient

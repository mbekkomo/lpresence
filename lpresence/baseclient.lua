-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

local error_kind = require("lpresence.error_kind")
local utils = require("lpresence.utils")

local class = require("classy")
local json = require("cjson")
local vstruct
if not (string.pack and string.unpack) then vstruct = require("vstruct") end
local winapi, socket
if utils.on_windows then
    winapi = require("winapi")
else
    socket = require("cqueues.socket")
end

---@class lpresence.BaseClient_params
---@field client_id lpresence.snowflake The OAuth2 Client ID
---@field timeout integer? Poll timeout in miliseconds (POSIX only)
---@field pipe integer? An ID for the IPC, e.g `discord-ipc-{pipe}`

---@class lpresence.BaseClient
---@overload fun(params: lpresence.snowflake|lpresence.BaseClient_params): lpresence.BaseClient
local BaseClient = class "BaseClient"

function BaseClient:__init(params)
    if type(params) == "table" then
        self.client_id = tostring(params.client_id)
        self.timeout = params.timeout
        self.pipe = params.pipe
    else
        self.client_id = tostring(params)
    end
end

---@return table
function BaseClient:read()
    local preamble = self.sock:read(8)
    local length
    if vstruct then
        _, length = vstruct.readvals("<(2*u4)", preamble)
    else
        _, length = string.unpack("<II", preamble)
    end
    local payload = json.decode(self.sock:read(length))

    if payload.evt == "ERROR" then error(error_kind.server_error(payload.data.message)) end
    return payload
end

---@param op integer
---@param payload table
function BaseClient:send(op, payload)
    local json_payload = json.encode(payload)

    assert(self.sock, "You'll to connect your client before sending events")

    local data
    if vstruct then
        data = vstruct.write("<(2*u4)", { op, #json_payload })
    else
        data = string.pack("<II", op, #json_payload)
    end

    self.sock:write(data .. json_payload)
end

function BaseClient:handshake()
    local ipc_path = assert(utils.get_ipc_path(self.pipe), error_kind.invalid_path())

    if not utils.on_windows then
        local s = assert(socket.connect { path = ipc_path }, error_kind.invalid_pipe())

        s:settimeout(self.timeout)
        assert(s:connect(), error_kind.timed_out())

        self.sock = s
    elseif winapi then
        local pipe = assert(winapi.open_pipe(ipc_path), error_kind.invalid_pipe())

        self.sock = pipe
    end

    self:send(0, { v = 1, client_id = self.client_id })
    local preamble = self.sock:read(8)
    local length
    if vstruct then
        _, length = vstruct.readvals("<(2*i4)", preamble)
    else
        _, length = string.unpack("<ii", preamble)
    end
    local data = json.decode(self.sock:read(length))

    if data.code then
        if data.code == 4000 then error(error_kind.invalid_client_id(self.client_id)) end
        error(error_kind.handshake_failed(data.code, data.message))
    end
end

return BaseClient

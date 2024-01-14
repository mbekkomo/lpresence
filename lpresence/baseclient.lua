-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

local class = require("classy")
local copas = require("copas")
local json = require("cjson")
local utils = require("lpresence.utils")
local vstruct = require("lpresence.vstruct")
local winapi = require("lpresence.winapi")
local Payloads = require("lpresence.payloads")


---@class lpresence.BaseClient_params
---@field client_id lpresence.discord_id
---@field loop fun(...): ...
---@field timeout integer
---@field pipe integer

---@class lpresence.BaseClient
---@overload fun(params: lpresence.discord_id|lpresence.BaseClient_params): lpresence.BaseClient
local BaseClient = class "BaseClient"

function BaseClient:__init(params)
    if type(params) == "table" then
        self.client_id = tostring(params[1])
        self.loop = params.loop
        self.timeout = params.timeout
        self.pipe = params.pipe
    else
        self.client_id = tostring(params)
    end
end

function BaseClient:_sread(n)
    local d
    if utils.on_windows then
        copas.timeout(self.timeout, self.to_handler)
        d = self.sock:read(n)
        copas.timeout(0)
    else
        d = copas.receive(self.sock, n)
    end
    return d
end

function BaseClient:_swrite(d)
    if utils.on_windows then
        copas.timeout(self.timeout, self.to_handler)
        self.sock:write(d)
        copas.timeout(0)
    else
        copas.send(self.sock, d)
    end
end

function BaseClient:_sclose()
    if not utils.on_windows then
        self.sock:shutdown()
    end
    self.sock:close()
end

---@return table
function BaseClient:read()
    local preamble = self:_sread(8)
    local length
    if vstruct then
        _, length = vstruct.readvals("<(2*u4)", preamble)
    else
        _, length = string.unpack("<II", preamble)
    end
    local p = self:_sread(length)
    local payload = json.decode(p)

    if payload.evt == "ERROR" then error("Server returned an error: " .. payload.data.message) end
    return payload
end

---@param op integer
---@param payload table
function BaseClient:send(op, payload)
        if class.is_a(payload, Payloads) then payload = payload.data end
        local json_payload = json.encode(payload)

        assert(self._swrite, "You must connect before sending events")

        local data
        if vstruct then
            data = vstruct.write("<(2*u4)", { op, #json_payload })
        else
            data = string.pack("<II", op, #json_payload)
        end

        self:_swrite(data .. json_payload)
end

function BaseClient:handshake()
    local ipc_path = assert(utils.get_ipc_path(self.pipe), "Unable to find Discord IPC path")

    if not utils.on_windows then
        local unix_socket = require("socket.unix")
        local s = assert(unix_socket())

        copas.settimeout(s, self.timeout)

        assert(copas.connect(s, ipc_path))

        self.sock = s
    elseif winapi then
        local p = assert(winapi.open_pipe(ipc_path), "Unable to open Discord IPC pipe")

        function self.to_handler()
            p:close()
        end

        self.sock = p
    end

    self:send(0, { v = 1, client_id = self.client_id })
    local preamble = self:_sread(8)
    local length
    if vstruct then
        _, length = vstruct.readvals("<(2*i4)", preamble)
    else
        _, length = string.unpack("<ii", preamble)
    end
    local p = self:_sread(length)
    local data = json.decode(p)

    if data.code then error(("Error: [%d] %s"):format(data.code, data.message)) end
end

return BaseClient

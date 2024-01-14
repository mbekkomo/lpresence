-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

local class = require("classy")
local copas = require("copas")
local json = require("cjson")
local utils = require("lpresence.utils")

local Payloads = require("lpresence.payloads")

---@diagnostic disable-next-line:unused-local
local vstruct_ok, vstruct = pcall(require, "vstruct")
if not (string.pack and string.unpack) and not vstruct_ok then
    error(
        "vstruct is required on Lua environment that doesn't support string.{,un}pack (i.e before Lua 5.3), see https://github.com/toxicfrog/vstruct/#31-installation"
    )
end

---@diagnostic disable-next-line:unused-local
local winapi_ok, winapi = pcall(require, "winapi")
if utils.on_windows and not winapi_ok then
    error("winapi is required on Windows platform to run lpresence, see https://stevedonovan.github.io/winapi")
end

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

function BaseClient:read()
    local preamble = self.sread(8)
    local length
    if vstruct_ok then
        _, length = vstruct.readvals("<(2*u4)", preamble:sub(8))
    else
        _, length = string.unpack("<II", preamble:sub(8))
    end
    local p = self.sread(length)
    local data = json.decode(p)

    local payload = json.decode(data)
    if payload.evt == "ERROR" then error("Server returned an error: " .. payload.data.message) end
    return payload
end

function BaseClient:send(op, payload)
    if class.is_a(payload, Payloads) then payload = payload.data end
    payload = json.encode(payload)

    assert(self.swrite, "You must connect before sending events")

    local data
    if vstruct_ok then
        data = vstruct.write("<2*u4", { op, #payload })
    else
        data = string.pack("<II", op, #payload)
    end

    self.swrite(data .. payload)
end

function BaseClient:handshake()
    local ipc_path = assert(utils.get_ipc_path(self.pipe), "Unable to find Discord IPC path")

    copas.addthread(function()
        if not utils.on_windows then
            local unix_socket = require("socket.unix")
            local s = assert(unix_socket())

            copas.settimeout(s, self.timeout)

            assert(copas.connect(s, ipc_path))

            function self.sread(n)
                return assert(copas.receive(s, n))
            end
            function self.swrite(d)
                return assert(copas.send(s, d))
            end
        else
            local p = assert(winapi.open_pipe(ipc_path), "Unable to open Discord IPC pipe")

            local function to_handler()
                p:close()
            end

            function self.sread(n)
                copas.timeout(self.timeout, to_handler)
                local d = assert(p:read(n))
                copas.timeout(0)
                return d
            end
            function self.swrite(d)
                copas.timeout(self.timeout, to_handler)
                assert(p:write(d))
                copas.timeout(0)
            end
        end

        self:send(0, { v = 1, client_id = self.client_id })
        local preamble = self.sread(8)
        local code, length
        if vstruct_ok then
            code, length = vstruct.readvals("<(2*i4)", preamble)
        else
            code, length = string.unpack("<ii", preamble)
        end
        local p = self.sread(length)
        local data = json.decode(p)

        if data.code then error(("Error: [%d] %s"):format(data.code, data.message)) end
    end)
end

return BaseClient

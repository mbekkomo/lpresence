-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

--- API wrapper for IPC connection
-- @module lpresence.client

--
-- TODO: Allow to subscribe to an event (`on`, `off` and `event_emit` methods).
--

local BaseClient = require("lpresence.baseclient")
local payloads = require("lpresence.payloads")
local utils = require("lpresence.utils")

local class = require("classy")

local Client = class("Client", BaseClient)

function Client:__init(params)
    BaseClient.__init(self, params)
    self._closed = false
    self._registered_events = {}
end

function Client:connect()
    self:handshake()
end

function Client:close()
    self:send(2, { v = 1, client_id = self.client_id })
    if not utils.on_windows then self.sock:shutdown("rw") end
    self.sock:close()
    self._closed = true
end

function Client:authorize(client_id, scopes)
    local payload = payloads.authorize(client_id, scopes)
    self:send(1, payload)
    return self:read().data.code
end

function Client:authenticate(token)
    local payload = payloads.authenticate(token)
    self:send(1, payload)
    return self:read().data
end

function Client:get_guild(id)
    local payload = payloads.get_guild(id)
    self:send(1, payload)
    return self:read().data
end

function Client:get_guilds()
    local payload = payloads.get_guilds()
    self:send(1, payload)
    return self:read().data
end

function Client:get_channel(id)
    local payload = payloads.get_channel(id)
    self:send(1, payload)
    return self:read().data
end

function Client:get_channels(id)
    local payload = payloads.get_channels(id)
    self:send(1, payload)
    return self:read().data
end

function Client:set_user_voice_settings(user_id, pan_left, pan_right, volume, mute)
    local payload = payloads.set_user_voice_settings(user_id, pan_left, pan_right, volume, mute)
    self:send(1, payload)
    return self:read().data
end

function Client:select_voice_channel(id)
    local payload = payloads.select_text_channel(id)
    self:send(1, payload)
    return self:read().data
end

function Client:get_selected_voice_channel()
    local payload = payloads.get_selected_voice_channel()
    self:send(1, payload)
    return self:read().data
end

function Client:select_text_channel(id)
    local payload = payloads.select_text_channel(id)
    self:send(1, payload)
    return self:read().data
end

function Client:get_voice_settings()
    local payload = payloads.get_voice_settings()
    self:send(1, payload)
    return self:read().data
end

function Client:set_voice_settings(voice_settings)
    local payload = payloads.set_voice_settings(voice_settings)
    self:send(1, payload)
    return self:read().data
end

function Client:set_activity(activity, pid)
    local payload = payloads.set_activity(activity, pid)
    self:send(1, payload)
    return self:read().data
end

function Client:clear_activity(pid)
    local payload = payloads.set_activity(nil, pid)
    self:send(1, payload)
    return self:read().data
end

function Client:capture_screenshot(action)
    local payload = payloads.capture_shortcut(action)
    self:send(1, payload)
    return self:read().data
end

function Client:send_activity_join_invite(id)
    local payload = payloads.send_activity_join_invite(id)
    self:send(1, payload)
    return self:read().data
end

function Client:close_activity_request(id)
    local payload = payloads.close_activity_request(id)
    self:send(1, payload)
    return self:read().data
end

return Client

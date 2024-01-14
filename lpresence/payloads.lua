-- Enable compatibilty for Pluto 0.9.0+
-- @pluto_use class = false

local class = require("classy")
local json = require("cjson")
local socket = require("socket")

local table = table
if not table.pack then
    function table.pack(...) ---@diagnostic disable-line:duplicate-set-field
        local tbl = {}
        for i = 1, select("#", ...) do
            tbl[#tbl + 1] = select(i, ...)
        end
        return tbl
    end
end

---@alias lpresence.discord_id string|integer
---@alias lpresence.nested_table table<string, string|integer|number|boolean|table<string, lpresence.nested_table>>

---@class lpresence.Payloads
---@overload fun(data: lpresence.nested_table): lpresence.Payloads
local Payloads = class "Payloads"

function Payloads:__init(data)
    self.data = data
end

function Payloads:__tostring()
    return json.encode(self.data)
end

function Payloads:time()
    return ("%.20f"):format(socket.gettime())
end

---@param client_id lpresence.discord_id
---@param scopes string[]
---@return lpresence.Payloads
function Payloads:authorize(client_id, scopes)
    return Payloads {
        cmd = "AUTHORIZE",
        args = {
            client_id = tostring(client_id),
            scopes = scopes,
        },
        nonce = self:time(),
    }
end

---@param token string
---@return lpresence.Payloads
function Payloads:authenticate(token)
    return Payloads {
        cmd = "AUTHENTICATE",
        args = {
            access_token = token,
        },
        nonce = self:time(),
    }
end

---@param activity lpresence.nested_table?
---@param pid integer?
---@return lpresence.Payloads
function Payloads:set_activity(activity, pid)
    return Payloads {
        cmd = "SET_ACTIVITY",
        args = {
            pid = pid or table.concat(table.pack(_VERSION:sub(5, -1):byte(1, -1))), -- We can't have unique pid, we can only rely on _VERSION.
            activity = activity,
        },
        nonce = self:time(),
    }
end

---@return lpresence.Payloads
function Payloads:get_guilds()
    return Payloads {
        cmd = "GET_GUILDS",
        args = {},
        nonce = self:time(),
    }
end

---@param guild_id lpresence.discord_id
---@return lpresence.Payloads
function Payloads:get_guild(guild_id)
    return Payloads {
        cmd = "GET_GUILD",
        args = {
            guild_id = tostring(guild_id),
        },
        nonce = self:time(),
    }
end

---@param guild_id lpresence.discord_id
---@return lpresence.Payloads
function Payloads:get_channels(guild_id)
    return Payloads {
        cmd = "GET_CHANNELS",
        args = {
            guild_id = tostring(guild_id),
        },
        nonce = self:time(),
    }
end

---@param channel_id lpresence.discord_id
---@return lpresence.Payloads
function Payloads:get_channel(channel_id)
    return Payloads {
        cmd = "GET_CHANNEL",
        args = {
            channel_id = tostring(channel_id),
        },
        nonce = self:time(),
    }
end

---@param user_id lpresence.discord_id
---@param pan_left number?
---@param pan_right number?
---@param volume integer?
---@param mute boolean?
---@return lpresence.Payloads
function Payloads:set_user_voice_settings(user_id, pan_left, pan_right, volume, mute)
    return Payloads {
        cmd = "SET_USER_VOICE_SETTINGS",
        args = {
            user_id = tostring(user_id),
            pan = {
                left = pan_left,
                right = pan_right,
            },
            volume = volume,
            mute = mute,
        },
        nonce = self:time(),
    }
end

---@param channel_id lpresence.discord_id
---@return lpresence.Payloads
function Payloads:select_voice_channel(channel_id)
    return Payloads {
        cmd = "SELECT_VOICE_CHANNEL",
        args = {
            channel_id = tostring(channel_id),
        },
        nonce = self:time(),
    }
end

---@return lpresence.Payloads
function Payloads:get_selected_voice_channel()
    return Payloads {
        cmd = "GET_SELECTED_VOICE_CHANNEL",
        args = {},
        nonce = self:time(),
    }
end

---@param channel_id lpresence.discord_id
---@return lpresence.Payloads
function Payloads:select_text_channel(channel_id)
    return Payloads {
        cmd = "SELECT_TEXT_CHANNEL",
        args = {
            channel_id = channel_id,
        },
        nonce = self:time(),
    }
end

---@return lpresence.Payloads
function Payloads:get_voice_settings()
    return Payloads {
        cmd = "GET_VOICE_SETTINGS",
        args = {},
        nonce = self:time(),
    }
end

---@param voice_settings lpresence.nested_table?
---@return lpresence.Payloads
function Payloads:set_voice_settings(voice_settings)
    return Payloads {
        cmd = "SET_VOICE_SETTINGS",
        args = voice_settings or {},
        nonce = self:time(),
    }
end

---@param action string
---@return lpresence.Payloads
function Payloads:capture_shortcut(action)
    return Payloads {
        cmd = "CAPTURE_SHORTCUT",
        args = {
            action = action:upper(),
        },
        nonce = self:time(),
    }
end

---@param user_id lpresence.discord_id
---@return lpresence.Payloads
function Payloads:send_activity_join_invite(user_id)
    return Payloads {
        cmd = "SEND_ACTIVITY_JOIN_INVITE",
        args = {
            user_id = tostring(user_id),
        },
        nonce = self:time()
    }
end

---@param user_id lpresence.discord_id
---@return lpresence.Payloads
function Payloads:close_activity_request(user_id)
    return Payloads {
        cmd = "CLOSE_ACTIVITY_REQUEST",
        args = {
            user_id = tostring(user_id),
        },
        nonce = self:time()
    }
end

---@param event string
---@param args lpresence.nested_table?
---@return lpresence.Payloads
function Payloads:subscribe(event, args)
    return Payloads {
        cmd = "SUBSCRIBE",
        args = args or {},
        evt = event:upper(),
        nonce = self:time()
    }
end

---@param event string
---@param args lpresence.nested_table?
---@return lpresence.Payloads
function Payloads:unsubscribe(event, args)
    return Payloads {
        cmd = "UNSUBSCRIBE",
        args = args or {},
        evt = event:upper(),
        nonce = self:time(),
    }
end

return Payloads

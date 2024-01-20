---@meta

---@class lpresence.RPC : lpresence.BaseClient
---@overload fun(params: lpresence.snowflake|lpresence.BaseClient_params): lpresence.RPC
local RPC = {}

function RPC:__init(params)
end

---@see lpresence.RPC.handshake
--
-- Initialize RPC connection.
-- Equivalent to `RPC:handshake`.
--
function RPC:connect()
end

--
-- Close the RPC connection.
--
function RPC:close()
end

---@class lpresence.Activity
---@field name? string
---@field type? lpresence.Activity.type
---@field url? string?
---@field created_at? integer
---@field timestamps? lpresence.Activity.timestamps
---@field application_id? lpresence.snowflake
---@field details? string?
---@field state? string?
---@field emoji? lpresence.Activity.emoji?
---@field party? lpresence.Activity.party
---@field assets? lpresence.Activity.assets
---@field secrets? lpresence.Activity.secrets
---@field instance? boolean
---@field flags? lpresence.Activity.flags
---@field buttons? lpresence.Activity.button[]

---@alias lpresence.Activity.type
---| 0 # Game
---| 1 # Streaming
---| 2 # Listening
---| 3 # Watching
---| 4 # Custom
---| 5 # Competing

---@class lpresence.Activity.timestamps
---@field start? integer?
---@field end? integer?

---@class lpresence.Activity.emoji
---@field name string
---@field id? lpresence.snowflake
---@field animated? boolean

---@class lpresence.Activity.party
---@field id? string
---@field size? integer[]

---@class lpresence.Activity.assets
---@field large_image? string
---@field large_text? string
---@field small_image? string
---@field small_text? string

---@class lpresence.Activity.secrets
---@field join? string
---@field spectate? string
---@field match? string

---@alias lpresence.Activity.flags
---| 1 # INSTANCE
---| 2 # JOIN
---| 4 # SPECTATE
---| 8 # JOIN_REQUEST
---| 16 # SYNC
---| 32 # PLAY
---| 64 # PARTY_PRIVACY_FRIENDS
---| 128 # PARTY_PRIVACY_VOICE_CHANNEL
---| 256 # EMBEDDED

---@class lpresence.Activity.button
---@field label string
---@field url string

---@param activity lpresence.Activity
---@param pid? integer
---@return table response
--
-- Update rich presence.
--
function RPC:update(activity, pid)
end

---@param pid integer
---@return table response
--
-- Clear rich presence.
--
function RPC:clear(pid)
end

return RPC

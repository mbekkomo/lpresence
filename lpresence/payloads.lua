local class = require("classy")
local json = require("cjson")

local Payloads = class "Payload"

function Payloads:__init(data)
    self.data = data
end

function Payloads:__tostring()
    return json.encode(self.data)
end

function Payloads:time()
    return ("%.20f"):format(os.time())
end

function Payloads:authorize(client_id, scopes)
    return Payloads {
        cmd = "AUTHORIZE",
        args = {
            client_id = tostring(client_id),
            scopes = scopes
        },
        nonce = self:time()
    }
end

function Payloads:authenticate(token)
    return Payloads {
        cmd = "AUTHENTICATE",
        args = {
            access_token = token
        },
        nonce = self:time()
    }
end

return Payloads

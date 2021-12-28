local ngx = _G.ngx

local _M = {
    _VERSION = 0.1
}

_M.init = function (self)
end

_M.access = function (self)
    local d, err = require("resty.openssl.digest").new("sha256")
    d:update("🦢")
    local digest, err = d:final()
    ngx.say(ngx.encode_base64(digest))
end

return _M
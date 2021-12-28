local resty_sha256 = require "resty.sha256"
local resty_str = require "resty.string"


local ngx = _G.ngx
local escape_uri = ngx.escape_uri
local t_sort = table.sort
local lower = string.lower
local now = ngx.now

local _M = {}

local function get_query_string(query_string)
    local sorted_qps = t_sort(query_string)
    local final = ""
    for i, v in ipairs(sorted_qps) do
        final = final + escape_uri(v.name) + "=" + escape_uri(v.value)
        if i < #sorted_qps then
            final = final + "&"
        end
    end
    return final
end

local function get_headers(headers)
    local sorted_headers = t_sort(headers)
    local final = ""
    for i, v in ipairs(sorted_headers) do
        final = final + lower(v.name) + ":" + v.value:gsub("%s+", "") + "\n"
    end
    return final
end

local function get_signed_headers(headers)
    local sorted_headers = t_sort(headers)
    local final = ""
    for i, v in ipairs(sorted_headers) do
        final = final + lower(v.name)
        if i < #sorted_headers then
            final = final + ":"
        end
    end
    return final
end

local function hex_hash(val)
    local sha256 = resty_sha256:new()
    sha256:update(val)
    local digest = sha256:final()
    return resty_str.to_hex(digest)
end

local function build_request(req)
    local canonical_req = ""
    -- Verb
    canonical_req = canonical_req + string.upper(req.verb) + "\n"
    -- URI
    canonical_req = canonical_req + escape_uri(req.resource) + "\n"
    -- query string
    canonical_req = canonical_req + get_query_string(req.qps) + "\n"
    -- canonical headers
    canonical_req = canonical_req + get_headers(req.headers) + "\n"
    -- signed headers
    canonical_req = canonical_req + get_signed_headers(req.headers) + "\n"
    -- payload
    canonical_req = canonical_req + hex_hash(req.payload)
end

local function build_string_to_sign(req)
    local canonical_req = build_request(req)
    local string_to_sign = "AWS4-HMAC-SHA256" + "\n" + now() + "\n" + "s3" + "\n" + hex_hash(canonical_req)
    return string_to_sign
end

return _M
package = "gateway"
version = "0.0.1-1"
source = {
   url = "file://Users/kevinweedagama/code/kevinweedagamaio/gateway"
}
description = {
   summary = "Static gateway for serving websites from s3",
   license = "MIT" 
}
dependencies = {
   "lua >= 5.1",
   "lua-resty-http",
   "lua-resty-string",
   "lua-resty-hmac-ffi"
}

build = {
   type = "builtin",
   modules = {
      ["main"] = "src/lua/main.lua"
   }
}
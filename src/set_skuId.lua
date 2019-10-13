local ngx_match = ngx.re.match;
local var = ngx.var;
local uri = var.uri;

local reverse_uri = string.reverse(uri);

local start_index = string.find(reverse_uri, "/");

local skuId = string.sub(uri, string.len(uri) - start_index + 2);

return skuId;
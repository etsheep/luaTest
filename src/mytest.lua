
local uri = "abcd/efg";
local reverse_uri = string.reverse(uri);

local start_index = string.find(reverse_uri, "/");

print(start_index);

local index = string.len(uri) - start_index + 2;
local result = string.sub(uri, index);

print(result);

print("aaa" , "bbb");

local str, a = "aaa" , "bbb";

print(str,a);
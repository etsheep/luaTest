
local redis_common = require("test.redis_common");

local red = redis_common.create_redis("127.0.0.1", "6380");

local resp, err = red:eval("return redis.call('get', KEYS[1])", 1, "msg");
ngx.say("resp1 : ", resp, "<br/>")

local sha1, err = red:script("load", "return redis.call('get', KEYS[1])");
if not sha1 then
    ngx.say("load script error : ", err);
    redis_common.close_redis(red);
    return
end

ngx.say("sha1 : ", sha1, "<br/>")
local resp, err = red:evalsha(sha1, 1, "msg");
ngx.say("resp2 : ", resp, "<br/>")

redis_common.close_redis(red);
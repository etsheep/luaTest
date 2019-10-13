local redis = require("resty.redis");

local function close_redis(red)
    if not red then
        return;
    end

    --释放连接（连接池实现）
    local pool_max_idle_time = 10000; --毫秒
    local pool_size =  100;   --连接池大小
    local ok, err = red:set_keepalive(pool_max_idle_time, pool_size);
    --local ok, err = red:close();
    if not ok then
        --ngx.say("close redis error : ", err);
        ngx.say("set keepalive error : ", err);
    end
end

local function create_redis(ip, port)
    --创建实例
    local red = redis:new();
    --设置超时（毫秒）
    red:set_timeout(1000);
    --建立连接
    local ok, err = red:connect(ip, port);
    if not ok then
        ngx.say("connect to redis error : ", err);
        return close_redis(red);
    end

    return red;
end

local _M = {
    create_redis = create_redis;
    close_redis = close_redis;
}

return _M;

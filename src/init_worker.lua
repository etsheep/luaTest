local count = 0;
local delayInSeconds = 3;
local heartBeatCheck = nil;

heartBeatCheck = function(args)
    count = count + 1;
    ngx.log(ngx.ERR, "do check ", count);

    local ok, err = ngx.timer.at(delayInSeconds, heartBeatCheck);

    if not ok then
        ngx.log(ngx.ERR, "failed to startup heartBeat worker...", err);
    end
end

heartBeatCheck();
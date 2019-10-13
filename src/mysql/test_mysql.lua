local function close_db(db)
    if not db then
        return;
    end
    --db:close();
    --释放连接（连接池实现）
    local pool_max_idle_time = 10000; --毫秒
    local pool_size =  100;   --连接池大小
    db:set_keepalive(pool_max_idle_time, pool_size);
end

local mysql = require("resty.mysql");

--创建实例
local db, err = mysql:new();
if not db then
    ngx.say("new mysql error : ", err);
    return;
end

--设置超时时间（毫秒）
db:set_timeout(1000);

local props = {
    host = "gz-cdb-837lunyf.sql.tencentcdb.com",
    port = "60797",
    database = "test",
    user = "root",
    password = "86514490et"
}

local res, err, errno, sqlstate = db:connect(props);
if not res then
    ngx.say("connect to mysql error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate);
    return close_db(db);
end

--删除表
--local drop_table_sql = "drop table if exists test";
--res, err, errno, sqlstate = db:query(drop_table_sql);
--if not res then
--    ngx.say("drop table error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate);
--    return close_db(db);
--end

--创建表
--local create_table_sql = "create table test(id int primary key auto_increment, name varchar(100))";
--res, err, errno, sqlstate = db:query(create_table_sql);
--if not res then
--    ngx.say("create table error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate);
--    return close_db(db);
--end

--插入
local insert_sql = "insert into test(name) values('hahaha')";
res, err, errno, sqlstate = db:query(insert_sql);
if not res then
    ngx.say("insert error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate);
    return close_db(db);
end

res, err, errno, sqlstate = db:query(insert_sql);
ngx.say("insert rows : ", res.affected_rows, " , id : ", res.insert_id, "<br/>");

--更新
local update_sql = "update test set name = 'hahaha3' where id =" .. res.insert_id;
res, err, errno, sqlstate = db:query(update_sql)
if not res then
    ngx.say("update error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate);
    return close_db(db);
end

ngx.say("update rows : ", res.affected_rows, "<br/>");

--查询
local select_sql = "select id, name from test";
res, err, errno, sqlstate = db:query(select_sql);
if not res then
    ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate);
    return close_db(db);
end

for i, row in ipairs(res) do
    for name, value in pairs(row) do
        ngx.say("select row ", i, " : ", name, " = ", value, "<br/>");
    end
end

ngx.say("<br/>");

--防止sql注入
local name_param = ngx.req.get_uri_args()["name"] or '';
--使用ngx.quote_sql_str防止sql注入
local query_sql = "select id, name from test where name = " .. ngx.quote_sql_str(name_param);
res, err, errno, sqlstate = db:query(query_sql)
if not res then
    ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

for i, row in ipairs(res) do  --迭代数组
    for name, value in pairs(row) do --迭代table
        ngx.say("select row ", i, " : ", name " = ", value, "<br/>");
    end
end

--删除
--local delete_sql = "delete from test";
--res, err, errno, sqlstate = db:query(delete_sql);
--if not res then
--    ngx.say("delete error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate);
--    return close_db(db);
--end
--
--ngx.say("delete rows : ", res.affected_rows, "<br/>");


close_db(db);
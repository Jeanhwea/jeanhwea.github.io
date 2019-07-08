/* 用户和权限管理 */ ------------------
用户信息表：mysql.user
-- 刷新权限
FLUSH PRIVILEGES
-- 增加用户
CREATE USER 用户名 IDENTIFIED BY [PASSWORD] 密码(字符串)
    - 必须拥有 mysql 数据库的全局 CREATE USER 权限，或拥有 INSERT 权限。
    - 只能创建用户，不能赋予权限。
    - 用户名，注意引号：如 'user_name'@'192.168.1.1'
    - 密码也需引号，纯数字密码也要加引号
    - 要在纯文本中指定密码，需忽略 PASSWORD 关键词。要把密码指定为由 PASSWORD()函数返回的混编值，需包含关键字 PASSWORD
-- 重命名用户
RENAME USER old_user TO new_user
-- 设置密码
SET PASSWORD = PASSWORD('密码')    -- 为当前用户设置密码
SET PASSWORD FOR 用户名 = PASSWORD('密码')    -- 为指定用户设置密码
-- 删除用户
DROP USER 用户名
-- 分配权限/添加用户
GRANT 权限列表 ON 表名 TO 用户名 [IDENTIFIED BY [PASSWORD] 'password']
    - all privileges 表示所有权限
    - *.* 表示所有库的所有表
    - 库名.表名 表示某库下面的某表
-- 查看权限
SHOW GRANTS FOR 用户名
    -- 查看当前用户权限
    SHOW GRANTS; 或 SHOW GRANTS FOR CURRENT_USER; 或 SHOW GRANTS FOR CURRENT_USER();
-- 撤消权限
REVOKE 权限列表 ON 表名 FROM 用户名
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 用户名    -- 撤销所有权限
-- 权限层级
-- 要使用 GRANT 或 REVOKE，您必须拥有 GRANT OPTION 权限，并且您必须用于您正在授予或撤销的权限。
全局层级：全局权限适用于一个给定服务器中的所有数据库，mysql.user
    GRANT ALL ON *.*和 REVOKE ALL ON *.*只授予和撤销全局权限。
数据库层级：数据库权限适用于一个给定数据库中的所有目标，mysql.db, mysql.host
    GRANT ALL ON db_name.*和 REVOKE ALL ON db_name.*只授予和撤销数据库权限。
表层级：表权限适用于一个给定表中的所有列，mysql.talbes_priv
    GRANT ALL ON db_name.tbl_name 和 REVOKE ALL ON db_name.tbl_name 只授予和撤销表权限。
列层级：列权限适用于一个给定表中的单一列，mysql.columns_priv
    当使用 REVOKE 时，您必须指定与被授权列相同的列。
-- 权限列表
ALL [PRIVILEGES]    -- 设置除 GRANT OPTION 之外的所有简单权限
ALTER    -- 允许使用 ALTER TABLE
ALTER ROUTINE    -- 更改或取消已存储的子程序
CREATE    -- 允许使用 CREATE TABLE
CREATE ROUTINE    -- 创建已存储的子程序
CREATE TEMPORARY TABLES        -- 允许使用 CREATE TEMPORARY TABLE
CREATE USER        -- 允许使用 CREATE USER, DROP USER, RENAME USER 和 REVOKE ALL PRIVILEGES。
CREATE VIEW        -- 允许使用 CREATE VIEW
DELETE    -- 允许使用 DELETE
DROP    -- 允许使用 DROP TABLE
EXECUTE        -- 允许用户运行已存储的子程序
FILE    -- 允许使用 SELECT...INTO OUTFILE 和 LOAD DATA INFILE
INDEX     -- 允许使用 CREATE INDEX 和 DROP INDEX
INSERT    -- 允许使用 INSERT
LOCK TABLES        -- 允许对您拥有 SELECT 权限的表使用 LOCK TABLES
PROCESS     -- 允许使用 SHOW FULL PROCESSLIST
REFERENCES    -- 未被实施
RELOAD    -- 允许使用 FLUSH
REPLICATION CLIENT    -- 允许用户询问从属服务器或主服务器的地址
REPLICATION SLAVE    -- 用于复制型从属服务器（从主服务器中读取二进制日志事件）
SELECT    -- 允许使用 SELECT
SHOW DATABASES    -- 显示所有数据库
SHOW VIEW    -- 允许使用 SHOW CREATE VIEW
SHUTDOWN    -- 允许使用 mysqladmin shutdown
SUPER    -- 允许使用 CHANGE MASTER, KILL, PURGE MASTER LOGS 和 SET GLOBAL 语句，mysqladmin debug 命令；允许您连接（一次），即使已达到 max_connections。
UPDATE    -- 允许使用 UPDATE
USAGE    -- “无权限”的同义词
GRANT OPTION    -- 允许授予权限


/* 表维护 */
-- 分析和存储表的关键字分布
ANALYZE [LOCAL | NO_WRITE_TO_BINLOG] TABLE 表名 ...
-- 检查一个或多个表是否有错误
CHECK TABLE tbl_name [, tbl_name] ... [option] ...
option = {QUICK | FAST | MEDIUM | EXTENDED | CHANGED}
-- 整理数据文件的碎片
OPTIMIZE [LOCAL | NO_WRITE_TO_BINLOG] TABLE tbl_name [, tbl_name] ...

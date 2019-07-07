/* 导入导出 */ ------------------
select * into outfile 文件地址 [控制格式] from 表名;    -- 导出表数据
load data [local] infile 文件地址 [replace|ignore] into table 表名 [控制格式];    -- 导入数据
    生成的数据默认的分隔符是制表符
    local 未指定，则数据文件必须在服务器上
    replace 和 ignore 关键词控制对现有的唯一键记录的重复的处理
-- 控制格式
fields    控制字段格式
默认：fields terminated by '\t' enclosed by '' escaped by '\\'
    terminated by 'string'    -- 终止
    enclosed by 'char'        -- 包裹
    escaped by 'char'        -- 转义
    -- 示例：
        SELECT a,b,a+b INTO OUTFILE '/tmp/result.text'
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\n'
        FROM test_table;
lines    控制行格式
默认：lines terminated by '\n'
    terminated by 'string'    -- 终止

/* insert */ ------------------
select 语句获得的数据可以用 insert 插入。

可以省略对列的指定，要求 values () 括号内，提供给了按照列顺序出现的所有字段的值。
    或者使用 set 语法。
    insert into tbl_name set field=value,...；

可以一次性使用多个值，采用(), (), ();的形式。
    insert into tbl_name values (), (), ();

可以在列值指定时，使用表达式。
    insert into tbl_name values (field_value, 10+10, now());
可以使用一个特殊值 default，表示该列使用默认值。
    insert into tbl_name values (field_value, default);

可以通过一个查询的结果，作为需要插入的值。
    insert into tbl_name select ...;

可以指定在插入的值出现主键（或唯一索引）冲突时，更新其他非主键列的信息。
    insert into tbl_name values/set/select on duplicate key update 字段=值, …;

/* delete */ ------------------
DELETE FROM tbl_name [WHERE where_definition] [ORDER BY ...] [LIMIT row_count]

按照条件删除

指定删除的最多记录数。Limit

可以通过排序条件删除。order by + limit

支持多表删除，使用类似连接语法。
delete from 需要删除数据多表 1，表 2 using 表连接操作 条件。

/* truncate */ ------------------
TRUNCATE [TABLE] tbl_name
清空数据
删除重建表

区别：
1，truncate 是删除表再创建，delete 是逐条删除
2，truncate 重置 auto_increment 的值。而 delete 不会
3，truncate 不知道删除了几条，而 delete 知道。
4，当被用于带分区的表时，truncate 会保留分区


/* 视图 */ ------------------
什么是视图：
    视图是一个虚拟表，其内容由查询定义。同真实的表一样，视图包含一系列带有名称的列和行数据。但是，视图并不在数据库中以存储的数据值集形式存在。行和列数据来自由定义视图的查询所引用的表，并且在引用视图时动态生成。
    视图具有表结构文件，但不存在数据文件。
    对其中所引用的基础表来说，视图的作用类似于筛选。定义视图的筛选可以来自当前或其它数据库的一个或多个表，或者其它视图。通过视图进行查询没有任何限制，通过它们进行数据修改时的限制也很少。
    视图是存储在数据库中的查询的 sql 语句，它主要出于两种原因：安全原因，视图可以隐藏一些数据，如：社会保险基金表，可以用视图只显示姓名，地址，而不显示社会保险号和工资数等，另一原因是可使复杂的查询易于理解和使用。

-- 创建视图
CREATE [OR REPLACE] [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}] VIEW view_name [(column_list)] AS select_statement
    - 视图名必须唯一，同时不能与表重名。
    - 视图可以使用 select 语句查询到的列名，也可以自己指定相应的列名。
    - 可以指定视图执行的算法，通过 ALGORITHM 指定。
    - column_list 如果存在，则数目必须等于 SELECT 语句检索的列数

-- 查看结构
    SHOW CREATE VIEW view_name

-- 删除视图
    - 删除视图后，数据依然存在。
    - 可同时删除多个视图。
    DROP VIEW [IF EXISTS] view_name ...

-- 修改视图结构
    - 一般不修改视图，因为不是所有的更新视图都会映射到表上。
    ALTER VIEW view_name [(column_list)] AS select_statement

-- 视图作用
    1. 简化业务逻辑
    2. 对客户端隐藏真实的表结构

-- 视图算法(ALGORITHM)
    MERGE        合并
        将视图的查询语句，与外部查询需要先合并再执行！
    TEMPTABLE    临时表
        将视图执行完毕后，形成临时表，再做外层查询！
    UNDEFINED    未定义(默认)，指的是 MySQL 自主去选择相应的算法。



/* 事务(transaction) */ ------------------
事务是指逻辑上的一组操作，组成这组操作的各个单元，要不全成功要不全失败。
    - 支持连续 SQL 的集体成功或集体撤销。
    - 事务是数据库在数据晚自习方面的一个功能。
    - 需要利用 InnoDB 或 BDB 存储引擎，对自动提交的特性支持完成。
    - InnoDB 被称为事务安全型引擎。

-- 事务开启
    START TRANSACTION; 或者 BEGIN;
    开启事务后，所有被执行的 SQL 语句均被认作当前事务内的 SQL 语句。
-- 事务提交
    COMMIT;
-- 事务回滚
    ROLLBACK;
    如果部分操作发生问题，映射到事务开启前。

-- 事务的特性
    1. 原子性（Atomicity）
        事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生。
    2. 一致性（Consistency）
        事务前后数据的完整性必须保持一致。
        - 事务开始和结束时，外部数据一致
        - 在整个事务过程中，操作是连续的
    3. 隔离性（Isolation）
        多个用户并发访问数据库时，一个用户的事务不能被其它用户的事物所干扰，多个并发事务之间的数据要相互隔离。
    4. 持久性（Durability）
        一个事务一旦被提交，它对数据库中的数据改变就是永久性的。

-- 事务的实现
    1. 要求是事务支持的表类型
    2. 执行一组相关的操作前开启事务
    3. 整组操作完成后，都成功，则提交；如果存在失败，选择回滚，则会回到事务开始的备份点。

-- 事务的原理
    利用 InnoDB 的自动提交(autocommit)特性完成。
    普通的 MySQL 执行语句后，当前的数据提交操作均可被其他客户端可见。
    而事务是暂时关闭“自动提交”机制，需要 commit 提交持久化数据操作。

-- 注意
    1. 数据定义语言（DDL）语句不能被回滚，比如创建或取消数据库的语句，和创建、取消或更改表或存储的子程序的语句。
    2. 事务不能被嵌套

-- 保存点
    SAVEPOINT 保存点名称 -- 设置一个事务保存点
    ROLLBACK TO SAVEPOINT 保存点名称 -- 回滚到保存点
    RELEASE SAVEPOINT 保存点名称 -- 删除保存点

-- InnoDB 自动提交特性设置
    SET autocommit = 0|1;    0 表示关闭自动提交，1表示开启自动提交。
    - 如果关闭了，那普通操作的结果对其他客户端也不可见，需要 commit 提交后才能持久化数据操作。
    - 也可以关闭自动提交来开启事务。但与 START TRANSACTION 不同的是，
        SET autocommit 是永久改变服务器的设置，直到下次再次修改该设置。(针对当前连接)
        而 START TRANSACTION 记录开启前的状态，而一旦事务提交或回滚后就需要再次开启事务。(针对当前事务)


/* 锁表 */
表锁定只用于防止其它客户端进行不正当地读取和写入
MyISAM 支持表锁，InnoDB 支持行锁
-- 锁定
    LOCK TABLES tbl_name [AS alias]
-- 解锁
    UNLOCK TABLES


/* 触发器 */ ------------------
    触发程序是与表有关的命名数据库对象，当该表出现特定事件时，将激活该对象
    监听：记录的增加、修改、删除。

-- 创建触发器
CREATE TRIGGER trigger_name trigger_time trigger_event ON tbl_name FOR EACH ROW trigger_stmt
    参数：
    trigger_time 是触发程序的动作时间。它可以是 before 或 after，以指明触发程序是在激活它的语句之前或之后触发。
    trigger_event 指明了激活触发程序的语句的类型
        INSERT：将新行插入表时激活触发程序
        UPDATE：更改某一行时激活触发程序
        DELETE：从表中删除某一行时激活触发程序
    tbl_name：监听的表，必须是永久性的表，不能将触发程序与 TEMPORARY 表或视图关联起来。
    trigger_stmt：当触发程序激活时执行的语句。执行多个语句，可使用 BEGIN...END 复合语句结构

-- 删除
DROP TRIGGER [schema_name.]trigger_name

可以使用 old 和 new 代替旧的和新的数据
    更新操作，更新前是 old，更新后是 new.
    删除操作，只有 old.
    增加操作，只有 new.

-- 注意
    1. 对于具有相同触发程序动作时间和事件的给定表，不能有两个触发程序。


-- 字符连接函数
concat(str1[, str2,...])

-- 分支语句
if 条件 then
    执行语句
elseif 条件 then
    执行语句
else
    执行语句
end if;

-- 修改最外层语句结束符
delimiter 自定义结束符号
    SQL 语句
自定义结束符号

delimiter ;        -- 修改回原来的分号

-- 语句块包裹
begin
    语句块
end

-- 特殊的执行
1. 只要添加记录，就会触发程序。
2. Insert into on duplicate key update 语法会触发：
    如果没有重复记录，会触发 before insert, after insert;
    如果有重复记录并更新，会触发 before insert, before update, after update;
    如果有重复记录但是没有发生更新，则触发 before insert, before update
3. Replace 语法 如果有记录，则执行 before insert, before delete, after delete, after insert


/* SQL 编程 */ ------------------

--// 局部变量 ----------
-- 变量声明
    declare var_name[,...] type [default value]
    这个语句被用来声明局部变量。要给变量提供一个默认值，请包含一个 default 子句。值可以被指定为一个表达式，不需要为一个常数。如果没有 default 子句，初始值为 null。

-- 赋值
    使用 set 和 select into 语句为变量赋值。

    - 注意：在函数内是可以使用全局变量（用户自定义的变量）


--// 全局变量 ----------
-- 定义、赋值
set 语句可以定义并为变量赋值。
set @var = value;
也可以使用 select into 语句为变量初始化并赋值。这样要求 select 语句只能返回一行，但是可以是多个字段，就意味着同时为多个变量进行赋值，变量的数量需要与查询的列数一致。
还可以把赋值语句看作一个表达式，通过 select 执行完成。此时为了避免=被当作关系运算符看待，使用:=代替。（set 语句可以使用= 和 :=）。
select @var:=20;
select @v1:=id, @v2=name from t1 limit 1;
select * from tbl_name where @var:=30;

select into 可以将表中查询获得的数据赋给变量。
    -| select max(height) into @max_height from tb;

-- 自定义变量名
为了避免 select 语句中，用户自定义的变量与系统标识符（通常是字段名）冲突，用户自定义变量在变量名前使用@作为开始符号。
@var=10;

    - 变量被定义后，在整个会话周期都有效（登录到退出）


--// 控制结构 ----------
-- if 语句
if search_condition then
    statement_list
[elseif search_condition then
    statement_list]
...
[else
    statement_list]
end if;

-- case 语句
CASE value WHEN [compare-value] THEN result
[WHEN [compare-value] THEN result ...]
[ELSE result]
END


-- while 循环
[begin_label:] while search_condition do
    statement_list
end while [end_label];

- 如果需要在循环内提前终止 while 循环，则需要使用标签；标签需要成对出现。

    -- 退出循环
        退出整个循环 leave
        退出当前循环 iterate
        通过退出的标签决定退出哪个循环


--// 存储函数，自定义函数 ----------
-- 新建
    CREATE FUNCTION function_name (参数列表) RETURNS 返回值类型
        函数体

    - 函数名，应该合法的标识符，并且不应该与已有的关键字冲突。
    - 一个函数应该属于某个数据库，可以使用 db_name.funciton_name 的形式执行当前函数所属数据库，否则为当前数据库。
    - 参数部分，由"参数名"和"参数类型"组成。多个参数用逗号隔开。
    - 函数体由多条可用的 mysql 语句，流程控制，变量声明等语句构成。
    - 多条语句应该使用 begin...end 语句块包含。
    - 一定要有 return 返回值语句。

-- 删除
    DROP FUNCTION [IF EXISTS] function_name;

-- 查看
    SHOW FUNCTION STATUS LIKE 'partten'
    SHOW CREATE FUNCTION function_name;

-- 修改
    ALTER FUNCTION function_name 函数选项


--// 存储过程，自定义功能 ----------
-- 定义
存储存储过程 是一段代码（过程），存储在数据库中的 sql 组成。
一个存储过程通常用于完成一段业务逻辑，例如报名，交班费，订单入库等。
而一个函数通常专注与某个功能，视为其他程序服务的，需要在其他语句中调用函数才可以，而存储过程不能被其他调用，是自己执行 通过 call 执行。

-- 创建
CREATE PROCEDURE sp_name (参数列表)
    过程体

参数列表：不同于函数的参数列表，需要指明参数类型
IN，表示输入型
OUT，表示输出型
INOUT，表示混合型

注意，没有返回值。


/* 存储过程 */ ------------------
存储过程是一段可执行性代码的集合。相比函数，更偏向于业务逻辑。
调用：CALL 过程名
-- 注意
- 没有返回值。
- 只能单独调用，不可夹杂在其他语句中

-- 参数
IN|OUT|INOUT 参数名 数据类型
IN        输入：在调用过程中，将数据输入到过程体内部的参数
OUT        输出：在调用过程中，将过程体处理完的结果返回到客户端
INOUT    输入输出：既可输入，也可输出

-- 语法
CREATE PROCEDURE 过程名 (参数列表)
BEGIN
    过程体
END


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

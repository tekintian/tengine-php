#Lua语法

lua特殊点
1.默认变量,函数都是全局的.慎用.要用 local 修饰符.
2.字符串,数组下标是从1开始

一.数据类型

nil 空
一个变量未被赋值就是 nil
将 nil赋予给一个全局变量就等于删除它

boolean 布尔
lua 中 nil 和 false 为假.其他为真.0和空字符串也是真

number 数字
用于表示实数. math.floor向下取整. math.ceil 向上取整

string 字符串
lua 中字符串不能更改.也不能通过下标访问某个字符.
在 lua 中.两个完全一样的 lua 字符串在虚拟机中只会存储一份.
每一个字符串在创建时都会插入到 lua 虚拟机内部的一个全局的哈希表中.

table 表
table 类型实现了一种抽象的关联数组.

local  corp = {
    name   =    “kang”,
    age       =    20
}
function 函数
在 lua 中.函数也是一种数据类型.函数可以存储在变量中.通过参数传递给其他函数.汉可以作为函数的返回值.

local  function  foo()
    local  x=10;
    local  y=20;
    return x+y;
end;

local  a=foo;
a();
二.表达式

算术运算符
加+ 
减- 
乘* 
除/ 
指数^ 
取余%

关系运算符
小于< 
大于> 
小于等于<= 
大于等于>= 
等于== 
不等于~=

逻辑运算符
与 and
或 or
非 not

字符连接
使用操作符 “..” (两个点).
如果其任意一个是数字的话.将会把这个数字转换为字符串.

也可以用 string 库的函数 string.format 连接字符串.

string.format(“%s-%s”,”hello”,”word”);
hello-word
推荐使用 table.concat()来进行字符串拼接.因为 lua 中字符串是只读的.连接操作会创建一个新的字符串.性能损耗大.

三.表达式

1.单个 if 分支

x=10
if  x>0 then
    print(x);
end;
2.两个分支 if-else

x=10
if x>0 then
    print(0);
else
    print(1)
end;
3.多个分支 if-elseif-else

score=10
if score==10 then
    print(1)
elseif  score==11  then
    print(2)
else
    print(3)
end;
4.whie 控制结构
while 表达式==真 do

todo
end;

x=1
sum=0
while x<=5 do
    sum = sum+x;
    x = x+1;
end;
5.repeat 控制结构
类似于 do-while 语句

repeat
    todo
until  条件==假
6.for 
数字型
for var=begin,finish,step do

todo
end;
step 默认为1

for i=1,5,1 do
    print(i);
end;
泛型
泛型 for 循环通过一个迭代器函数来遍历所有制.

local  a= {“a”,”b”,”c”}
for i,v in ipairs(a) do
    print(i,v)
end;
lua 的基础库提供了 ipairs. 这是一个用于遍历数组的迭代器函数.
用于迭代文件中每行的（io.lines）、
迭代 table 元素的（pairs）、
迭代数组元素的（ipairs）、
迭代字符串中单词的（string.gmatch）

函数

函数的定义

function  name (arc)
    todo
end;

name = function (arc)

end;
没有 local 修饰的都是全局变量.因此函数声明局部函数也要用上 local

local function name (arc)
    todo
end;
函数名还可以是 table 数量类型中某个字段.

function  stu.getName()
    todo
end;
函数的参数
lua 函数的参数大部分都是按值传递.

在调用函数的时候，若形参个数和实参个数不同时，Lua 会自动调整实参个数。调整规则：若实参个数大于形参个数，从左向右，多余的实参被忽略；若实参个数小于形参个数，从左向右，没有被实参初始化的形参会被初始化为 nil。

变长参数
若形参为 … 则该函数可以接收不同长度的参数.访问参数的时候也要使用...

local  function  func( ... )
    local  tmp = {…}
    for k,v  in  pairs(tmp) do
        print(v)
    end;
end;
函数的返回值
lua 允许函数返回多个值.

loca s,e = string.find(“hello word”,”llo");
返回字符串的开始位置和结束位置的下标

返回多个值时.值之间用”,”隔开.

调整规则： 若返回值个数大于接收变量的个数，多余的返回值会被忽略掉； 若返回值个数小于参数个数，从左向右，没有被返回值初始化的变量会被初始化为 nil。

注意:当一个函数有一个以上返回值，且函数调用不是一个列表表达式的最后一个元素，那么函数调用只会产生一个返回值,也就是第一个返回值。

local function init()       -- init 函数 返回两个值 1 和 "lua"
    return 1, "lua"
end

local x, y, z = init(), 2   -- init 函数的位置不在最后，此时只返回 1
print(x, y, z)              -->output  1  2  nil

local a, b, c = 2, init()   -- init 函数的位置在最后，此时返回 1 和 "lua"
print(a, b, c)              -->output  2  1  lua
模块
从 lua5.1开始.增加了对模块和包的支持.
一个模块的数据结构是用一个 lua 值(通常是一个 lua 表或者 lua 函数).
可以使用 require()来加载和缓存模块.

定义个模块 my.lua

local foo={}

local function getname()
    return "Lucy"
end

function foo.greeting()
    print("hello " .. getname())
end

return foo
定义个 main.lua.调用 my.lua模块

local fp = require("my")
fp.greeting()     -->output: hello Lucy
元表

setmetatable(table, metatable)
此方法用于为一个表设置元表
getmetatable(table)
获取表的元表对象

local  mytable = {}
local  metatable = {}
setmetatable(mytable, metatable);
or
mytable = setmetatable({},{})
修改表的操作符行为
通过重载”__add”元方法来计算集合的并集;

local table_1 = {10,20,30};
local table_2 = {40,50,60};

local metatable = {};
metatable.__add = function (self, another)
    local sum = {};
    for k,v in pairs(self) do
        table.insert(sum,v);
    end;
    for k,v in pairs(another) do
        table.insert(sum,v);
    end
    return sum;
end;
setmetatable(table_1, metatable);
table_3 = table_1+table_2;
for k,v in pairs(table_3) do
    print(v)
end

## 除了加法可以被重载之外，Lua 提供的所有操作符都可以被重载：
元方法 含义
	"__add" + 操作
	"__sub" - 操作 其行为类似于 "add" 操作
	"__mul" * 操作 其行为类似于 "add" 操作
	"__div" / 操作 其行为类似于 "add" 操作
	"__mod" % 操作 其行为类似于 "add" 操作
	"__pow" ^ （幂）操作 其行为类似于 "add" 操作
	"__unm" 一元 - 操作
	"__concat" .. （字符串连接）操作
	"__len" # 操作
	"__eq" == 操作 函数 getcomphandler 定义了 Lua 怎样选择一个处理器来作比较操作 仅在两个对象类型相同且有对应操作相同的元方法时才起效
	"__lt" < 操作
	"__le" <= 操作
除了操作符之外，如下元方法也可以被重载，下面会依次解释使用方法：
	元方法 含义
	"__index" 取下标操作用于访问 table[key]
	"__newindex" 赋值给指定下标 table[key] = value
	"__tostring" 转换成字符串
	"__call" 当 Lua 调用一个值时调用
	"__mode" 用于弱表(week table)
	"__metatable" 用于保护metatable不被访问
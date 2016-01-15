# vose-lua

----

lua module implements Vose's Alias Method as described here http://www.keithschwarz.com/darts-dice-coins/
This algorithm can be used to efficiently find weighted random data ex. rolling a weighted dice.

### How to use

```Lua
local Vose = require("PATH_TO_VOSE/vose")
local result = Vose({
   ele_1 = 25, -- element = weight
   ele_2 = 35, -- element = weight
   ele_3 = 45
})
```

----

Vose的Alias算法的lua实现，参考的是 http://www.keithschwarz.com/darts-dice-coins/ 。
这是一个高效的用来计算加权随机结果的算法，比如说，一个有掉率的宝箱应该掉落什么？


### 使用方法
```Lua
local Vose = require("PATH_TO_VOSE/vose")
local result = Vose({
   ele_1 = 25, -- 元素 = 权重
   ele_2 = 35,
   ele_3 = 45
})
```

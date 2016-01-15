--[[
    This lua module implements Vose's Alias Method as described
    here http://www.keithschwarz.com/darts-dice-coins/ . This algorithm
    can be used to efficiently find weighted random data ex. rolling a
    weighted dice.

    -- Usage
    local Vose = require('PATH_TO_VOSE/Vose')
    local result = Vose({
        element_1 = 25, -- element_name = drop_rate
        element_2 = 35,
        element_3 = 55
    })

    -- test
    -- local plist = {
    --     a = 25,
    --     b = 65,
    --     c = 10
    -- }
    -- local v = Vose(plist)
    -- local r = {}
    -- for i = 1, 1000 do
    --     local res = v:get()
    --     r[res] = r[res] or 0
    --     r[res] = r[res] + 1 
    -- end
    -- for k,v in pairs(r) do
    --     print(k,v)
    -- end

    Created on 2016.1.15
    @author XavierCHN
]]
if os then
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))  
end

local Vose = {}
Vose.__index = Vose
setmetatable(Vose, Vose)

local function tablecount(t)
    local c = 0
    for _ in pairs(t) do
        c = c + 1
    end
    return c
end

function Vose.__call(self, plist)

    local probs = {}
    for k,v in pairs(plist) do
        table.insert(probs, {k, v})
    end

    local sum = 0
    local count = 0

    -- Normalize probabilities
    for _, prob in pairs(probs) do
        sum = sum + prob[2] 
        count = count + 1
    end

    for _, prob in pairs(probs) do
        prob[2] = prob[2] / sum
    end

    local n = #probs

    local alias = {}
    local prob = {}

    local small = {}
    local large = {}

    for _, prob in pairs(probs) do
        prob[2] = prob[2] * n
        if prob[2] < 1 then
            table.insert(small, prob)
        else
            table.insert(large, prob)
        end
    end

    if large == {} then
        large, small = small, large
    end

    while( tablecount(small) > 0 and tablecount(large) > 0) do
        local l = table.remove(small, 1)
        local g = table.remove(large, 1)
        table.insert(prob, l[2])
        table.insert(alias, {l[1], g[1]})
        g[2] = g[2] - (1 - l[2])
        if g[2] >= 1 then
            table.insert(large, g)
        else
            table.insert(small, g)
        end
    end

    while(tablecount(large) > 0) do
        local g = table.remove(large, 1)
        table.insert(prob, 1)
        table.insert(alias, {g[1], g[1]})
        g[2] = g[2] - 1
        if g[2] >= 1 then
            table.insert(large, g)
        else
            table.insert(small, g)
        end
    end

    self.prob = prob
    self.alias = alias
    self.n = n
    self.plist = plist

    return self
end

function Vose:get()
    local i = math.floor(math.random(1, tablecount(self.prob)))
    if self.prob[i] >= math.random() then
        return self.alias[i][1]
    else
        return self.alias[i][2]
    end
end

    -- test
    -- local plist = {
    --     a = 25,
    --     b = 65,
    --     c = 10
    -- }
    -- local v = Vose(plist)
    -- local r = {}
    -- for i = 1, 1000 do
    --     local res = v:get()
    --     r[res] = r[res] or 0
    --     r[res] = r[res] + 1 
    -- end
    -- for k,v in pairs(r) do
    --     print(k,v)
    -- end

return Vose

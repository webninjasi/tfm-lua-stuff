do
  local constants = {
    11,
    22,
    a = 3,
    b = 4,
    c = "aaaa",
  }
  const = setmetatable({}, {
    __index = function(t, k)
      return constants[k]
    end,

    __newindex = function(t, k, v)
      error("loser")
    end,

    __call = function()
      return {
        pairs = function(t)
          local function iter(t, k)
            local v
            k, v = next(constants, k)
            if v ~= nil then return k, v end
          end
          return iter, t, nil
        end,

        ipairs = function(t)
          local function iter(t, i)
            i = 1 + i
            local v = constants[i]
            if v ~= nil then return i, v end
          end
          return iter, t, 0
        end
      }
    end
  })
end

print(const)
print(const.a)
print(const.b)
print(const.c)

local _, err = pcall(function()
  const.a = 3
end)

print(err)

for k, v in const().pairs() do
  print(("const.%s = %s"):format(k, v))
end

for i, v in const().ipairs() do
  print(("const.%s = %s"):format(i, v))
end

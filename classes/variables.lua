Variables = {}
Variables.__index = Variables

function Variables.new(playerId)
  local varInfo = {}
  setmetatable(varInfo, Variables)
  varInfo.playerId = PlayerId
  return varInfo
end

function Variables:change(name, newValue)
  self[name] = newValue
end

function Variables:delete(name)
  self[name] = nil
end

Main = {}
if IsDuplicityVersion() then 
  function GetGameTimer()
    return os.clock() * 1000
  end
end
function Main:Init()
  local o = {}
  setmetatable(o, {__index = Main})
  o.impls = {}
  o.initializedImpls = {}
  o.lastTimeImplRegistered = 0
  o.ready = false
  if not IsDuplicityVersion() then
    o.playerId = PlayerId()
    o.playerPed = PlayerPedId()
    o.playerCoords = GetEntityCoords(o.playerPed)
    o.playerHeading = GetEntityHeading(o.playerPed)
    o:Thread1()
  end
  o:Exports()
  return o
end
if not IsDuplicityVersion() then
  function Main:Thread1()
    Citizen.CreateThread(function()
      while true do
        self.playerId = PlayerId()
        self.playerPed = PlayerPedId()
        self.playerCoords = GetEntityCoords(self.playerPed)
        self.playerHeading = GetEntityHeading(self.playerPed)
        Citizen.Wait(1000)
      end
    end)
  end
end

function Main:LogError(msg, ...)
  if not Config.Debug then return end
  print(("[^1ERROR^0] " .. msg):format(...))
end

function Main:LogWarning(msg, ...)
  if not Config.Debug then return end
  print(("[^3WARNING^0] " .. msg):format(...))
end

function Main:LogSuccess(msg, ...)
  if not Config.Debug then return end
  print(("[^2INFO^0] " .. msg):format(...))
end

function Main:LogInfo(msg, ...)
  if not Config.Debug then return end
  print(("[^5INFO^0] " .. msg):format(...))
end

function Main:CheckValidImpl(name, impl)
  if not impl then
    self:LogError("Impl %s is nil", name)
    return false
  end
  if not impl.Init then
    self:LogError("Impl %s missing Init function", name)
    return false
  end
  return true
end

function Main:RegisterImpl(name, impl)
  if self.impls[name] then
    self:LogWarning("Impl %s already registered", name)
    return
  end
  if not self:CheckValidImpl(name, impl) then
    return
  end
  self.impls[name] = impl
  self.lastTimeImplRegistered = GetGameTimer()
  self:LogSuccess("Impl %s registered", name)
  if self.ready then 
    self.initializedImpls[name] = impl(self)
    self.initializedImpls[name]:OnReady()
  end
end

function Main:InitImpl()
  for name, impl in pairs(self.impls) do
    self.initializedImpls[name] = impl(self)
  end
  self:LogInfo("All impls initialized")
  self.ready = true
  for name, impl in pairs(self.initializedImpls) do
    impl:OnReady()
  end
end

function Main:GetImpl(name)
  if not self.initializedImpls[name] then
    self:LogError("Impl %s not found", name)
    return
  end
  return self.initializedImpls[name]
end

function Main:ImplCall(name, func, ...)
  local impl = self:GetImpl(name)
  if not impl then
    return
  end
  if not impl[func] then
    self:LogError("Impl %s missing function %s - args %s", name, func, json.encode({...}))
    return
  end
  return impl[func](impl, ...)
end



function Main:ImplInfo()
  for name, impl in pairs(self.impls) do
    local debug = debug.getinfo(impl.Init, "S")
    self:LogInfo("Impl %s - %s", name, debug.short_src)
  end
end

function Main:Exports()
  exports("ImplCall", function(name, func, ...)
    return self:ImplCall(name, func, ...)
  end)
end

main = Main:Init()

Citizen.CreateThread(function()

  while GetGameTimer() < main.lastTimeImplRegistered + 1000 do
    Citizen.Wait(0)
  end
  main:InitImpl()
  main:ImplInfo()
end)

Class = {}

-- default (empty) constructor
function Class:Init(...) end


-- create a subclass
function Class:extend(obj)
	local obj = obj or {}

	local function copyTable(table, destination)
		local table = table or {}
		local result = destination or {}

		for k, v in pairs(table) do
			if not result[k] then
				if type(v) == "table" and k ~= "__index" and k ~= "__newindex" then
					result[k] = copyTable(v)
				else
					result[k] = v
				end
			end
		end

		return result
	end

	copyTable(self, obj)

	obj._ = obj._ or {}

	local mt = {}

	-- create new objects directly, like o = Object()
	mt.__call = function(self, ...)
		return self:new(...)
	end

	-- allow for getters and setters
	mt.__index = function(table, key)
		local val = rawget(table._, key)
		if val and type(val) == "table" and (val.get ~= nil or val.value ~= nil) then
			if val.get then
				if type(val.get) == "function" then
					return val.get(table, val.value)
				else
					return val.get
				end
			elseif val.value then
				return val.value
			end
		else
			return val
		end
	end

	mt.__newindex = function(table, key, value)
		local val = rawget(table._, key)
		if val and type(val) == "table" and ((val.set ~= nil and val._ == nil) or val.value ~= nil) then
			local v = value
			if val.set then
				if type(val.set) == "function" then
					v = val.set(table, value, val.value)
				else
					v = val.set
				end
			end
			val.value = v
			if val and val.afterSet then val.afterSet(table, v) end
		else
			table._[key] = value
		end
	end

	setmetatable(obj, mt)

	return obj
end

-- set properties outside the constructor or other functions
function Class:set(prop, value)
	if not value and type(prop) == "table" then
		for k, v in pairs(prop) do
			rawset(self._, k, v)
		end
	else
		rawset(self._, prop, value)
	end
end

-- create an instance of an object with constructor parameters
function Class:new(...)
	local obj = self:extend({
    destroyed = false,
    originalMethods = {}
  })
	if obj.Init then obj:Init(...) end
	return obj
end


function class(attr)
	attr = attr or {}
	return Class:extend(attr)
end

Impl = class()

function Impl:GetName()
  return self.name
end

function Impl:Destroy()
  self.destroyed = true
  main:LogInfo("%s destroyed", self.name)
end

function Impl:OnReady(...)
end

function Impl:HookMethod(method, hookFn)
  local oldMethod = self[method]
  if not oldMethod then 
    main:LogError("Impl %s missing method %s", self.name, method)
    return
  end
  self.originalMethods[method] = oldMethod

  self[method] = function(...)
    if self.destroyed then
      return
    end
    local result = {pcall(hookFn, ...)}
    print(json.encode(result))
    local success = table.remove(result, 1)
    if not success then
      main:LogError("Impl %s hook %s error: %s", self.name, method, result[2])
      self[method] = oldMethod
      return oldMethod(...)
    end
    return oldMethod(self, table.unpack(result))
  end
end

function Impl:GetMethod(method)
  return self[method]
end

function Impl:ReplaceMethod(method, newMethod)
  if not self[method] then 
    main:LogError("Impl %s missing method %s", self.name, method)
    return
  end
  if not self.originalMethods[method] then 
    self.originalMethods[method] = self[method]
  end
  self[method] = newMethod
end

function Impl:RefreshMethod(method)
  if not self.originalMethods[method] then 
    main:LogError("Impl %s missing method %s", self.name, method)
    return
  end
  self[method] = self.originalMethods[method]
end

function NewImpl(name)
  local impl = Impl:extend({
    name = name
  })
  main:RegisterImpl(name, impl)
  return impl
end
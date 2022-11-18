-- Version: 0.2 (BETA)

local constructorMetatable = {}
local constructor = {}
local signalMetatable = {}
local signal = {}
local connectionMetatable = {}
local connection = {}
local permissions = {["Signal"] = false, ["Disconnect"] = false}
local threads = {}


local function Call(thread, callback, ...)
	callback(...)
	table.insert(threads, thread)
end

local function Thread()
	while true do Call(coroutine.yield()) end
end


constructorMetatable.__metatable = "nil"
constructorMetatable.__tostring = function(proxy) return "Signal Module" end
constructorMetatable.__newindex = function(proxy, index, value) error("attempt to modify a readonly table") end
constructorMetatable.__index = constructor

constructor.new = function()
	local signalObject = {}
	signalObject.Proxy = setmetatable({[signal] = signalObject}, signalMetatable)
	return signalObject.Proxy
end

signalMetatable.__metatable = "nil"
signalMetatable.__tostring = function(proxy) return "Signal Object" end
signalMetatable.__newindex = function(proxy, index, value) error("attempt to modify a readonly table") end
signalMetatable.__index = signal


signal.Connect = function(proxy, callback)
	if type(callback) ~= "function" then error("Attempt to connect failed: Passed value is not a function") end
	local signalObject = proxy[signal]
	local connectionObject = {}
	connectionObject.Signal = proxy
	connectionObject.Callback = callback
	connectionObject.Once = false
	connectionObject.Proxy = setmetatable({[connection] = connectionObject}, connectionMetatable)
	if signalObject.Last == nil then
		signalObject.First, signalObject.Last = connectionObject, connectionObject
	else
		connectionObject.Previous, signalObject.Last.Next, signalObject.Last = signalObject.Last, connectionObject, connectionObject
	end
	return connectionObject.Proxy
end

signal.Once = function(proxy, callback)
	if type(callback) ~= "function" then error("Attempt to connect failed: Passed value is not a function") end
	local signalObject = proxy[signal]
	local connectionObject = {}
	connectionObject.Signal = proxy
	connectionObject.Callback = callback
	connectionObject.Once = true
	connectionObject.Proxy = setmetatable({[connection] = connectionObject}, connectionMetatable)
	local signalObject = proxy[signal]
	if signalObject.Last == nil then
		signalObject.First, signalObject.Last = connectionObject, connectionObject
	else
		connectionObject.Previous, signalObject.Last.Next, signalObject.Last = signalObject.Last, connectionObject, connectionObject
	end
	return connectionObject.Proxy
end

signal.Wait = function(proxy)
	local signalObject = proxy[signal]
	local connectionObject = {}
	connectionObject.Signal = proxy
	connectionObject.Callback = coroutine.running()
	connectionObject.Once = true
	connectionObject.Proxy = setmetatable({[connection] = connectionObject}, connectionMetatable)
	if signalObject.Last == nil then
		signalObject.First, signalObject.Last = connectionObject, connectionObject
	else
		connectionObject.Previous, signalObject.Last.Next, signalObject.Last = signalObject.Last, connectionObject, connectionObject
	end
	return coroutine.yield()
end

signal.DisconnectAll = function(proxy)
	local signalObject = proxy[signal]
	local connectionObject = signalObject.First
	while connectionObject ~= nil do
		connectionObject.Signal = nil
		if type(connectionObject.Callback) == "thread" then coroutine.close(connectionObject.Callback) end
		connectionObject = connectionObject.Next
	end
	signalObject.First, signalObject.Last = nil, nil
end

signal.Fire = function(proxy, ...)
	local signalObject = proxy[signal]
	local connectionObject = signalObject.First
	while connectionObject ~= nil do
		if connectionObject.Once == true then
			connectionObject.Signal = nil
			if signalObject.First == connectionObject then signalObject.First = connectionObject.Next end
			if signalObject.Last == connectionObject then signalObject.Last = connectionObject.Previous end
			if connectionObject.Previous ~= nil then connectionObject.Previous.Next = connectionObject.Next end
			if connectionObject.Next ~= nil then connectionObject.Next.Previous = connectionObject.Previous end
		end
		if type(connectionObject.Callback) == "function" then
			local thread = table.remove(threads)
			if thread == nil then thread = coroutine.create(Thread) coroutine.resume(thread) end
			coroutine.resume(thread, thread, connectionObject.Callback, ...)
		else
			coroutine.resume(connectionObject.Callback, ...)
		end
		connectionObject = connectionObject.Next
	end
end

connectionMetatable.__metatable = "nil"
connectionMetatable.__tostring = function(proxy) return "Connection Object" end
connectionMetatable.__newindex = function(proxy, index, value) error("attempt to modify a readonly table") end
connectionMetatable.__index = function(proxy, index)
	if permissions[index] == nil then return end
	return proxy[connection][index] or connection[index]
end

connection.Disconnect = function(proxy)
	local connectionObject = proxy[connection]
	local signalObject = connectionObject.Signal[signal]
	if signalObject == nil then return end
	connectionObject.Signal = nil
	if type(connectionObject.Callback) == "thread" then coroutine.close(connectionObject.Callback) end
	if signalObject.First == connectionObject then signalObject.First = connectionObject.Next end
	if signalObject.Last == connectionObject then signalObject.Last = connectionObject.Previous end
	if connectionObject.Previous ~= nil then connectionObject.Previous.Next = connectionObject.Next end
	if connectionObject.Next ~= nil then connectionObject.Next.Previous = connectionObject.Previous end
end

return setmetatable({}, constructorMetatable)
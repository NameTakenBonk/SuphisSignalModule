![Suphis's_Signal_Module](https://github.com/NameTakenBonk/SuphisSignalModule/assets/83465599/a61d1f62-e0f6-47fb-948e-9f68e0de7940)
# SuphisSignalModule

# This is not my module it's Suphi#3388 module, join the discord here: https://discord.gg/B3zmjPVBce

# Features
* **No Parameter Limitations**: Unlike ROBLOX Events there are no parameter limitations
* **Store Values Inside The Connection**: Pass values when connecting a function to be passed to the fuction
* **Table Reference**:          Passing a table will pass a refrence and does not deep clone the table
* **Fire In Order**:          Events are fired in the same order they where connected in
* **Does not relay on workspace.SignalBehavior**: Always spawns signals even if signal behavior is set to deferred
* **Familiar**:               Works a lot like RBXScriptSignal and RBXScriptConnection

# Benchmarks

| Method | FastSignal | SuphisSignal | GoodSignal | SimpleSignal | RobloxSignal |
|--------|------------|--------------|------------|--------------|--------------|
| `New`   | 0.1        | 1.3          | 0.2        | 0.1          | 1.6          |
| `Connect` | 0.6 | 2.9 | 0.3 | 0.2 | 3.2 |
| `Disconnect` | 0.1 | 0.6 | 88.0 | 2.7 | 23.0 |
| `Fire` | 1.4 | 71.9 | 37.6 | 160.6 | 33.0 |
| `Wait` | 3.5 | 6.3 | 3.0 | 8.6 | 4.7 |

**Download the benchmark** -> 
https://discord.com/channels/909926338801061961/1042810934277713931/1046079394042609824

microseconds to complete (lower is better)
Fire is the most important benchmark as that's what your going to be doing the most

# SuphisSignal vs FastSignal
FastSignal does not create new threads when it fires connections this makes FastSignal fast but if any of the connections use async functions or task.wait() it will block the next connections from fireing until the current connection has finished SuphisSignal has a method called FastFire that works like FastSignal

#SuphisSignal vs Good Signal
SuphisSignal works a lot like GoodSignal but with some small differences
1) GoodSignal only caches 1 thread where SuphisSignal caches 16 threads it creates
2) GoodSignal and SuphisSignal both use linked lists but SuphisSignal uses doubly linked list this allows SuphisSignal to disconnect connections without traversing the list
3) GoodSignal new connections are added to the front of the list making connections fire in reverse order SuphisSignal adds new connections to the end of the list making them fire in the same order as they where connected

# Download
Go to release and get the prefered version. or 
```lua
local signalModule = require(11670710927)
```
Current Version: `Version: 1.0`

# Constructors
*SIGNAL MODULE*
`new() signal`
Returns a new signal object

# Properties
*SIGNAL MODULE*
```lua
Connections  number  0  READ ONLY
```
The amount of connections connected to this signal

# Events
```lua
Connected(connected: boolean, signal: Signal)  nil
```
Fires when the signal gets its first connection or if it removes its last connection 

# Methods
```lua
Connect(func: function, arguments...: tuple)  connection
```
Connects the given function to the event and returns an connection that represents it

```lua
Once(func: function, arguments...: tuple)  connection
```
Connects the given function to the event (for a single invocation) and returns an connection that represents it

```lua
Wait(arguments...: tuple)  tuple
```
Yields the current thread until the signal fires and returns the arguments provided by the signal

```lua
DisconnectAll()  nil
```
Disconnects all connections from the signal

```lua
Fire(arguments: Tuple)  nil
```
Fires the event

```lua
FastFire(arguments: tuple)  nil
```
Fires the event without creating threads

# Properties
*CONNECTION OBJECT*
```lua
Signal  signal/nil  "signal"  READ ONLY
```
The signal object this connection is connected to or nil

# METHODS
```lua
Disconnect()  nil
```
Disconnects the connection from the signal

# Simple Example
```lua
-- Require the ModuleScript
local signalModule = require(11670710927)

-- create a signal object
local signal = signalModule.new()

-- connect a function to the signal
local connection = signal:Connect(function(...)
  print(...)
end)

-- fire the signal
signal:Fire("Hello world!")

-- Disconnect the connection from the signal
connection:Disconnect()
```

# Disconnect All example
```lua
local signalModule = require(11670710927)
local signal = signalModule.new()
signal:Connect(function(...) print("Conection1", ...) end)
signal:Connect(function(...) print("Conection2", ...) end)
signal:Connect(function(...) print("Conection3", ...) end)

signal:Fire("Hello world!")

-- Disconnect all connections from the signal
signal:DisconnectAll()

-- fire the signal again this time nothing will print to output because we disconnected all connections
signal:Fire("Hello world!")
```

# Once Example
```lua
local signalModule = require(11670710927)
local signal = signalModule.new()

-- connection a function to only be called once
signal:Once(function(...) print(...) end)

signal:Fire("Hello world!")

-- fire the signal again this time nothing will print to output because once will automatically disconnect once it gets fired
signal:Fire("Hello world!")
```

# Wait Example

```lua
local signalModule = require(11670710927)
local signal = signalModule.new()

-- fire after a 10 second delay
task.delay(10, signal.Fire, signal, "Hello world!")

-- wait for the signal to fire then print it
print(signal:Wait())
```

# Arguments Example
```lua
local function Event(...)
  print(...) -- Hello World Goodbye 69
end

local signalModule = require(11670710927)
local signal = signalModule.new()
signal:Connect(Event, "Goodbye", 69) -- connect to the signal and save the values Goodbye and 69 into the connection
signal:Fire("Hello", "World")
```

#Update version 1.0 is now out
* added Connections property
* added Connected callback to detect when the signal gets connections
* improved proxy
* under the hood changes

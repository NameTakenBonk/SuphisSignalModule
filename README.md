# SuphisSignalModule

# This is not my module it's Suphi#3388 module, join the discord here: https://discord.gg/B3zmjPVBce

# Features
**No Parameter** Limitations Unlike ROBLOX Events there are no parameter limitations
**Fast**                     Look at benchmarks below
**Table Reference**          Passing a table will pass a refrence and does not deep clone the table
**Fire In Order**            Events are fired in the same order they where connected in
**Familiar**                 Works a lot like RBXScriptSignal and RBXScriptConnection

            | FastSignal | SuphisSignal | GoodSignal  | SimpleSignal | RobloxSignal |
------------------------------------------------------------------------------------

**New**   
``` 
	|  0.2        |  0.5       |  0.2         |  0.1         |  2.8         | 
```

**Connect**   
```
	|  1.0        |  1.9       |  0.8         |  0.6         |  5.2         | 
```

**Disconnect** 
```
	|  0.2        |  1.2       |  138.3         |  5.7         |  41.5         | 
```

**Fire**        
```
	|  6.0        |  49.1      |  46.9        |  113.0       |  34.0      | 
```

**Wait** 
```
	|  4.2        |  5.0       |  5.5         |  7.9         |  7.3         | 
```

microseconds to complete (lower is better)
Fire is the most important benchmark as that's what your going to be doing the most

# SuphisSignal vs FastSignal
FastSignal does not create new threads when it fires connections this makes FastSignal fast but if any of the connections use async functions or task.wait() it will block the next connections from fireing until the current connection has finished

#SuphisSignal vs Good Signal
SuphisSignal works a lot like GoodSignal but with some small differences
1) GoodSignal only caches 1 thread where SuphisSignal caches all threads it creates
2) GoodSignal and SuphisSignal both use linked lists but SuphisSignal uses doubly linked list this allows SuphisSignal to disconnect connections without traversing the list
3) GoodSignal new connections are added to the front of the list making connections fire in reverse order SuphisSignal adds new connections to the end of the list making them fire in the same order as they where connected

# Download
Go to release and get the prefered version. or 
```lua
local signalModule = require(11670710927)
```
Current Version: `Version: 0.3 [BETA]`

# Constructors
`new()`
Returns a new signal object

# Methods
```lua
Connect(unc: function)  connection
```
Connects the given function to the event and returns an connection that represents it

```lua
Once(func: function)  connection
```
Connects the given function to the event (for a single invocation) and returns an connection that represents it

```lua
Wait()  Tuple
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

# Properties
```lua
Signal  signal/nil  "signal"  READ ONLY
```
The signal object this connection is connected to or nil

# Methods
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

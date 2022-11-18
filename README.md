# SuphisSignalModule

# This is not my module it's Suphi#3388 module, join the discord here: https://discord.gg/B3zmjPVBce

# Features
**No Parameter** Limitations Unlike ROBLOX Events there are no parameter limitations
**Fast**                     Look at benchmarks below
**Table Reference**          Passing a table will pass a refrence and does not deep clone the table
**Fire In Order**            Events are fired in the same order they where connected in
**Familiar**                 Works a lot like RBXScriptSignal and RBXScriptConnection

            | FastSignal | GoodSignal | SimpleSignal | SuphisSignal | RobloxSignal |
------------------------------------------------------------------------------------

**New**         ``|  0.1       |  0.5       |  0.2         |  0.3         |  2.6         |``

**Connect**   `` |  0.4       |  0.5       |  1.0         |  0.6         |  3.1         |``

**Disconnect**  ``|  0.2       |  148.5     |  3.8         |  0.9         |  41.7        |``

**Fire**       `` |  4.1       |  48.7      |  114.9       |  18.0        |  34.0        |``

**Wait**        ``|  4.5       |  5.0       |  6.1         |  3.3         |  6.0         |``

microseconds to complete (lower is better)
Fire is the most important benchmark as that's what your going to be doing the most

# Download
Go to release and get the prefered version.
Current Version: `Version: 0.2 [BETA]`

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
local signalModule = require(game.ServerStorage.SuphisSignalModule)

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
local signalModule = require(game.ServerStorage.SuphisSignalModule)
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
local signalModule = require(game.ServerStorage.SuphisSignalModule)
local signal = signalModule.new()

-- connection a function to only be called once
signal:Once(function(...) print(...) end)

signal:Fire("Hello world!")

-- fire the signal again this time nothing will print to output because once will automatically disconnect once it gets fired
signal:Fire("Hello world!")
```

# Wait Example

```lua
local signalModule = require(game.ServerScriptService.Classes.DataStore.Signal)
local signal = signalModule.new()

-- fire after a 10 second delay
task.delay(10, signal.Fire, signal, "Hello world!")

-- wait for the signal to fire then print it
print(signal:Wait())
```

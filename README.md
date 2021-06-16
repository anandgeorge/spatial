# HTM Spatial Pooler

Hierarchical temporal memory (HTM) provides a theoretical framework that models several key computational principles of the neocortex. The HTM Spatial Pooler (SP) models how neurons learn feedforward connections and form efficient representations of the input. It converts arbitrary binary input patterns into sparse distributed representations (SDRs) using a combination of competitive Hebbian learning rules and homeostatic excitability control.


## Usage

Clone this repository and run the following commands to install dependencies and run the application.
```elixir
cd spatial
mix deps.get
iex -S mix
```

#### Initialise the GenServer specifying the size of the pool, n.

```elixir
iex(1)> {:ok, pid} = GenServer.start(Pooler, [n: 121])
Pooler initialised
{:ok, #PID<0.146.0>}
```

#### Verify that the process has been created and the pooler initialised

```elixir
iex(2)> GenServer.call(pid, :get_state)
%{curr: #MapSet<[]>, pool: #MapSet<[]>, prev: #MapSet<[]>, subset: #MapSet<[]>}
```

#### Create an SDR to add to the pooler. 
See details of how to [create SDRs][https://github.com/anandgeorge/sdr]

```elixir
iex(3)> sdr = MapSet.new(0..21, fn x -> String.to_atom("#{x}") end)
#MapSet<[:"0", :"1", :"10", :"11", :"12", :"13", :"14", :"15", :"16", :"17",
 :"18", :"19", :"2", :"20", :"21", :"3", :"4", :"5", :"6", :"7", :"8", :"9"]>
```

#### Add the SDR to the pooler
The pooler is updated and new neurons are created.

```elixir
iex(4)> GenServer.cast(pid, {:send, sdr})
:ok
Added to pooler 0
Added to pooler 1
Added to pooler 10
...
...
Added to pooler 21
```

#### Verify that the pooler has been updated

```elixir
iex(5)> GenServer.call(pid, :get_state)                            
%{
  curr: #MapSet<[:"0", :"1", :"10", :"11", :"12", :"13", :"14", :"15", :"16",
   :"17", :"18", :"19", :"2", :"20", :"21", :"3", :"4", :"5", :"6", :"7", :"8",
   :"9"]>,
  pool: #MapSet<[:"0", :"1", :"10", :"11", :"12", :"13", :"14", :"15", :"16",
   :"17", :"18", :"19", :"2", :"20", :"21", :"3", :"4", :"5", :"6", :"7", :"8",
   :"9"]>,
  prev: #MapSet<[]>,
  subset: #MapSet<[:"10", :"11", :"16", :"5", :"7"]>
}
```
#### Create another SDR

```elixir
iex(6)> sdr = MapSet.new(30..51, fn x -> String.to_atom("#{x}") end) 
#MapSet<[:"30", :"31", :"32", :"33", :"34", :"35", :"36", :"37", :"38", :"39",
 :"40", :"41", :"42", :"43", :"44", :"45", :"46", :"47", :"48", :"49", :"50",
 :"51"]>
```

#### Add the SDR to the pooler. Notice that the values are updated in the pooler. 
The neurons have also been updated with the subset.

```elixir
iex(7)> GenServer.cast(pid, {:send, sdr})                           
Added to pooler 30
:ok
Added to pooler 31
Added to pooler 32
Added to pooler 33
Added to pooler 34
...
...
Added to pooler 35

#MapSet<[:"38", :"40", :"45", :"47", :"51"]>
#MapSet<[:"38", :"40", :"45", :"47", :"51"]>
#MapSet<[:"38", :"40", :"45", :"47", :"51"]>
#MapSet<[:"38", :"40", :"45", :"47", :"51"]>
...
...
#MapSet<[:"38", :"40", :"45", :"47", :"51"]>
```

#### Verify that the pooler has been updated

```elixir
iex(8)> GenServer.call(pid, :get_state)                             
%{
  curr: #MapSet<[:"30", :"31", :"32", :"33", :"34", :"35", :"36", :"37", :"38",
   :"39", :"40", :"41", :"42", :"43", :"44", :"45", :"46", :"47", :"48", :"49",
   :"50", :"51"]>,
  pool: #MapSet<[:"31", :"20", :"40", :"36", :"6", :"15", :"9", :"21", :"39",
   :"14", :"49", :"47", :"51", :"11", :"4", :"1", :"32", :"10", :"5", :"45",
   :"18", :"12", :"30", :"50", :"16", :"37", :"46", :"3", :"44", :"0", :"41",
   :"33", :"42", :"13", :"17", :"34", :"48", :"7", :"38", :"35", :"19", :"8",
   :"43", :"2"]>,
  prev: #MapSet<[:"0", :"1", :"10", :"11", :"12", :"13", :"14", :"15", :"16",
   :"17", :"18", :"19", :"2", :"20", :"21", :"3", :"4", :"5", :"6", :"7", :"8",
   :"9"]>,
  subset: #MapSet<[:"38", :"40", :"45", :"47", :"51"]>
}
```

#### Verify connectivity to the neurons

```elixir
iex(9)> pd = String.to_atom("#{21}")
:"21"

iex(10)> send pd, {:read, "Hello World"}
"Hello World"
{:read, "Hello World"}

```


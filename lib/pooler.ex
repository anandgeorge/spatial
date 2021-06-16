defmodule Pooler do
	use GenServer

	def init(args) do
		IO.puts("Pooler initialised")
		_n = Keyword.get(args, :n, 121)
		pool = MapSet.new()
		curr = MapSet.new()
		prev = MapSet.new()
		subset = MapSet.new()
		state = %{pool: pool, curr: curr, prev: prev, subset: subset}
		{:ok, state}
	end

	def handle_call(:get_state, _from, state) do
		{:reply, state, state}
	end

	def handle_cast({:send, sdr}, state) do
		MapSet.difference(sdr, state.pool)
		|> MapSet.to_list()
		|> Enum.map(fn x -> 
			pid = spawn(Neuron, :run, [])
  			id = String.to_atom("#{x}")
			Process.register(pid, id)
			IO.puts("Added to pooler #{id}")
		end)
		subset = Enum.take_random(sdr, 5) |> MapSet.new()
		state.curr
		|> MapSet.to_list()
		|> Enum.map(fn x -> 
			send x, {:add, subset}
		end)
		pool = MapSet.union(state.pool, sdr)
		{:noreply, %{state | pool: pool, curr: sdr, prev: state.curr, subset: subset}}
	end
end
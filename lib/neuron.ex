defmodule Neuron do
	use Agent

	def start_link(id) do
		Agent.start_link(fn -> MapSet.new() end, name: id)
	end

end


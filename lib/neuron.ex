defmodule Neuron do
	def run do
		receive do
			{:add, subset} -> IO.inspect(subset)
			{:read, msg} -> IO.inspect(msg)
		end
		run()
	end
end
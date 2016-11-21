defmodule DataIngestion.StreamConsumer do
  use GenServer

  #############
  # Public API

  def start_link(name \\ nil) do
    GenServer.start_link(__MODULE__, %{ping_count: 0}, name: name)
  end

  def ping(pid) do
    GenServer.cast(pid, {:ping})
  end

  def get_ping_count(pid) do
    GenServer.call(pid, {:get_count})
  end

  def ingest_stream(pid, url) do
    GenServer.cast(pid, {:ingest_stream, url})
  end

  #####################
  # GenServer callbacks

  def handle_cast({:ping}, state) do
    IO.puts "pong"
    {:noreply, Map.put(state, :ping_count, state.ping_count + 1)}
  end

  def handle_cast({:ingest_stream, url}, state) do
    {:ok, expid} = EventsourceEx.new(url, stream_to: self)
    IO.inspect expid
    {:noreply, Map.put(state, :url, url)}
  end

  def handle_call({:get_count}, _from, state) do
    {:reply, state.ping_count, state}
  end

  # handles calls from EventsourceEx
  def handle_info(message, state) do
    IO.inspect message
    IO.puts "********************************"
    {:noreply, state}
  end
end

defmodule Dataingestion.StreamConsumer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :ingestor)
  end

  def ping(pid) do
    GenServer.cast(pid, {:ping})
  end

  def ingest_stream(pid, url) do
    GenServer.cast(pid, {:ingest_stream, url})
  end

  def handle_cast({:ingest_stream, url}, state) do
    {:ok, expid} = EventsourceEx.new(url, stream_to: self)
    {:noreply, %{state | expid: expid}}
  end

  def handle_cast({:ping}, state) do
    IO.puts "pong"
    {:noreply, state}
  end

  def handle_info(message, state) do
    IO.inspect message
    IO.puts "********************************"
    {:noreply, state}
  end
end

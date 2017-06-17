defmodule Exkube.HealthSupervisor do
  @moduledoc """
  Periodically pings the k8s API to check system health
  """

  use GenServer

  def start_link(api_url, ok_callback, error_callback) do
    GenServer.start_link(__MODULE__, [api_url: api_url, ok_callback: ok_callback, error_callback: error_callback], [])
  end

  def init([api_url, ok_callback, error_callback]) do
    schedule_work()
    {:ok, [api_url, ok_callback, error_callback]}
  end

  def handle_info(:work, state) do
    state = do_work(state)
    schedule_work()
    {:noreply, state}
  end

  defp do_work(state) do
    case Exkube.Base.status(state[:api_url]) do
      {:ok, _} ->
        state[:ok_callback].(state[:api_url])
      {:error, _} ->
        state[:error_callback].(state[:api_url])
    end
    state
  end

  defp schedule_work do
    Process.send_after(self(), :work, 5_000)
  end

end

defmodule Exkube.Base do
  @moduledoc """
  Module for interacting with the Kubernetes API.
  """

  alias Poison, as: JSON
  use HTTPoison.Base
  require Logger

  @doc """
  Checks the health endpoint of Kubernetes cluster

  Returns `{:ok, "ok"}` if healthy or `{:error, %{status_code, body}}` if not
  """
  def status(api_url) do
    url = api_url <> "/healthz"
    result = HTTPoison.request!(:get, url, "", [], hackney: [Application.get_env(:exkube, :insecure_ca)])
    %HTTPoison.Response{status_code: status_code, body: body} = result

    case status_code do
      200 ->
        {:ok, body}
      _ ->
        {:error, %{status_code: status_code, body: body}}
    end
  end
end

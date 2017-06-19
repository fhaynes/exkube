defmodule Exkube.Namespaces do
  @moduledoc """
  This module contains functions for working with Namespaces
  """

  use HTTPoison.Base

  require Logger
  alias Exkube.Base

  @doc """
  This gets all of the Namespaces
  """
  def all do
    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = Base.get("api/v1/namespaces")
    processed = Base.process_response_status_code(body, status_code)

    # We need to process the result a bit to extract only the Namespace names
    case processed do
      {:ok, data} ->
        namespaces = Enum.reduce(data["items"], [],
          fn(n), acc ->
            [n["metadata"]["name"] | acc]
          end
        )
        {:ok, namespaces}
      _ ->
        {:error, status_code}
    end
  end

  @doc """
  This retrieves the details for one Namespace if it exists
  """
  def one(%{namespace: namespace}) do
    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = Base.get("api/v1/namespaces/" <> namespace)
    Base.process_response_status_code(body, status_code)
  end

  @doc """
  This creates a new Namespace if it doesn't exist
  """
  def create(%{namespace: namespace}) do
    body = Poison.encode!(%{
      kind: "Namespace",
      apiVersion: "v1",
      metadata: %{
        name: namespace,
        labels: %{
          name: namespace
        }
      }
    })

    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = Base.post("api/v1/namespaces", body)
    Base.process_response_status_code(body, status_code)
  end

  @doc """
  This creates a new Namespace if it doesn't exist
  """
  def delete(%{namespace: namespace}) do
    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = Base.delete("api/v1/namespaces/" <> namespace)
    Base.process_response_status_code(body, status_code)
  end

end

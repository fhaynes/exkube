defmodule Exkube.Deployments do
  @moduledoc """
  This module contains functions for working with Deployments
  """

  require Logger
  alias Exkube.Base

  @doc """
  This gets all of the Deployments
  """
  def all do
    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = Base.get("apis/apps/v1beta1/deployments")
    processed = Base.process_response_status_code(body, status_code)

    # We need to process the result a bit to extract only the Namespace names
    case processed do
      {:ok, data} ->
        deployments = Enum.reduce(data["items"], [],
          fn(n), acc ->
            [%{name: n["metadata"]["name"], namespace: n["metadata"]["namespace"]} | acc]
          end
        )
        Logger.debug(inspect(deployments))
        {:ok, deployments}
      _ ->
        {:error, status_code}
    end
  end

  @doc """
  Lists all the Deployments in a specific Namespace
  """
  def all(namespace) do
    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} = Base.get("apis/apps/v1beta1/namespaces/" <> namespace <> "/deployments")
    processed = Base.process_response_status_code(body, status_code)

    # We need to process the result a bit to extract only the Namespace names
    case processed do
      {:ok, data} ->
        deployments = Enum.reduce(data["items"], [],
          fn(n), acc ->
            [%{name: n["metadata"]["name"], namespace: n["metadata"]["namespace"]} | acc]
          end
        )
        Logger.debug(inspect(deployments))
        {:ok, deployments}
      _ ->
        {:error, status_code}
    end
  end

  @doc """
  Gets the details of one Deployment. Defaults to the default Namespace if one is
  not specified.
  """
  def one(namespace \\ "default") do
    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} =
      Base.get("apis/apps/v1beta1/namespaces/" <> namespace <> "/deployments/" <> namespace)

    processed = Base.process_response_status_code(body, status_code)

    # We need to process the result a bit to extract only the Namespace names
    case processed do
      {:ok, data} ->
        {:ok, processed}
      _ ->
        {:error, status_code}
    end
  end
end

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
        {:ok, deployments}
      _ ->
        {:error, status_code}
    end
  end

  @doc """
  Gets the details of one Deployment. Defaults to the default Namespace if one is
  not specified.
  """
  def one(namespace \\ "default", deployment) do
    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} =
      Base.get("apis/apps/v1beta1/namespaces/" <> namespace <> "/deployments/" <> deployment)

    processed = Base.process_response_status_code(body, status_code)
  end

  @doc """
  Creates a Deployment in a specific Namespace. Namespace is default if one is
  not specified.
  """
  def create(deployment, namespace \\ "default") do
    body = Poison.encode!(%{
      kind: "Deployment",
      apiVersion: "apps/v1beta1",
      metadata: %{
        name: deployment.name,
      },
      spec: %{
        replicas: deployment.replicas,
        template: %{
          metadata: %{
            labels: deployment.template_labels
          },
          spec: %{
            containers: deployment.containers
          }
        }
      }
    })

    {:ok, %HTTPoison.Response{status_code: status_code, body: body}} =
      Base.post("apis/apps/v1beta1/namespaces/" <> namespace <> "/deployments", body)

    Logger.debug("Body is: " <> inspect(body))
    processed = Base.process_response_status_code(body, status_code)
  end
end

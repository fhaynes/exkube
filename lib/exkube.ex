defmodule Exkube.Base do
  @moduledoc """
  Module for interacting with the Kubernetes API.
  """

  alias Poison, as: JSON
  use HTTPoison.Base
  require Logger

  @kube_user Application.get_env(:exkube, :kube_user)
  @kube_password Application.get_env(:exkube, :kube_password)
  @insecure_ca Application.get_env(:exkube, :insecure_ca)
  @endpoint Application.get_env(:exkube, :api_url)

  @doc """
  Checks the health endpoint of Kubernetes cluster

  Returns `{:ok, "ok"}` if healthy or `{:error, %{status_code, body}}` if not
  """
  def status(api_url) do
    url = api_url <> "/healthz"
    result = HTTPoison.request!(:get, url, "", [], hackney: [@insecure_ca])
    %HTTPoison.Response{status_code: status_code, body: body} = result

    case status_code do
      200 ->
        {:ok, body}
      _ ->
        {:error, %{status_code: status_code, body: body}}
    end
  end

  @doc """
  Processes the status code out of a response and returns a tuple
  """
  def process_response_status_code(body, status_code) do
    case status_code do
      403 ->
        {:error, :forbidden}
      404 ->
        {:error, :not_found}
      200 ->
        data = JSON.decode!(body)
        {:ok, data}
      201 ->
        data = JSON.decode!(body)
        {:ok, data}
      _ ->
        data = JSON.decode!(body)
        {:error, status_code: status_code, body: data}
      end
  end

  @doc """
  Builds up a URL
  """
  def process_url(url) do
    @endpoint <> url
  end

  @doc """
  Adds in the necessary auth headers if they exist
  """
  def process_request_options(options) do
    options ++ [hackney: [@insecure_ca, basic_auth: {@kube_user, @kube_password}]]
  end

  @doc """
  Adds in the necessary headers
  """
  def process_request_headers(headers) do
    headers ++ [{"Content-Type", "application/json"}]
  end
  
end

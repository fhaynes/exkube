defmodule Exkube.DeploymentsTest do
  @moduledoc """
  Tests for the Namespaces module
  """
  use ExUnit.Case, async: true
  alias Exkube.Deployments
  require Logger

  test "can list deployments", %{} do
    result = Deployments.all
    assert elem(result, 0) == :ok
  end

  test "can create and delete deployment", %{} do
    deployment = %{
      "name": "elixir-test-deployment",
      "labels": %{
        "app": "elixir-test"
      },
      "replicas": 1,
      "template_labels": %{
        "app": "elixir-test",
      },
      "containers": [
        %{
          "name": "nginx",
          "image": "nginx:1.7.9",
          "ports": [
            %{
              "containerPort": 80
            }
          ]
        }
      ]
    }
    result = Deployments.create(deployment)
    assert elem(result, 0) == :ok

    result = Deployments.delete("elixir-test-deployment")
    assert elem(result, 0) == :ok
  end

end

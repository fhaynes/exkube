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
  #
  # test "can get one namespace", %{} do
  #   result = Namespaces.one(%{namespace: "uops"})
  #   assert elem(result, 0) == :ok
  # end
  #
  # test "can create and delete new namespace", %{} do
  #   name = "test-" <> Integer.to_string(:rand.uniform(1000))
  #   result = Namespaces.create(%{namespace: name})
  #   assert elem(result, 0) == :ok
  #   result = Namespaces.delete(%{namespace: name})
  #   assert elem(result, 0) == :ok
  # end

end

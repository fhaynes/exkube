defmodule ExkubeTest do
  use ExUnit.Case


  test "get status" do
    result = Exkube.Base.status("https://api.kubernetes.ausw1a.int.uops.internal.unity3d.com")
    assert result == {:ok, "ok"}
  end
end

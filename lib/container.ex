defmodule Container do
  @moduledoc """
  Contains functions for building container manifests
  """

  # A container name is just a string
  @type container_name :: String.t
  # Image name is the key image mapping to a string
  @type image :: %{String.t => String.t}
  # Labels are a list of the Label type
  @type labels :: [label]
  # Label is a key/value pair
  @type label :: %{String.t => String.t}
  # Number of replicas is just an Integer
  @type replicas :: integer

  
  @type port_number :: integer
  @type hostIP :: String.t
  @type port_name :: String.t
  @type port_protocol :: String.t

  @type ports :: [port]

  #@type container


  def build_container(name, labels, image, ports) do

  end

end

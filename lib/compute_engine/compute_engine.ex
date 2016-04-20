defmodule GCloudex.ComputeEngine do

  @moduledoc """
  Keeps the common definitions for the several Compute Engine modules.
  """

  @doc """
  Offers the common needed endpoints, module aliases and project id for the 
  Compute Engine API.
  """
  @spec client() :: HTTPResponse.t
  def client do 
    quote do 
      @project_id   GCloudex.get_project_id
      @instance_ep "https://www.googleapis.com/compute/v1/projects/#{@project_id}/zones"
      @no_zone_ep  "https://www.googleapis.com/compute/v1/projects/#{@project_id}"

      alias GCloudex.ComputeEngine.Request, as: Request
      alias HTTPoison.HTTPResponse
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end  
end
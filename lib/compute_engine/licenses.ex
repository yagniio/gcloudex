defmodule GCloudex.ComputeEngine.Licenses do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Licenses endpoint.
  """

  @doc """
  Returns the specified 'license' resource.
  """
  @spec get_license(binary, binary) :: HTTPResponse.t
  def get_license(license, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request :get, @no_zone_ep <> "/global/licenses/#{license}", [], "", query
  end
end
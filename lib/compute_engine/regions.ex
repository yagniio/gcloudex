defmodule GCloudex.ComputeEngine.Regions do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Regions endpoint.
  """

  @doc """
  Retrieves a list of region resources.
  """
  @spec list_regions() :: HTTPResponse.t
  def list_regions do
    Request.request :get, @no_zone_ep <> "/regions", [], ""
  end

  @doc """
  Retrieves a list of region resources according to the given 'query_params'.
  """
  @spec list_regions(map) :: HTTPResponse.t
  def list_regions(query_params) do
    query = query_params |> URI.encode_query

    Request.request :get, @no_zone_ep <> "/regions", [], "", query
  end    

  @doc """
  Returns the specified 'region' resource.
  """
  @spec get_region(binary) :: HTTPResponse.t
  def get_region(region, fields \\ "") do 
    query = %{"fields" => fields} |> URI.encode_query

    Request.request :get, @no_zone_ep <> "/regions/#{region}", [], "", query
  end  
end
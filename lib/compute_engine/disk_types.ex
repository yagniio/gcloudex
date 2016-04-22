defmodule GCloudex.ComputeEngine.DiskTypes do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Disk Types endpoint.
  """

  @doc """
  Retrieves a list of disk types available to the specified 'zone' according
  to the given 'query_params' if provided.
  """
  @spec list_disk_types(binary, map) :: HTTPResponse.t
  def list_disk_types(zone, query_params \\ %{}) do 
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/zones/#{zone}/diskTypes", [], "", query
  end
  
  @doc """
  Returns the specified 'disk_type' if it exists in the given 'zone'.
  """
  @spec get_disk_type(binary, binary, binary) :: HTTPResponse.t
  def get_disk_type(zone, disk_type, fields \\ "") do
    if not Regex.match?(~r/$[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?/, disk_type) do 
      raise ArgumentError, 
        message: "The disk type must match the regular expression "
                 <> "'[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?'."
    end

    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request(
      :get, 
      @no_zone_ep <> "/zones/#{zone}/diskTypes/#{disk_type}",
      [],
      "",
      query)
  end

  @doc """
  Retrieves an aggregated list of Disk Types according to the
  'query_params' if provided.
  """
  @spec aggregated_list_of_disk_types(map) :: HTTPResponse.t
  def aggregated_list_of_disk_types(query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/aggregated/diskTypes", [], "", query
  end

end
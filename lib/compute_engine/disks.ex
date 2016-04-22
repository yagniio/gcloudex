defmodule GCloudex.ComputeEngine.Disks do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Disks endpoint.
  """

  @doc """
  Retrieves a list of persistent disks contained within the specified 'zone' and
  according to the given 'query_params' if provided.
  """
  @spec list_disks(binary, map) :: HTTPResponse.t
  def list_disks(zone, query_params \\ %{}) do
    query = query_params |> URI.encode_query
    
    HTTP.request :get, @no_zone_ep <> "/zones/#{zone}/disks", [], "", query
  end

  @doc """
  Returns a specified persistent 'disk' if it exists in the given 'zone'. The
  HTTP reply contains a Disk Resource in the body.
  """
  @spec get_disk(binary, binary, binary) :: HTTPResponse.t
  def get_disk(zone, disk, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields  

    HTTP.request :get, @no_zone_ep <> "/zones/#{zone}/disks/#{disk}", [], "", query
  end

  @doc """
  Creates a persistent disk in the specified 'zone' using the data in the 
  'disk_resource'. You can create a disk with a 'source_image' or a 
  sourceSnapshot (provided in the 'disk_resource'), or create an empty 500 GB 
  data disk by omitting all properties. You can also create a disk that is 
  larger than the default size by specifying the sizeGb property in the 
  'disk_resource'.
  """
  @spec insert_disk(binary, map, binary, binary) :: HTTPResponse.t
  def insert_disk(zone, disk_resource, source_image \\ "", fields \\ "") do 
    if not Map.has_key?(disk_resource, "name") do 
      raise ArgumentError, message: "The Disk Resource must contain at least the 'name' key."
    end

    query = 
      if source_image != "" do 
        ComputeEngine.fields_binary_to_map(fields) <> "&sourceImage=#{source_image}"
      else
        ComputeEngine.fields_binary_to_map fields
      end

    body = disk_resource |> Poison.encode!

    HTTP.request(
      :post,
      @no_zone_ep <> "/zones/#{zone}/disks",
      [{"Content-Type", "application/json"}],
      body,
      query)
  end

  @doc """
  Deletes the specified persistent 'disk' if it exists in the given 'zone'.
  """
  @spec delete_disk(binary, binary, binary) :: HTTPResponse.t
  def delete_disk(zone, disk, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request :delete, @no_zone_ep <> "/zones/#{zone}/disks/#{disk}", [], "", query
  end

  @doc """
  Resizes the specified persistent 'disk' if it exists in the given 'zone' to 
  the provided 'size_gb'.
  """
  @spec resize_disk(binary, binary, pos_integer, binary) :: HTTPResponse.t
  def resize_disk(zone, disk, size_gb, fields \\ "") when size_gb > 0 do 
    query = ComputeEngine.fields_binary_to_map fields
    body  = %{"sizeGb" => size_gb} |> Poison.encode!

    HTTP.request(
      :post, 
      @no_zone_ep <> "/zones/#{zone}/disks/#{disk}/resize", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)
  end

  @doc """
  Retrieves an aggregated list of persistent disks according to the given
  'query_params' if they're provided.
  """
  @spec aggregated_list_of_disks(map) :: HTTPResponse.t
  def aggregated_list_of_disks(query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/aggregated/disks", [], "", query
  end
  
  @doc """
  Creates a snapshot of a specified persistent 'disk' if it exists in the
  given 'zone' and according to the given 'resource'. The 'request' map must
  contain the keys "name" and "description" and "name" must obey the 
  refex '(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)'.
  """
  @spec create_snapshot(binary, binary, map, binary) :: HTTPResponse.t
  def create_snapshot(zone, disk, request, fields \\ "") do

    if request == %{} do 
      raise ArgumentError, 
        message: "The request cannot be empty. At least keys 'name' "
                 <> "and 'description' must be provided."
    end

    query = ComputeEngine.fields_binary_to_map fields
    body  = request |> Poison.encode!

    HTTP.request(
      :post, 
      @no_zone_ep <> "/zones/#{zone}/disks/#{disk}/createSnapshot",
      [{"Content-Type", "application/json"}],
      body,
      query)
  end
end
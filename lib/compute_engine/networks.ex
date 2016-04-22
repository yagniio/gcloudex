defmodule GCloudex.ComputeEngine.Networks do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Networks endpoint.
  """

  @doc """
  Retrieves the list of networks available according to the given 
  'query_params' if provided.
  """
  @spec list_networks(map) :: HTTPResponse.t
  def list_networks(query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/global/networks", [], "", query
  end

  @doc """
  Returns the speciefied 'network'.
  """
  @spec get_network(binary, binary) :: HTTPResponse.t
  def get_network(network, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request :get, @no_zone_ep <> "/global/networks/#{network}", [], "", query
  end

  @doc """
  Creates a network using the data specified in 'network_resource'. To read
  about the structure and properties of the Network Resource check
  https://cloud.google.com/compute/docs/reference/latest/networks#resource.
  """
  @spec insert_network(map, binary) :: HTTPResponse.t | no_return
  def insert_network(network_resource, fields \\ "") when is_map(network_resource) do
    if not "name" in Map.keys(network_resource) do 
      raise ArgumentError, message: "The 'name' property is required in the Network Resource."
    end

    query = ComputeEngine.fields_binary_to_map fields
    body  = network_resource |> Poison.encode!

    HTTP.request(
      :post, 
      @no_zone_ep <> "/global/networks", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)
  end
  
  @doc """
  Deletes the specified 'network'.
  """
  @spec delete_network(binary, binary) :: HTTPResponse.t
  def delete_network(network, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request(
      :delete,
      @no_zone_ep <> "/global/networks/#{network}",
      [], 
      "",
      query)
  end
end
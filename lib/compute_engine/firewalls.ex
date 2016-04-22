defmodule GCloudex.ComputeEngine.Firewalls do
  use GCloudex.ComputeEngine, :client
  
  @moduledoc """
  
  """

  @doc """
  Retrieves the list of firewall rules according to the 'query_params' if 
  provided.
  """
  @spec list_firewalls(map) :: HTTPResponse.t
  def list_firewalls(query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/global/firewalls", [], "", query
  end

  @doc """
  Returns the specified 'firewall'.
  """
  @spec get_firewall(binary, binary) :: HTTPResponse.t
  def get_firewall(firewall, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request :get, @no_zone_ep <> "/global/firewalls/#{firewall}", [], "", query
  end

  @doc """
  Creates a new firewall using the data included in 'firewall_resource'. For 
  information about the structure and properties of Firewall Resources check
  https://cloud.google.com/compute/docs/reference/latest/firewalls#resource
  """
  @spec insert_firewall(map, binary) :: HTTPResponse.t
  def insert_firewall(firewall_resource, fields \\ "") when is_map(firewall_resource) do
    query = ComputeEngine.fields_binary_to_map fields
    body  = firewall_resource |> Poison.encode!

    HTTP.request(
      :post, 
      @no_zone_ep <> "/global/firewalls", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)
  end

  @doc """
  Updates the specified 'firewall' rule with the data included in the 
  'firewall_resource'. This function supports patch semantics.
  """
  @spec patch_firewall(binary, map, binary) :: HTTPResponse.t
  def patch_firewall(firewall, firewall_resource, fields \\ "") when is_map(firewall_resource) do
    query = ComputeEngine.fields_binary_to_map fields
    body  = firewall_resource |> URI.encode_query

    HTTP.request(
      :patch, 
      @no_zone_ep <> "/global/firewalls/#{firewall}", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)
  end

  @doc """
  Updates the specified 'firewall' rule with the data included in the 
  'firewall_resource'.
  """
  @spec update_firewall(binary, map, binary) :: HTTPResponse.t
  def update_firewall(firewall, firewall_resource, fields \\ "") when is_map(firewall_resource) do
    query = ComputeEngine.fields_binary_to_map fields
    body  = firewall_resource |> URI.encode_query

    HTTP.request(
      :put, 
      @no_zone_ep <> "/global/firewalls/#{firewall}", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)    
  end

  @doc """
  Deletes the specified 'firewall'.
  """
  @spec delete_firewall(binary, binary) :: HTTPResponse.t
  def delete_firewall(firewall, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request(
      :delete,
      @no_zone_ep <> "/global/firewalls/#{firewall}",
      [],
      "",
      query)
  end
end
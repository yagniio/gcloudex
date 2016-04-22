defmodule GCloudex.ComputeEngine.InstanceGroups do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  
  """

  @doc """
  Retrieves the list of instance groups that are located in the 
  specified 'zone'.
  """
  @spec list_instance_groups(binary, map) :: HTTPResponse.t
  def list_instance_groups(zone, query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/zones/#{zone}/instanceGroups", [], "", query
  end

  @doc """
  Lists the instances in the specified 'instance_group' if it exists in the 
  given 'zone'. A filter for the state of the instances can be passed
  through 'instance_state'.
  """
  @spec list_instances_in_group(binary, binary, binary, map) :: HTTPResponse.t
  def list_instances_in_group(zone, instance_group, instance_state \\ "", query_params \\ %{}) do
    query = query_params |> URI.encode_query
    body  = %{"instanceState" => instance_state} |> Poison.encode!

    HTTP.request(
      :post,
      @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{instance_group}/listInstances",
      [{"Content-Type", "application/json"}],
      body,
      query)
  end
  
  @doc """
  Returns the specified 'instance_group' if it exists in the given 'zone'.
  """
  @spec get_instance_group(binary, binary, binary) :: HTTPResponse.t
  def get_instance_group(zone, instance_group, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request(:get, @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{instance_group}", [], "", query)
  end

  @doc """
  Creates an Instance Group in the specified 'zone' using the data provided
  in 'instance_group_resource'. For the structure and properties required in
  the Instance Group Resources check
  https://cloud.google.com/compute/docs/reference/latest/instanceGroups#resource
  """
  @spec insert_instance_group(binary, map, binary) :: HTTPResponse.t
  def insert_instance_group(zone, instance_group_resource, fields \\ "") when is_map(instance_group_resource) do
    query = ComputeEngine.fields_binary_to_map fields
    body  = instance_group_resource |> Poison.encode!
    
    HTTP.request(
      :post,
      @no_zone_ep <> "/zones/#{zone}/instanceGroups",
      [{"Content-Type", "application/json"}],
      body,
      query)
  end

  def delete_instance_group(zone, instance_group, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request(
      :delete,
      @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{instance_group}",
      [],
      "",
      query) 
  end
end
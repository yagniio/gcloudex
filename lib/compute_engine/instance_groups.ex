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

  @doc """
  Deletes the specified 'instance_group' if it exists in the given 'zone'.
  """
  @spec delete_instance_group(binary, binary, binary) :: HTTPResponse.t
  def delete_instance_group(zone, instance_group, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request(
      :delete,
      @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{instance_group}",
      [],
      "",
      query) 
  end

  @doc """
  Retrieves the list of Instance Groups and sorts them by zone.
  """
  @spec aggregated_list_of_instance_groups(map) :: HTTPResponse.t
  def aggregated_list_of_instance_groups(query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request(:get, @no_zone_ep <> "/aggregated/instanceGroups", [], "", query)
  end

  @doc """
  Adds a list of 'instances' to the specified 'instance_group' if it exists in
  the given 'zone'.
  """
  @spec add_instances_to_group(binary, binary, [binary], binary) :: HTTPResponse.t
  def add_instances_to_group(zone, instance_group, instances, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields
    body  = %{"instances" => build_list_of_instances(instances, [])}
    |> Poison.encode!

    HTTP.request(
      :post, 
      @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{instance_group}/addInstances", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)
  end

  @doc """
  Removes the 'instances' from the provided 'instance_group' if it exists in
  the given 'zone'.
  """
  @spec remove_instances_from_group(binary, binary, [binary], binary) :: HTTPResponse.t
  def remove_instances_from_group(zone, instance_group, instances, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields
    body  = %{"instances" => build_list_of_instances(instances, [])}
    |> Poison.encode!

    HTTP.request(
      :post, 
      @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{instance_group}/removeInstances", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)    
  end

  @doc """
  Sets the named 'ports' for the specified 'instance_group' if it exists in the
  given 'zone'. The 'ports' must be passed as a list of tuples with the format
  {<name>, <port>}.
  """
  @spec set_named_ports_for_group(binary, binary, [{binary, binary}], binary, binary) :: HTTPResponse.t
  def set_named_ports_for_group(zone, instance_group, ports, fingerprint \\ "", fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields
    body  = %{"namedPorts" => build_list_of_ports(ports, [])}

    body = 
      if fingerprint != "" do 
        body |> Map.put_new("fingerprint", fingerprint) |> Poison.encode!
      else
        body |> Poison.encode!
      end

    HTTP.request(
      :post, 
      @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{instance_group}/setNamedPorts", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)
  end

  defp build_list_of_instances([head | []], state), do: state ++ [%{"instance" => head}]
  defp build_list_of_instances([head | tail], state) do
    build_list_of_instances tail, state ++ [%{"instance" => head}]
  end

  defp build_list_of_ports([_head = {name, port} | []], state), do: state ++ [%{"name" => name, "port" => port}]
  defp build_list_of_ports([_head = {name, port} | tail], state) do 
    build_list_of_ports tail, state ++ [%{"name" => name, "port" => port}]
  end
end
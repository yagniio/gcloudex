defmodule GCloudex.ComputeEngine.MachineTypes do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Machine Types endpoint.
  """

  @doc """
  Retrieves a list of machine types available in the specified 'zone' and 
  that fit in the given 'query_params' if present.
  """
  @spec list_machine_types(binary, map) :: HTTPResponse.t
  def list_machine_types(zone, query_params \\ %{}) do 
    query = query_params |> URI.encode_query

    HTTP.request(:get, @instance_ep <> "/#{zone}/machineTypes", [], "", query)
  end

  @doc """
  Returns the specified 'machine_type' in the given 'zone'.
  """
  @spec get_machine_type(binary, binary, binary) :: HTTPResponse.t
  def get_machine_type(zone, machine_type, fields \\ "") do 
    query = %{"fields" => fields} |> URI.encode_query

    HTTP.request(
      :get, 
      @instance_ep <> "/#{zone}/machineTypes/#{machine_type}", 
      [], 
      "", 
      query)
  end

  @doc """
  Returns an aggragated list of machine types following the specified 
  'query_params' if present.
  """
  @spec get_aggregated_list_of_machine_types(map) :: HTTPResponse.t
  def get_aggregated_list_of_machine_types(query_params \\ %{}) do 
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/aggregated/machineTypes", [], "", query
  end  
end
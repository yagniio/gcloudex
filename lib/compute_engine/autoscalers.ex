defmodule GCloudex.ComputeEngine.Autoscalers do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Autoscalers endpoint.
  """

  @doc """
  Retrieves a list of autoscalers contained within the specified 'zone' and 
  according to the 'query_params' if provided.
  """
  @spec list_autoscalers(binary, map) :: HTTPResponse.t
  def list_autoscalers(zone, query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/zones/#{zone}/autoscalers", [], "", query
  end

  @doc """
  Returns the specified 'autoscaler' resource if it exists in the given 'zone'.
  """
  @spec get_autoscaler(binary, binary, binary) :: HTTPResponse.t
  def get_autoscaler(zone, autoscaler, fields \\ "") do
    if not Regex.match?(~r/$[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?/, autoscaler) do 
      raise ArgumentError, 
        message: "The autoscaler must match the regular "
                  <> "expression '[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?'."
    end

    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request :get, @no_zone_ep <> "/zones/#{zone}/autoscalers/#{autoscaler}", [], "", query
  end

  @doc """
  Creates an autoscaler in the given 'zone' using the data provided in 
  'autoscaler_resource'.

  For the properties and structure of the 'autoscaler_resource' check
  https://cloud.google.com/compute/docs/reference/latest/autoscalers#resource
  """
  @spec insert_autoscaler(binary, map, binary) :: HTTPResponse.t | no_return
  def insert_autoscaler(zone, autoscaler_resource, fields \\ "") do
    if false in (["name", "target"] |> Enum.map(fn x -> if x in Map.keys(autoscaler_resource) do true end end)) do 
      raise ArgumentError, 
        message: "The Autoscaler Resource must have at least the fields 'name' and 'target'."
    end

    query = ComputeEngine.fields_binary_to_map fields
    body  = autoscaler_resource |> Poison.encode!

    HTTP.request(
      :post, 
      @no_zone_ep <> "/zones/#{zone}/autoscalers", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)
  end

  @doc """
  Updates 'autoscaler_name' in the specified 'zone' using the data included in
  the 'autoscaler_resource'. This function supports patch semantics.
  """
  @spec patch_autoscaler(binary, binary, map, binary) :: HTTPResponse.t
  def patch_autoscaler(zone, autoscaler_name, autoscaler_resource, fields \\ "") do 
    query = 
      if fields == "" do 
        %{"autoscaler" => autoscaler_name} |> URI.encode_query
      else
        %{"autoscaler" => autoscaler_name, "fields" => fields} |> URI.encode_query
      end

    body  = autoscaler_resource |> Poison.encode!

    HTTP.request(
      :patch, 
      @no_zone_ep <> "/zones/#{zone}/autoscalers", 
      [{"Content-Type", "application/json"}],
      body,
      query)
  end

  @doc """
  Updates an autoscaler in the specified 'zone' using the data included in 
  the 'autoscaler_resource'. The 'autoscaler_name' may be provided but it's
  optional.
  """
  @spec update_autoscaler(binary, binary, map, binary) :: HTTPResponse.t
  def update_autoscaler(zone, autoscaler_name \\ "", autoscaler_resource, fields \\ "") do
    body  = autoscaler_resource |> Poison.encode!
    query = 
      case {autoscaler_name == "", fields == ""} do 
        {true, true} ->
          ""
        {true, false} ->
          %{"fields" => fields} |> URI.encode_query
        {false, true} ->
          %{"autoscaler" => autoscaler_name} |> URI.encode_query
        {false, false} ->
          %{"autoscaler" => autoscaler_name, "fields" => fields} |> URI.encode_query
      end    

    HTTP.request(
      :put, 
      @no_zone_ep <> "/zones/#{zone}/autoscalers",
      [{"Content-Type", "application/json"}],
      body,
      query)
  end

  @doc """
  Deletes the specified 'autoscaler' if it exists in the given 'zone'.
  """
  @spec delete_autoscaler(binary, binary, binary) :: HTTPResponse.t
  def delete_autoscaler(zone, autoscaler, fields \\ "") do
    query = ComputeEngine.fields_binary_to_map fields

    HTTP.request(:delete, @no_zone_ep <> "/zones/#{zone}/autoscalers/#{autoscaler}", [], "", query)
  end

  @doc """
  Retrieves an aggregated list of autoscalers according to the given 
  'query_params' if provided.
  """
  @spec aggregated_list_of_autoscalers(map) :: HTTPResponse.t
  def aggregated_list_of_autoscalers(query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request(:get, @no_zone_ep <> "/aggregated/autoscalers", [], "", query)
  end
end
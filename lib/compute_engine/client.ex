defmodule GCloudex.ComputeEngine.Client do
  alias GCloudex.ComputeEngine.Request, as: Request
  alias HTTPoison.HTTPResponse

  @moduledoc """
  Wrapper for Google Compute Engine API.
  """

  @project_id   GCloudex.get_project_id
  @instance_ep "https://www.googleapis.com/compute/v1/projects/#{@project_id}/zones"

  #################
  ### Instances ###
  #################

  @doc """
  Lists all instances in the given 'zone'.
  """
  @spec list_instances(binary) :: HTTPResponse.t
  def list_instances(zone) do 
    Request.request :get, @instance_ep <> "/#{zone}/instances", [], ""
  end

  @doc """
  Lists all instances in the given 'zone' obeying the given 'query_params'.
  The 'query_params' must be passed as a list of tuples in the form:
    [{key :: binary, val :: binary}]
  """
  @spec list_instances(binary, list) :: HTTPResponse.t
  def list_instances(zone, query_params) do 
    Request.request_query :get, @instance_ep <> "/#{zone}/instances", 
      [], "", "?" <> parse_query_params(query_params, "")
  end

  @doc """
  Returns the data about the 'instance' in the given 'zone' if it exists.
  """
  @spec get_instance(binary, binary) :: HTTPResponse.t
  def get_instance(zone, instance) do
    Request.request :get, @instance_ep <> "/#{zone}/instances/#{instance}", [], ""
  end

  ########################
  ### HELPER FUNCTIONS ###
  ########################

  defp parse_query_params([{param, val} = _head | []], query), do: query <> param <> "=" <> val
  defp parse_query_params([{param, val} = _head | tail], query) do
    parse_query_params tail, query <> param <> "=" <> val <> "&"
  end  
end
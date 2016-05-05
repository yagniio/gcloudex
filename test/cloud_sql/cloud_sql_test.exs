defmodule Test.Dummy.CloudSQL do
  use GCloudex.CloudSQL.Impl, :cloud_sql

  @project_id GCloudex.get_project_id

  def request(verb, endpoint, headers \\ [], body \\ "") do 
    %{
      verb: verb,
      host: endpoint,
      body: body,
      headers:
        headers ++ 
        [
          {"x-goog-project-id", @project_id},
          {"Authorization", "Bearer Dummy Token"}
        ],
      opts: []
    }
  end

  def request_query(verb, endpoint, headers \\ [], body \\ "", parameters) do 
    %{
      verb: verb,
      host: endpoint <> "/" <> parameters,
      body: body,
      headers:
        headers ++ 
        [
          {"x-goog-project-id", @project_id},
          {"Authorization", "Bearer Dummy Token"}
        ],
      opts: []
    }  
  end  
end

defmodule CloudSQLTest do 
  use ExUnit.Case, async: true
  alias Test.Dummy.CloudSQL, as: API


  @project_id GCloudex.get_project_id
  @instance_ep  "https://www.googleapis.com/sql/v1beta4/projects/#{@project_id}/instances"
  @flag_ep      "https://www.googleapis.com/sql/v1beta4/flags"
  @operation_ep "https://www.googleapis.com/sql/v1beta4/projects/#{@project_id}/operations"
  @tiers_ep     "https://www.googleapis.com/sql/v1beta4/projects/#{@project_id}/tiers"  

  #######################
  ### Instances Tests ###
  #######################

  test "list_instances" do 
    expected = build_expected(:get, @instance_ep, [], "")

    assert expected == API.list_instances
  end    

  ########################
  ### Helper Functions ###
  ########################

  defp build_expected(verb, endpoint, headers \\ [], body \\ "", parameters \\ :empty) do
    map = %{
      verb: verb,
      host: endpoint,
      headers: 
        headers ++
        [
          {"x-goog-project-id", @project_id},
          {"Authorization", "Bearer Dummy Token"}
        ],        
      body: body,
      opts: []
    }

    if parameters != :empty do 
      Map.update(map, :host, endpoint <> "/" <> parameters)
    else
      map
    end
  end
end
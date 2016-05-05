defmodule Test.Dummy.CloudSQL do
  use GCloudex.CloudSQL.Impl, :cloud_sql
  require Logger

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

  def request_query(verb, endpoint, headers, body, parameters) do 
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

  test "get_instance" do 
    instance = "instance"
    expected = build_expected(:get, @instance_ep, [], "", instance)

    assert expected == API.get_instance instance
  end

  test "insert_instance (no opts)" do 
    name     = "name"
    opts     = %{}
    settings = %{settings_1: "abc", settings_2: "def"}
    tier     = "tier"
    headers  = [{"Content-Type", "application/json"}]
    body     = %{
      name: name,
      settings: Map.put(settings, :tier, tier)
    }
    |> Poison.encode!
    expected = build_expected(:post, @instance_ep, headers, body)

    assert expected == API.insert_instance name, opts, settings, tier
  end

  test "insert_instance (with opts)" do 
    name     = "name"
    opts     = %{first: "first", second: "second"}
    settings = %{settings_1: "abc", settings_2: "def"}
    tier     = "tier"
    headers  = [{"Content-Type", "application/json"}]
    body     = %{
      name: name,
      settings: Map.put(settings, :tier, tier),
      first: "first",
      second: "second"
    }
    |> Poison.encode!
    expected = build_expected(:post, @instance_ep, headers, body)

    assert expected == API.insert_instance name, opts, settings, tier
  end  

  test "delete_instance" do 
    instance = "instance"
    headers  = []
    body     = ""
    expected = build_expected(:delete, @instance_ep, headers, body, instance)

    assert expected == API.delete_instance instance
  end

  test "clone_instance" do 
    instance     = "instance"
    dest_name    = "dest_name"
    bin_log_file = "bin_log_file"
    bin_log_pos  = "bin_log_pos"
    headers      = [{"Content-Type", "application/json"}]
    body         = %{
      "cloneContext" => %{
        "binLogCoordinates" => %{
          "kind"           => "sql#binLogCoordinates",
          "binLogFileName" => bin_log_file,
          "binLogPosition" => bin_log_pos
        },
        "destinationInstanceName" => dest_name,
        "kind" => "sql#cloneContext"
      }
    } |> Poison.encode!
    expected     = build_expected(:post, @instance_ep, headers, body, "#{instance}/clone")

    assert expected == API.clone_instance instance, dest_name, bin_log_file, bin_log_pos
  end

  test "restart_instance" do 
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, @instance_ep, headers, "", "#{instance}/restart")

    assert expected == API.restart_instance instance
  end

  test "start_replica" do 
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, @instance_ep, headers, "", "#{instance}/startReplica")

    assert expected == API.start_replica instance    
  end

  test "stop_replica" do 
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, @instance_ep, headers, "", "#{instance}/stopReplica")

    assert expected == API.stop_replica instance
  end

  test "promote_replica" do 
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, @instance_ep, headers, "", "#{instance}/promoteReplica")

    assert expected == API.promote_replica instance
  end

  test "failover_instance" do 
    instance         = "instance"
    settings_version = 123
    headers          = [{"Content-Type", "application/json"}]
    body             = %{
      "failoverContext" => %{
        "kind"            => "sql#failoverContext",
        "settingsVersion" => settings_version
      }
    } |> Poison.encode!
    expected = build_expected(:post, @instance_ep, headers, body, "#{instance}/failover")

    assert expected == API.failover_instance instance, settings_version
  end

  test "reset_ssl_config" do 
    instance = "instance"
    headers  = [{"Content-Type", "application/json"}]
    expected = build_expected(:post, @instance_ep, headers, "", "#{instance}/resetSslConfig")

    assert expected == API.reset_ssl_config instance
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
      Map.put(map, :host, endpoint <> "/" <> parameters)
    else
      map
    end
  end
end
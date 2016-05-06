defmodule Test.Dummy.ComputeEngine do
  use GCloudex.ComputeEngine.Impl, :compute_engine
  
  @project_id GCloudex.get_project_id

  def request(verb, endpoint, headers, body, query \\ "") do 
    %{
      verb: verb,
      endpoint: endpoint,
      body: body,
      headers: 
        headers ++ 
        [
          {"x-goog-project-id", @project_id},
          {"Authorization", "Bearer Dummy Token"}
        ],
      query: query
    }
  end
end

defmodule ComputeEngineTest do 
  use ExUnit.Case, async: true
  alias Test.Dummy.ComputeEngine, as: API

  @project_id   GCloudex.get_project_id
  @instance_ep "https://www.googleapis.com/compute/v1/projects/#{@project_id}/zones"
  @no_zone_ep  "https://www.googleapis.com/compute/v1/projects/#{@project_id}"

  #########################
  ### Autoscalers Tests ###
  #########################

  test "list_autoscalers (no fields)" do 
    zone     = "zone"
    headers  = []
    body     = ""
    endpoint = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_autoscalers zone
  end

  test "list_autoscalers (with fields)" do 
    zone     = "zone"
    headers  = []
    body     = ""
    query    = %{"key1" => "abc", "key2" => "def"}
    endpoint = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_autoscalers zone, query
  end  

  test "get_autoscaler (no fields)" do 
    zone       = "zone"
    autoscaler = "autoscaler"
    headers    = []
    body       = ""
    _query     = %{}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/autoscalers/#{autoscaler}"
    expected   = build_expected(:get, endpoint, headers, body)
    
    assert expected == API.get_autoscaler zone, autoscaler
  end  

  test "get_autoscaler (with fields)" do 
    zone       = "zone"
    autoscaler = "autoscaler"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/autoscalers/#{autoscaler}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)
    
    assert expected == API.get_autoscaler zone, autoscaler, fields
  end    

  test "insert_autoscaler (no fields)" do 
    zone       = "zone"
    resource   = %{"name" => "abc", "target" => "def"}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected   = build_expected(:post, endpoint, headers, body)
    
    assert expected == API.insert_autoscaler zone, resource
  end
 
  test "insert_autoscaler (with fields)" do 
    zone       = "zone"
    resource   = %{"name" => "abc", "target" => "def"}
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = resource |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)
    
    assert expected == API.insert_autoscaler zone, resource, fields
  end

  test "patch_autoscaler (no fields)" do 
    zone     = "zone"
    name     = "name"
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    query    = %{"autoscaler" => name}
    endpoint = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:patch, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.patch_autoscaler zone, name, resource
  end

  test "patch_autoscaler (with fields)" do 
    zone     = "zone"
    name     = "name"
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"autoscaler" => name, "fields" => fields}
    endpoint = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:patch, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.patch_autoscaler zone, name, resource, fields
  end  

  test "update_autoscaler (no fields)" do 
    zone     = "zone"
    name     = "name"
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    query    = %{"autoscaler" => name}
    endpoint = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_autoscaler zone, name, resource
  end

  test "update_autoscaler (with fields)" do 
    zone     = "zone"
    name     = "name"
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"autoscaler" => name, "fields" => fields}
    endpoint = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_autoscaler zone, name, resource, fields
  end  

  test "update_autoscaler (no name)" do 
    zone     = "zone"
    name     = ""
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_autoscaler zone, "", resource, fields
  end    

  test "update_autoscaler (no fields no name)" do 
    zone     = "zone"
    name     = ""
    resource = %{"field1" => "abc"}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    query    = %{}
    endpoint = @no_zone_ep <> "/zones/#{zone}/autoscalers"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_autoscaler zone, "", resource
  end      

  test "delete_autoscaler (no fields)" do 
    zone       = "zone"
    autoscaler = "autoscaler"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/autoscalers/#{autoscaler}"
    expected   = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_autoscaler zone, autoscaler
  end

  test "delete_autoscaler (with fields)" do 
    zone       = "zone"
    autoscaler = "autoscaler"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/autoscalers/#{autoscaler}"
    expected   = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_autoscaler zone, autoscaler, fields
  end  

  test "aggregated_list_of_autoscalers (no query)" do 
    headers  = []
    body     = ""
    endpoint = @no_zone_ep <> "/aggregated/autoscalers"
    expected = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_autoscalers
  end

  test "aggregated_list_of_autoscalers (with query)" do 
    headers  = []
    body     = ""
    query    = %{"field1" => "abc", "field2" => "def"}
    endpoint = @no_zone_ep <> "/aggregated/autoscalers"
    expected = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_autoscalers query
  end  

  #######################
  ### DiskTypes Tests ###
  #######################

  test "list_disk_types (no query)" do 
    zone       = "zone"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/diskTypes"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_disk_types zone
  end

  test "list_disk_types (with query)" do 
    zone       = "zone"
    headers    = []
    body       = ""
    query      = %{"field1" => "abc", "field2" => "def"}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/diskTypes"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_disk_types zone, query
  end  

  test "get_disk_type (no fields)" do 
    zone       = "zone"
    disk_type  = "disk_type"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/diskTypes/#{disk_type}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_disk_type zone, disk_type
  end  

  test "get_disk_type (with fields)" do 
    zone       = "zone"
    disk_type  = "disk_type"
    headers    = []
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/diskTypes/#{disk_type}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_disk_type zone, disk_type, fields
  end    

  test "aggregated_list_of_disk_types (no query)" do 
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/aggregated/diskTypes"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_disk_types
  end 

  test "aggregated_list_of_disk_types (with query)" do 
    headers    = []
    body       = ""
    query      = %{"field1" => 1, "field2" => 2}
    endpoint   = @no_zone_ep <> "/aggregated/diskTypes"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_disk_types query
  end   

  ###################
  ### Disks Tests ###
  ###################

  ###############
  ### Helpers ###
  ###############

  defp build_expected(verb, host, headers, body, query \\ "") do
    %{
      verb: verb, 
      endpoint: host, 
      headers: 
        headers ++         
        [
          {"x-goog-project-id", @project_id},
          {"Authorization", "Bearer Dummy Token"}
        ],
      body: body,
      query: query
    }
  end
end
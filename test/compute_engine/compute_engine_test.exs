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

  test "list_disks (no query)" do 
    zone       = "zone"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_disks zone
  end

  test "list_disks (with query)" do 
    zone       = "zone"
    headers    = []
    body       = ""
    query      = %{"a" => 1, "b" => 2}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_disks zone, query
  end  

  test "get_disk (no fields)" do 
    zone       = "zone"
    disk       = "disk"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks/#{disk}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_disk zone, disk
  end  

  test "get_disk (with fields)" do 
    zone       = "zone"
    disk       = "disk"
    headers    = []
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks/#{disk}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_disk zone, disk, fields
  end    

  test "insert_disk (no fields with image)" do 
    zone       = "zone"
    resource   = %{"name" => "name"}
    source_img = "source_image"
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    query      = %{"sourceImage" => source_img}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_disk zone, resource, source_img
  end    

  test "insert_disk (with fields with image)" do 
    zone       = "zone"
    resource   = %{"name" => "name"}
    source_img = "source_image"
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    body       = resource |> Poison.encode!
    query      = %{"sourceImage" => source_img, "fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_disk zone, resource, source_img, fields
  end      

  test "insert_disk (with fields no image)" do 
    zone       = "zone"
    resource   = %{"name" => "name"}
    source_img = ""
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    body       = resource |> Poison.encode!
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_disk zone, resource, source_img, fields
  end        

  test "insert_disk (no fields no image)" do 
    zone       = "zone"
    resource   = %{"name" => "name"}
    source_img = ""
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    query      = %{}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_disk zone, resource, source_img
  end   

  test "delete_disk (no fields)" do 
    zone       = "zone"
    disk       = "disk"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks/#{disk}"
    expected   = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_disk zone, disk
  end      

  test "delete_disk (with fields)" do 
    zone       = "zone"
    disk       = "disk"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks/#{disk}"
    expected   = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_disk zone, disk, fields
  end        

  test "resize_disk (no fields)" do 
    zone       = "zone"
    disk       = "disk"
    size       = 10
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"sizeGb" => size} |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks/#{disk}/resize"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.resize_disk zone, disk, size
  end        

  test "resize_disk (with fields)" do 
    zone       = "zone"
    disk       = "disk"
    size       = 10
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"sizeGb" => size} |> Poison.encode!
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks/#{disk}/resize"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.resize_disk zone, disk, size, fields
  end 

  test "aggregated_list_of_disks (no query)" do 
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/aggregated/disks"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_disks
  end 

  test "aggregated_list_of_disks (with query)" do 
    headers    = []
    body       = ""
    query      = %{"field1" => 1, "field2" => 2}
    endpoint   = @no_zone_ep <> "/aggregated/disks"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_disks query
  end  

  test "create_snapshot (no fields)" do 
    zone       = "zone"
    disk       = "disk"
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks/#{disk}/createSnapshot"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.create_snapshot zone, disk, resource
  end

  test "create_snapshot (with fields)" do 
    zone       = "zone"
    disk       = "disk"
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = resource |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/disks/#{disk}/createSnapshot"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.create_snapshot zone, disk, resource, fields
  end  

  #######################
  ### Firewalls Tests ###
  #######################

  test "list_firewalls (no query)" do 
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/global/firewalls"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_firewalls
  end

  test "list_firewalls (with query)" do 
    headers    = []
    body       = ""
    query      = %{"a" => 1, "b" => 2}
    endpoint   = @no_zone_ep <> "/global/firewalls"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_firewalls query
  end  

  test "get_firewall (no fields)" do 
    firewall   = "firewall"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/global/firewalls/#{firewall}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_firewall firewall
  end

  test "get_firewall (with fields)" do 
    firewall   = "firewall"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/global/firewalls/#{firewall}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_firewall firewall, fields
  end  

  test "insert_firewall (no fields)" do 
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    endpoint = @no_zone_ep <> "/global/firewalls"
    expected = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_firewall resource
  end

  test "insert_firewall (with fields)" do 
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = @no_zone_ep <> "/global/firewalls"
    expected = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_firewall resource, fields
  end  

  test "patch_firewall (no fields)" do 
    firewall = "firewall"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    endpoint = @no_zone_ep <> "/global/firewalls/#{firewall}"
    expected = build_expected(:patch, endpoint, headers, body)

    assert expected == API.patch_firewall firewall, resource
  end  

  test "patch_firewall (with fields)" do 
    firewall = "firewall"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = @no_zone_ep <> "/global/firewalls/#{firewall}"
    expected = build_expected(:patch, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.patch_firewall firewall, resource, fields
  end    

  test "update_firewall (no fields)" do 
    firewall = "firewall"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    endpoint = @no_zone_ep <> "/global/firewalls/#{firewall}"
    expected = build_expected(:put, endpoint, headers, body)

    assert expected == API.update_firewall firewall, resource
  end  

  test "update_firewall (with fields)" do 
    firewall = "firewall"
    resource = %{"abc" => 1, "def" => 2}
    headers  = [{"Content-Type", "application/json"}]
    body     = resource |> Poison.encode!
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = @no_zone_ep <> "/global/firewalls/#{firewall}"
    expected = build_expected(:put, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.update_firewall firewall, resource, fields
  end 

  test "delete_firewall (no fields)" do 
    firewall = "firewall"
    headers  = []
    body     = ""
    endpoint = @no_zone_ep <> "/global/firewalls/#{firewall}"
    expected = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_firewall firewall
  end    

  test "delete_firewall (with fields)" do 
    firewall = "firewall"
    headers  = []
    body     = ""
    fields   = "a,b,c"
    query    = %{"fields" => fields}
    endpoint = @no_zone_ep <> "/global/firewalls/#{firewall}"
    expected = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_firewall firewall, fields 
  end      

  ####################
  ### Images Tests ###
  ####################

  test "list_images (no query)" do 
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/global/images"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_images
  end

  test "list_images (with query)" do 
    headers    = []
    body       = ""
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = @no_zone_ep <> "/global/images"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_images query
  end

  test "get_image (no fields)" do 
    image      = "image"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/global/images/#{image}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_image image
  end  

  test "get_image (with fields)" do 
    image      = "image"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/global/images/#{image}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_image image
  end    

  test "insert_image_with_resource (no fields)" do 
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    endpoint   = @no_zone_ep <> "/global/images"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_image_with_resource resource
  end    

  test "insert_image_with_resource (with fields)" do 
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/global/images"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_image_with_resource resource, fields
  end      

  test "insert_image (no fields)" do 
    name       = "name"
    url        = "url"
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"name" => name, "rawDisk" => %{"source" => url}} |> Poison.encode!
    endpoint   = @no_zone_ep <> "/global/images"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_image name, url
  end    

  test "insert_image (with fields)" do 
    name       = "name"
    url        = "url"
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = %{"name" => name, "rawDisk" => %{"source" => url}} |> Poison.encode!
    endpoint   = @no_zone_ep <> "/global/images"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_image name, url, fields
  end      

  test "delete_image (no fields)" do 
    image      = "image"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/global/images/#{image}"
    expected   = build_expected(:delete, endpoint, headers, body)

    assert expected == API.delete_image image
  end   

  test "delete_image (with fields)" do 
    image      = "image"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/global/images/#{image}"
    expected   = build_expected(:delete, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.delete_image image, fields
  end     

  test "deprecate_image (no fields)" do 
    image      = "image"
    request    = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = request |> Poison.encode!
    endpoint   = @no_zone_ep <> "/global/images/#{image}/deprecate"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.deprecate_image image, request
  end   

  test "deprecate_image (with fields)" do 
    image      = "image"
    request    = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = request |> Poison.encode!
    fields     = "a,b,c"
    query      = %{"fields" => fields} 
    endpoint   = @no_zone_ep <> "/global/images/#{image}/deprecate"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.deprecate_image image, request, fields
  end     

  ############################
  ### InstanceGroups Tests ###
  ############################

  test "list_instance_groups (no query)" do 
    zone       = "zone"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.list_instance_groups zone
  end

  test "list_instance_groups (with query)" do 
    zone       = "zone"
    headers    = []
    body       = ""
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_instance_groups zone, query
  end

  test "list_instances_in_group (no query)" do 
    zone       = "zone"
    group      = "group"
    state      = "state"
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"instanceState" => state} |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}/listInstances"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.list_instances_in_group zone, group, state
  end

  test "list_instances_in_group (with) query)" do 
    zone       = "zone"
    group      = "group"
    state      = "state"
    headers    = [{"Content-Type", "application/json"}]
    body       = %{"instanceState" => state} |> Poison.encode!
    query      = %{"abc" => 1, "def" => 2}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}/listInstances"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.list_instances_in_group zone, group, state, query
  end

  test "get_instance_group (no fields)" do 
    zone       = "zone"
    group      = "group"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_instance_group zone, group
  end    

  test "get_instance_group (with fields)" do 
    zone       = "zone"
    group      = "group"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_instance_group zone, group, fields
  end      

  test "insert_instance_group (no fields)" do 
    zone       = "zone"
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.insert_instance_group zone, resource
  end   

  test "insert_instance_group (with fields)" do 
    zone       = "zone"
    resource   = %{"abc" => 1, "def" => 2}
    headers    = [{"Content-Type", "application/json"}]
    body       = resource |> Poison.encode!
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.insert_instance_group zone, resource, fields
  end  

  test "delete_instance_group (no fields)" do 
    zone       = "zone"
    group      = "group"
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.get_instance_group zone, group
  end   

  test "delete_instance_group (with fields)" do 
    zone       = "zone"
    group      = "group"
    headers    = []
    body       = ""
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}"
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.get_instance_group zone, group, fields
  end     

  test "aggregated_list_of_instance_groups (no query)" do 
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/aggregated/instanceGroups"
    expected   = build_expected(:get, endpoint, headers, body)

    assert expected == API.aggregated_list_of_instance_groups
  end 

  test "aggregated_list_of_instance_groups (with query)" do 
    headers    = []
    body       = ""
    endpoint   = @no_zone_ep <> "/aggregated/instanceGroups"
    query      = %{"abc" => 1, "def" => 2}
    expected   = build_expected(:get, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.aggregated_list_of_instance_groups query
  end 

  test "add_instances_to_group (no fields)" do 
    zone       = "zone"
    group      = "group"
    instances  = ["a", "b", "c"]
    headers    = [{"Content-Type", "application/json"}]
    body       = %{
      "instances" => [
        %{"instance" => "a"},
        %{"instance" => "b"},
        %{"instance" => "c"}
      ]
    } |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}/addInstances"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.add_instances_to_group zone, group, instances
  end   

  test "add_instances_to_group (with fields)" do 
    zone       = "zone"
    group      = "group"
    instances  = ["a", "b", "c"]
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = %{
      "instances" => [
        %{"instance" => "a"},
        %{"instance" => "b"},
        %{"instance" => "c"}
      ]
    } |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}/addInstances"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.add_instances_to_group zone, group, instances, fields
  end     

  test "remove_instances_from_group (no fields)" do 
    zone       = "zone"
    group      = "group"
    instances  = ["a", "b", "c"]
    headers    = [{"Content-Type", "application/json"}]
    body       = %{
      "instances" => [
        %{"instance" => "a"},
        %{"instance" => "b"},
        %{"instance" => "c"}
      ]
    } |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}/removeInstances"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.remove_instances_from_group zone, group, instances
  end     

  test "remove_instances_from_group (with fields)" do 
    zone       = "zone"
    group      = "group"
    instances  = ["a", "b", "c"]
    headers    = [{"Content-Type", "application/json"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    body       = %{
      "instances" => [
        %{"instance" => "a"},
        %{"instance" => "b"},
        %{"instance" => "c"}
      ]
    } |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}/removeInstances"
    expected   = build_expected(:post, endpoint, headers, body, query |> URI.encode_query)

    assert expected == API.remove_instances_from_group zone, group, instances, fields
  end     

  test "set_named_ports_for_group (no fields)" do 
    zone       = "zone"
    group      = "group"
    fp         = "fingerprint"
    ports      = [{"a", "1"}, {"b", "2"}, {"c", "3"}]
    headers    = [{"Content-Type", "application/json"}]
    body       = %{
      "namedPorts" => [
        %{"name" => "a", "port" => "1"},
        %{"name" => "b", "port" => "2"},
        %{"name" => "c", "port" => "3"}
      ],
      "fingerprint" => fp
    } |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}/setNamedPorts"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.set_named_ports_for_group zone, group, ports, fp
  end   

  test "set_named_ports_for_group (with fields)" do 
    zone       = "zone"
    group      = "group"
    fp         = "fingerprint"
    ports      = [{"a", "1"}, {"b", "2"}, {"c", "3"}]
    fields     = "a,b,c"
    query      = %{"fields" => fields}
    headers    = [{"Content-Type", "application/json"}]
    body       = %{
      "namedPorts" => [
        %{"name" => "a", "port" => "1"},
        %{"name" => "b", "port" => "2"},
        %{"name" => "c", "port" => "3"}
      ],
      "fingerprint" => fp
    } |> Poison.encode!
    endpoint   = @no_zone_ep <> "/zones/#{zone}/instanceGroups/#{group}/setNamedPorts"
    expected   = build_expected(:post, endpoint, headers, body)

    assert expected == API.set_named_ports_for_group zone, group, ports, fp
  end     

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
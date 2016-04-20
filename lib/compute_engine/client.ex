defmodule GCloudex.ComputeEngine.Client do
  alias GCloudex.ComputeEngine.Request, as: Request
  alias HTTPoison.HTTPResponse

  @moduledoc """
  Wrapper for Google Compute Engine API.
  """

  @resource_disks ["autoDelete", "boot", "deviceName", "index", 
                   "initializeParams", "interface", "kind", "licenses", "mode",
                   "source", "type"]

  @resource_init_params ["diskName", "diskSizeGb", "diskType", "sourceImage"]
  @resource_metadata ["fingerprint"]

  @project_id   GCloudex.get_project_id
  @instance_ep "https://www.googleapis.com/compute/v1/projects/#{@project_id}/zones"
  @no_zone_ep  "https://www.googleapis.com/compute/v1/projects/#{@project_id}"

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
    query = query_params |> URI.encode_query

    Request.request_query :get, @instance_ep <> "/#{zone}/instances", 
      [], "", "?" <> query
  end

  @doc """
  Returns the data about the 'instance' in the given 'zone' if it exists.
  """
  @spec get_instance(binary, binary) :: HTTPResponse.t
  def get_instance(zone, instance) do
    Request.request :get, @instance_ep <> "/#{zone}/instances/#{instance}", [], ""
  end

  @doc """
  Creates a new Virtual Machine instance on Google Compute Engine in the given
  'zone' and with properties defined in 'instance_resource'. Example of the 
  minimal Instance Resource the API will accept:

    %{
      "disks" => 
      [
        %{
          "autoDelete" => true, "boot" => true,
          "initializeParams" => 
          %{
            "sourceImage" => 
              "projects/debian-cloud/global/images/debian-8-jessie-v20160119"
            },
          "type" => "PERSISTENT"
        }
      ],
      "machineType" => "zones/europe-west1-d/machineTypes/f1-micro",
      "name" => "example-instance",
      "networkInterfaces" => 
      [
        %{
          "accessConfigs" => 
          [
            %{
             "name" => "External NAT",
             "type" => "ONE_TO_ONE_NAT"
            }
         ], 
         "network" => "global/networks/default"
        }
      ]
    }

  For the 'instance_resource' check the documentation at:

    https://cloud.google.com/compute/docs/reference/latest/instances#resource
  """
  @spec insert_instance(binary, map) :: HTTPResponse.t
  def insert_instance(zone, instance_resource) do
    body = instance_resource |> Poison.encode!

    Request.request :post, @instance_ep <> "/#{zone}/instances", 
      [{"Content-Type", "application/json"}], body
  end

  @doc """
  Deletes the given 'instance' if it exists in the given 'zone'.
  """
  @spec delete_instance(binary, binary) :: HTTPResponse.t
  def delete_instance(zone, instance) do 
    Request.request :delete, @instance_ep <> "/#{zone}/instances/#{instance}", [], ""
  end

  @doc """
  Starts a stopped 'instance' if it exists in the given 'zone'.
  """
  @spec start_instance(binary, binary) :: HTTPResponse.t
  def start_instance(zone, instance) do 
    Request.request( 
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/start", 
      [{"Content-Type", "application/json"}], 
      "")
  end

  @doc """
  Stops a running 'instance' if it exists in the given 'zone'.
  """
  @spec stop_instance(binary, binary) :: HTTPResponse.t
  def stop_instance(zone, instance) do 
    Request.request(
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/stop", 
      [{"Content-Type", "application/json"}], 
      "")
  end

  @doc """
  Performs a hard reset on the 'instance' if it exists in the given 'zone'.
  """
  @spec reset_instance(binary, binary) :: HTTPResponse.t
  def reset_instance(zone, instance) do 
    Request.request(
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/reset",
      [{"Content-Type", "application/json"}], 
      "")      
  end

  @doc """
  Adds an access config to the 'instance' if it exists in the given 'zone'. The
  kind and type will automatically be added with the default (and only possible)
  values.
  """
  @spec add_access_config(binary, binary, binary, binary, binary) :: HTTPResponse.t
  def add_access_config(zone, instance, network_interface, name, nat_ip \\ :empty) do 
    body = 
      %{
        "kind"  => "compute#accessConfig",
        "type"  => "ONE_TO_ONE_NAT",
        "name"  => name
      }    

    body = 
      if nat_ip != :empty do 
        body |> Map.put_new("natIP", nat_ip)
      else
        body
      end

    query = %{"networkInterface" => network_interface} |> URI.encode_query

    Request.request_query(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/addAccessConfig",
      [{"Content-Type", "application/json"}],
      body |> Poison.encode!,
      "?" <> query)
  end

  @doc """
  Deletes te 'access_config' from the 'instance' 'network_interface' if the
  'instance' exists in the given 'zone'.
  """
  @spec delete_access_config(binary, binary, binary, binary) :: HTTPResponse.t
  def delete_access_config(zone, instance, access_config, network_interface) do 
    query = 
      %{"accessConfig" => access_config, "networkInterface" => network_interface}
      |> URI.encode_query

    Request.request_query(
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/deleteAccessConfig",
      [{"Content-Type", "application/json"}],
      "",
      "?" <> query)
  end

  @doc """
  Retrieves aggregated list of instances.
  """
  @spec get_aggregated_list_of_instances() :: HTTPResponse.t
  def get_aggregated_list_of_instances do 
    Request.request(
      :get, 
      @no_zone_ep <> "/aggregated/instances",
      [],
      "")
  end

  @doc """
  Retrieves aggregated list of instances according to the specified 
  'query_params'.
  """
  @spec get_aggregated_list_of_instances(map) :: HTTPResponse.t
  def get_aggregated_list_of_instances(query_params) do
    query = query_params |> URI.encode_query

    Request.request_query(
      :get, 
      @no_zone_ep <> "/aggregated/instances",
      [],
      "",
      "?" <> query)
  end

  @doc """
  Attaches the 'disk_resource' to the 'instance' if it exists in the given
  'zone'.

  Disk Resource structure:

    {
      "kind": "compute#attachedDisk",
      "index": integer,
      "type": string,
      "mode": string,
      "source": string,
      "deviceName": string,
      "boot": boolean,
      "initializeParams": {
        "diskName": string,
        "sourceImage": string,
        "diskSizeGb": long,
        "diskType": string
      },
      "autoDelete": boolean,
      "licenses": [
        string
      ],
      "interface": string
    }
  """
  @spec attach_disk(binary, binary, map) :: HTTPResponse.t
  def attach_disk(zone, instance, disk_resource) do 
    Request.request(
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/attachDisk",
      [{"Content-Type", "application/json"}],
      disk_resource |> Poison.encode!
      )
  end

  @doc """
  Detaches the disk with 'device_name' from the 'instance' if it exists in the
  given 'zone'.
  """
  @spec detach_disk(binary, binary, binary) :: HTTPResponse.t
  def detach_disk(zone, instance, device_name) do
    query = %{"deviceName" => device_name} |> URI.encode_query 

    Request.request(
      :get, 
      @instance_ep <> "/#{zone}/instances/#{instance}/detachDisk"
        <> "?#{query}",
      [{"Content-Type", "application/json"}],
      "")
  end

  @doc """
  Sets the 'auto_delete' flag for the disk with 'device_name' attached to 
  'instance' if it exists in the given 'zone'.
  """
  @spec set_disk_auto_delete(binary, binary, boolean, binary) :: HTTPResponse.t
  def set_disk_auto_delete(zone, instance, auto_delete, device_name) do 
    query = %{"deviceName" => device_name, "autoDelete" => auto_delete}
    |> URI.encode_query

    Request.request_query(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setDiskAutoDelete",
      [{"Content-Type", "application/json"}],
      "",
      "?" <> query)
  end

  @doc """
  Returns the specified 'instance' serial 'port' output if the 'instance'
  exists in the given 'zone'. The 'port' accepted values are from 1 to 4, 
  inclusive.
  """
  @spec get_serial_port_output(binary, binary, pos_integer) :: HTTPResponse.t
  def get_serial_port_output(zone, instance, port \\ :empty) do 
    port = 
      if port == :empty do 
        1
      else
        port
      end

    query = %{"port" => port} |> URI.encode_query
    
    Request.request(
      :get, 
      @instance_ep <> "/#{zone}/instances/#{instance}/serialPort?#{query}"
      )
  end

  @doc """
  Changes the Machine Type for a stopped 'instance' to the specified 
  'machine_type' if the 'instance' exists in the given 'zone'.
  """
  def set_machine_type(zone, instance, machine_type) do 
    body = %{"machineType" => machine_type} |> Poison.encode!

    Request.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setMachineType",
      [{"Content-Type", "application/json"}],
      body
      )
  end

  @doc """
  Sets metadata for the specified 'instance' to the data specified in 
  'fingerprint' and 'items'. The 'instance' must exist in the given 'zone'.

  The 'items' should be passed as a list of maps:
    [
      %{
        "key"   => "some key value",
        "value" => "some value"
      },
      %{
        "key"   => "some other key value",
        "value" => "some other value"
      }
    ]
  """
  @spec set_metadata(binary, binary, binary, list(map)) :: HTTPResponse.t
  def set_metadata(zone, instance, fingerprint, items) do 
    body = %{"kind" => "compute#metadata"}
    |> Map.put_new("fingerprint", fingerprint)
    |> Map.put_new("items", items)
    |> Poison.encode!

    Request.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setMetadata",
      [{"Content-Type", "application/json"}],
      body)
  end

  @doc """
  Sets an 'instance' scheduling options if it exists in the given 'zone'. The
  'preemptible' option cannot be changed after instance creation.
  """
  @spec set_scheduling(binary, binary, binary, boolean, boolean) :: HTTPResponse.t
  def set_scheduling(zone, instance, on_host_maintenance, automatic_restart, preemptible) do 
    body = %{
              "onHostMaintenance" => on_host_maintenance, 
              "automaticRestart"  => automatic_restart,
              "preemptible"       => preemptible
            }
    |> Poison.encode!

    Request.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setScheduling",
      [{"Content-Type", "application/json"}],
      body
      )
  end

  @doc """
  Sets tags for the specified 'instance' to the given 'fingerprint' and 'items'.
  The 'instance' must exist in the given 'zone'.
  """
  @spec set_tags(binary, binary, binary, list(binary)) :: HTTPResponse.t
  def set_tags(zone, instance, fingerprint, items) do 
    body = %{"fingerprint" => fingerprint, "items" => items} |> Poison.encode!

    Request.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setTags",
      [{"Content-Type", "application/json"}],
      body
      )
  end

  #####################
  ### MACHINE TYPES ###
  #####################

  @doc """
  Retrieves a list of machine types available in the specified 'zone'.
  """
  @spec list_machine_types(binary) :: HTTPResponse.t
  def list_machine_types(zone) do 
    Request.request(:get, @instance_ep <> "/#{zone}/machineTypes", [], "")
  end

  @doc """
  Retrieves a list of machine types available in the specified 'zone' and 
  that fit in the given 'query_params'.
  """
  @spec list_machine_types(binary, map) :: HTTPResponse.t
  def list_machine_types(zone, query_params) do 
    query = query_params |> URI.encode_query
    Request.request_query(:get, @instance_ep <> "/#{zone}/machineTypes", [], "", "?" <> query)
  end

  @doc """
  Returns the specified 'machine_type' in the given 'zone'.
  """
  @spec get_machine_type(binary, binary) :: HTTPResponse.t
  def get_machine_type(zone, machine_type) do 
    Request.request :get, @instance_ep <> "/#{zone}/machineTypes/#{machine_type}", [], ""
  end

  @doc """
  Returns an aggregated list of machine types.
  """
  @spec get_aggregated_list_of_machine_types() :: HTTPResponse.t
  def get_aggregated_list_of_machine_types do 
    Request.request :get, @no_zone_ep <> "/aggregated/machineTypes", [], ""
  end

  @doc """
  Returns an aggragated list of machine types following the specified 
  'query_params'.
  """
  @spec get_aggregated_list_of_machine_types(map) :: HTTPResponse.t
  def get_aggregated_list_of_machine_types(query_params) do 
    query = query_params |> URI.encode_query

    Request.request_query :get, @no_zone_ep <> "/aggregated/machineTypes", [], "", "?" <> query
  end

  ###############
  ### REGIONS ###
  ###############

  @doc """
  Retrieves a list of region resources.
  """
  @spec list_regions() :: HTTPResponse.t
  def list_regions do
    Request.request :get, @no_zone_ep <> "/regions", [], ""
  end

  @doc """
  Retrieves a list of region resources according to the given 'query_params'.
  """
  @spec list_regions(map) :: HTTPResponse.t
  def list_regions(query_params) do
    query = query_params |> URI.encode_query
    Request.request_query :get, @no_zone_ep <> "/regions", [], "", "?" <> query
  end    

  @doc """
  Returns the specified 'region' resource.
  """
  @spec get_region(binary) :: HTTPResponse.t
  def get_region(region) do 
    Request.request :get, @no_zone_ep <> "/regions/#{region}", [], ""
  end
end
defmodule GCloudex.ComputeEngine.Instances do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Instances endpoint.
  """

  @doc """
  Lists all instances in the given 'zone' obeying the given 'query_params' if
  present.
  """
  @spec list_instances(binary, map) :: HTTPResponse.t
  def list_instances(zone, query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request :get, @instance_ep <> "/#{zone}/instances", [], "", query
  end

  @doc """
  Returns the data about the 'instance' in the given 'zone' if it exists.
  """
  @spec get_instance(binary, binary, binary) :: HTTPResponse.t
  def get_instance(zone, instance, fields \\ "") do
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end

    HTTP.request(
      :get, 
      @instance_ep <> "/#{zone}/instances/#{instance}", 
      [], 
      "",
      query)
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
  @spec insert_instance(binary, map, binary) :: HTTPResponse.t
  def insert_instance(zone, instance_resource, fields \\ "") do
    body  = instance_resource |> Poison.encode!
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end

    HTTP.request(
      :post, 
      @instance_ep <> "/#{zone}/instances", 
      [{"Content-Type", "application/json"}], 
      body,
      query)
  end

  @doc """
  Deletes the given 'instance' if it exists in the given 'zone'.
  """
  @spec delete_instance(binary, binary, binary) :: HTTPResponse.t
  def delete_instance(zone, instance, fields \\ "") do 
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end

    HTTP.request(
      :delete, 
      @instance_ep <> "/#{zone}/instances/#{instance}", 
      [], 
      "",
      query)
  end

  @doc """
  Starts a stopped 'instance' if it exists in the given 'zone'.
  """
  @spec start_instance(binary, binary, binary) :: HTTPResponse.t
  def start_instance(zone, instance, fields \\ "") do 
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end    

    HTTP.request( 
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/start", 
      [{"Content-Type", "application/json"}], 
      "",
      query)
  end

  @doc """
  Stops a running 'instance' if it exists in the given 'zone'.
  """
  @spec stop_instance(binary, binary, binary) :: HTTPResponse.t
  def stop_instance(zone, instance, fields \\ "") do 
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end

    HTTP.request(
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/stop", 
      [{"Content-Type", "application/json"}], 
      "",
      query)
  end

  @doc """
  Performs a hard reset on the 'instance' if it exists in the given 'zone'.
  """
  @spec reset_instance(binary, binary, binary) :: HTTPResponse.t
  def reset_instance(zone, instance, fields \\ "") do 
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end

    HTTP.request(
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/reset",
      [{"Content-Type", "application/json"}], 
      "",
      query)      
  end

  @doc """
  Adds an access config to the 'instance' if it exists in the given 'zone'. The
  kind and type will automatically be added with the default (and only possible)
  values.
  """
  @spec add_access_config(binary, binary, binary, binary, binary, binary) :: HTTPResponse.t
  def add_access_config(zone, instance, network_interface, name, nat_ip \\ "", fields \\ "") do 
    body = 
      %{
        "kind"  => "compute#accessConfig",
        "type"  => "ONE_TO_ONE_NAT",
        "name"  => name
      }    

    body = 
      if nat_ip != "" do 
        body |> Map.put_new("natIP", nat_ip)
      else
        body
      end

    query = 
      if fields == "" do 
        %{"networkInterface" => network_interface} |> URI.encode_query
      else
        %{"networkInterface" => network_interface, "fields" => fields} 
        |> URI.encode_query
      end


    HTTP.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/addAccessConfig",
      [{"Content-Type", "application/json"}],
      body |> Poison.encode!,
      query)
  end

  @doc """
  Deletes te 'access_config' from the 'instance' 'network_interface' if the
  'instance' exists in the given 'zone'.
  """
  @spec delete_access_config(binary, binary, binary, binary, binary) :: HTTPResponse.t
  def delete_access_config(zone, instance, access_config, network_interface, fields \\ "") do 
    query = 
      if fields == "" do 
        %{"accessConfig" => access_config, "networkInterface" => network_interface}
        |> URI.encode_query
      else
        %{
          "accessConfig"     => access_config, 
          "networkInterface" => network_interface,
          "fields"           => fields
        }
      |> URI.encode_query
      end    

    HTTP.request(
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/deleteAccessConfig",
      [{"Content-Type", "application/json"}],
      "",
      query)
  end

  @doc """
  Retrieves aggregated list of instances according to the specified 
  'query_params' if present.
  """
  @spec get_aggregated_list_of_instances(map) :: HTTPResponse.t
  def get_aggregated_list_of_instances(query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request(
      :get, 
      @no_zone_ep <> "/aggregated/instances",
      [],
      "",
      query)
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
  @spec attach_disk(binary, binary, map, binary) :: HTTPResponse.t
  def attach_disk(zone, instance, disk_resource, fields \\ "") do
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end

    HTTP.request(
      :post, 
      @instance_ep <> "/#{zone}/instances/#{instance}/attachDisk",
      [{"Content-Type", "application/json"}],
      disk_resource |> Poison.encode!,
      query)
  end

  @doc """
  Detaches the disk with 'device_name' from the 'instance' if it exists in the
  given 'zone'.
  """
  @spec detach_disk(binary, binary, binary, binary) :: HTTPResponse.t
  def detach_disk(zone, instance, device_name, fields \\ "") do
    query = 
      if fields == "" do 
        %{"deviceName" => device_name} |> URI.encode_query 
      else
        %{"deviceName" => device_name, "fields" => fields} |> URI.encode_query
      end    

    HTTP.request(
      :get, 
      @instance_ep <> "/#{zone}/instances/#{instance}/detachDisk",
      [{"Content-Type", "application/json"}],
      "",
      query)
  end

  @doc """
  Sets the 'auto_delete' flag for the disk with 'device_name' attached to 
  'instance' if it exists in the given 'zone'.
  """
  @spec set_disk_auto_delete(binary, binary, boolean, binary, binary) :: HTTPResponse.t
  def set_disk_auto_delete(zone, instance, auto_delete, device_name, fields \\ "") do 
    query = 
      if fields == "" do 
        %{"deviceName" => device_name, "autoDelete" => auto_delete}
        |> URI.encode_query
      else
        %{
          "deviceName" => device_name, 
          "autoDelete" => auto_delete,
          "fields"     => fields
        }
        |> URI.encode_query
      end

    HTTP.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setDiskAutoDelete",
      [{"Content-Type", "application/json"}],
      "",
      query)
  end

  @doc """
  Returns the specified 'instance' serial 'port' output if the 'instance'
  exists in the given 'zone'. The 'port' accepted values are from 1 to 4, 
  inclusive.
  """
  @spec get_serial_port_output(binary, binary, pos_integer, binary) :: HTTPResponse.t
  def get_serial_port_output(zone, instance, port \\ 1, fields \\ "") do 
    port = 
      if port == 1 do 
        port
      else
        port
      end

    query = 
      if fields == "" do         
        %{"port" => port} |> URI.encode_query
      else
        %{"port" => port, "fields" => fields} |> URI.encode_query
      end
    
    HTTP.request(
      :get, 
      @instance_ep <> "/#{zone}/instances/#{instance}/serialPort",
      [],
      "",
      query)
  end

  @doc """
  Changes the Machine Type for a stopped 'instance' to the specified 
  'machine_type' if the 'instance' exists in the given 'zone'.
  """
  @spec set_machine_type(binary, binary, binary, binary) :: HTTPResponse.t
  def set_machine_type(zone, instance, machine_type, fields \\ "") do 
    body = %{"machineType" => machine_type} |> Poison.encode!
    query = 
      if fields == "" do
        fields
      else
        %{"fields" => fields}
      end

    HTTP.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setMachineType",
      [{"Content-Type", "application/json"}],
      body,
      query)
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
  @spec set_metadata(binary, binary, binary, list(map), binary) :: HTTPResponse.t
  def set_metadata(zone, instance, fingerprint, items, fields \\ "") do 
    body = %{"kind" => "compute#metadata"}
    |> Map.put_new("fingerprint", fingerprint)
    |> Map.put_new("items", items)
    |> Poison.encode!

    query = 
      if fields == "" do
        fields
      else
        %{"fields" => fields}
      end    

    HTTP.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setMetadata",
      [{"Content-Type", "application/json"}],
      body,
      query)
  end

  @doc """
  Sets an 'instance' scheduling options if it exists in the given 'zone'. The
  'preemptible' option cannot be changed after instance creation.
  """
  @spec set_scheduling(binary, binary, {binary, boolean, boolean}, binary) :: HTTPResponse.t
  def set_scheduling(zone, instance, {on_host_maintenance, automatic_restart, preemptible}, fields \\ "") do 
    body = %{
              "onHostMaintenance" => on_host_maintenance, 
              "automaticRestart"  => automatic_restart,
              "preemptible"       => preemptible
            }
    |> Poison.encode!

    query = 
      if fields == "" do
        fields
      else
        %{"fields" => fields}
      end

    HTTP.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setScheduling",
      [{"Content-Type", "application/json"}],
      body,
      query)
  end

  @doc """
  Sets tags for the specified 'instance' to the given 'fingerprint' and 'items'.
  The 'instance' must exist in the given 'zone'.
  """
  @spec set_tags(binary, binary, binary, list(binary), binary) :: HTTPResponse.t
  def set_tags(zone, instance, fingerprint, items, fields \\ "") do 
    body = %{"fingerprint" => fingerprint, "items" => items} |> Poison.encode!
    query = 
      if fields == "" do
        fields
      else
        %{"fields" => fields}
      end    

    HTTP.request(
      :post,
      @instance_ep <> "/#{zone}/instances/#{instance}/setTags",
      [{"Content-Type", "application/json"}],
      body,
      query)
  end  
end
defmodule GCloudex.CloudSQL.Client do
  alias GCloudex.CloudSQL.Request, as: Request
  alias HTTPoison.HTTPResponse

  @moduledoc """
  Wrapper for the Google Cloud SQL API.
  """

  @project_id   GCloudex.get_project_id
  @instance_ep  "https://www.googleapis.com/sql/v1beta4/projects/#{@project_id}/instances"
  @flag_ep      "https://www.googleapis.com/sql/v1beta4/flags"
  @operation_ep "https://www.googleapis.com/sql/v1beta4/projects/#{@project_id}/operations"
  @tiers_ep     "https://www.googleapis.com/sql/v1beta4/projects/#{@project_id}/tiers"

  #################
  ### Instances ###
  #################

  @doc """
  List instances from the project.
  """
  @spec list_instances() :: HTTPResponse.t
  def list_instances do
    Request.request :get, @instance_ep, [], ""
  end

  @doc """
  Retrieves a resource containing information about the given 
  Cloud SQL 'instance'.
  """
  @spec get_instance(binary) :: HTTPResponse.t
  def get_instance(instance) do
    Request.request_query :get, @instance_ep, [], "", instance
  end
  
  @doc """
  Creates a new Cloud SQL instance with the specified 'name', 'settings',
  'optional_properties' and with the given 'tier' unless already passed through
  'settings'.

  The 'settings' parameter is meant to have the settings JSON nested object
  while 'optional_properties' is meant to have other non-required request
  fields like the 'replicaConfiguration' JSON nested object field. The 
  'settings' map will be nested into 'optional_properties' to match the 
  API's request structure like in the following example:

    optional_properties = 
    %{
      name: 'name',
      region: someRegion,
      settings: %{
        tier: 'tier',
        other_key_1: someValue,
        other_key_2: someValue
      },
      optional_prop_1: someValue,
      optional_prop_2: someValue
    }

  TODO: Re-evaluate how the optional fields should be passed.
  """
  @spec insert_instance(binary, map, map, binary) :: HTTPResponse.t
  def insert_instance(name, optional_properties, settings, tier) do
    settings = settings
               |> Map.put_new(:tier, tier)

    body     = Map.new
               |> Map.put_new(:name, name)
               |> Map.merge(optional_properties)
               |> Map.put_new(:settings, settings)
               |> Poison.encode!

    Request.request :post, @instance_ep, [{"Content-Type", "application/json"}], body
  end

  @doc """
  Deletes the given 'instance' from the project.
  """
  @spec delete_instance(binary) :: HTTPResponse.t
  def delete_instance(instance) do 
    Request.request_query :delete, @instance_ep, [], "", instance
  end

  @doc """
  Clones the given 'instance' and gives the new instance the chosen 'dest_name'
  and the given 'bin_log_file' and 'bin_log_pos'.
  """
  @spec clone_instance(binary, binary, binary, binary) :: HTTPResponse.t
  def clone_instance(instance, dest_name, bin_log_file, bin_log_pos) do 

    bin_log_coords = Map.new
                     |> Map.put_new("kind", "sql#binLogCoordinates")
                     |> Map.put_new("binLogFileName", bin_log_file)
                     |> Map.put_new("binLogPosition", bin_log_pos)

    clone_context  = Map.new
                     |> Map.put_new("kind", "sql#cloneContext")
                     |> Map.put_new("destinationInstanceName", dest_name)
                     |> Map.put_new("binLogCoordinates", bin_log_coords)

    body = Map.new
           |> Map.put_new("cloneContext", clone_context)
           |> Poison.encode!

    Request.request_query :post,
                          @instance_ep, 
                          [{"Content-Type", "application/json"}], 
                          body, 
                          instance <> "/clone"
  end

  @doc """
  Restarts the given 'instance'.
  """
  @spec restart_instance(binary) :: HTTPResponse.t
  def restart_instance(instance) do 
    Request.request_query :post, 
                          @instance_ep, 
                          [{"Content-Type", "application/json"}], 
                          "", 
                          instance <> "/" <> "restart"
  end

  @doc """
  Starts the replication in the read replica 'instance'.
  """
  @spec start_replica(binary) :: HTTPResponse.t
  def start_replica(instance) do 
    Request.request_query :post,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          "",
                          instance <> "/" <> "startReplica"
  end

  @doc """
  Stops the replication in the read replica 'instance'.
  """
  @spec stop_replica(binary) :: HTTPResponse.t  
  def stop_replica(instance) do 
    Request.request_query :post,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          "",
                          instance <> "/" <> "stopReplica"
  end

  @doc """
  Promotes the read replica 'instance' to be a stand-alone Cloud SQL instance.
  """
  @spec promote_replica(binary) :: HTTPResponse.t
  def promote_replica(instance) do 
    Request.request_query :post,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          "",
                          instance <> "/" <> "promoteReplica"
  end

  @doc """
  Failover the 'instance' to its failover replica instance with the 
  specified 'settings_version'.
  """
  @spec failover_instance(binary, number) :: HTTPResponse.t
  def failover_instance(instance, settings_version) do 
    failover = Map.new
              |> Map.put_new("kind", "sql#failoverContext")
              |> Map.put_new("settingsVersion", settings_version)

    body     = Map.new
               |> Map.put_new("failoverContext", failover)
               |> Poison.encode!

    Request.request_query :post,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          body,
                          instance <> "/" <> "failover"
  end

  @doc """
  Deletes all client certificates and generates a new server SSL certificate
  for the 'instance'.

  For First Generation instances, the changes do not take effect until the
  instance is restarted. For Second Generation instances, the changes are
  immediate; all existing connections to the instance are broken.
  """
  @spec reset_ssl_config(binary) :: HTTPResponse.t
  def reset_ssl_config(instance) do 
    Request.request_query :post,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          "",
                          instance <> "/" <> "resetSslConfig"
  end

  #################
  ### Databases ###
  #################

  @doc """
  Lists databases in the specified Cloud SQL 'instance'.
  """
  @spec list_databases(binary) :: HTTPResponse.t
  def list_databases(instance) do 
    Request.request_query :get, @instance_ep, [], "", instance <> "/databases"
  end

  @doc """
  Creates a new database inside the specified Cloud SQL 'instance' with the 
  given 'name'.
  """
  @spec insert_database(binary, binary) :: HTTPResponse.t
  def insert_database(instance, name) do

    body = Map.new
           |> Map.put_new("instance", instance)
           |> Map.put_new("name", name)
           |> Map.put_new("project", @project_id)
           |> Poison.encode!

    Request.request_query :post,
                          @instance_ep, 
                          [{"Content-Type", "application/json"}],
                          body,
                          instance <> "/databases"

  end

  @doc """
  Retrieves a resource containing information about the 'database' inside a
  Cloud SQL 'instance'.
  """
  @spec get_database(binary, binary) :: HTTPResponse.t
  def get_database(instance, database) do 
    Request.request_query :get, @instance_ep, [], "", 
                          instance <> "/databases" <> "/" <> database
  end

  @doc """
  Deletes the 'database' from the Cloud SQL 'instance'.
  """
  @spec delete_database(binary, binary) :: HTTPResponse.t
  def delete_database(instance, database) do 
    Request.request_query :delete, @instance_ep, [], "", 
                          instance <> "/databases" <> "/" <> database
  end

  @doc """
  Updates a resource containing information about a 'database' inside a 
  Cloud SQL 'instance' using patch semantics. The 'patch_map' must be a Map.
  """
  @spec patch_database(binary, binary, map) :: HTTPResponse.t
  def patch_database(instance, database, patch_map) do
    {:ok, res}  = get_database instance, database
    db_resource = res.body
                  |> Poison.decode!
                  |> Map.merge(patch_map) 
                  |> Poison.encode!

    Request.request_query :patch,
                          @instance_ep, 
                          [{"Content-Type", "application/json"}], 
                          db_resource,
                          instance <> "/databases" <> "/" <> database
  end

  @doc """
  Updates a resource containing information about a 'database' inside a 
  Cloud SQL 'instance'. The 'update_map' must be a Map.
  """
  @spec update_database(binary, binary, map) :: HTTPResponse.t
  def update_database(instance, database, update_map) do 
    {:ok, res}  = get_database instance, database
    db_resource = res.body 
                  |> Poison.decode! 
                  |> Map.merge(update_map)
                  |> Poison.encode!

    Request.request_query :put,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          db_resource,
                          instance <> "/databases" <> "/" <> database
  end

  #############
  ### Flags ###
  #############

  @doc """
  List all available database flags for Google the Cloud SQL 'instance'.
  """
  @spec list_flags :: HTTPResponse.t
  def list_flags do 
    Request.request :get, @flag_ep, [], "" 
  end

  ##################
  ### Operations ###
  ##################

  @doc """
  Lists all instance operations that have been performed on the given 
  Cloud SQL 'instance' in the reverse chronological order of the start time.
  """
  @spec list_operations(binary) :: HTTPResponse.t
  def list_operations(instance) do 
    Request.request :get,
                    @operation_ep <> "?" <> "instance=#{instance}",
                    [],
                    ""
  end

  @doc """
  Retrieves the instance operation with 'operation_id' that has been 
  performed on an instance.
  """
  @spec get_operation(binary) :: HTTPResponse.t
  def get_operation(operation_id) do 
    Request.request_query :get,
                          @operation_ep, 
                          [],
                          "",
                          "/" <> operation_id

  end

  #############
  ### Tiers ###
  #############

  @doc """
  Lists all available service tiers for Google Cloud SQL, for example D1, D2. 
  """
  @spec list_tiers :: HTTPResponse.t
  def list_tiers do 
    Request.request :get, @tiers_ep, [], ""
  end 

  #############
  ### Users ###
  #############  

  @doc """
  Lists users in the specified Cloud SQL 'instance'.
  """
  @spec list_users(binary) :: HTTPResponse.t
  def list_users(instance) do 
    Request.request_query :get, 
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "users"
  end

  @doc """
  Creates a new user in a Cloud SQL 'instance' with the given 'name and
  'password'. The authorized host to connect can be set through 'host'
  (defaults to '% (any host)').
  """
  @spec insert_user(binary, binary, binary, binary) :: HTTPResponse.t
  def insert_user(instance, name, password, host \\ "%") do 

    body = Map.new
           |> Map.put_new(:name, name)
           |> Map.put_new(:password, password)
           |> Map.put_new(:host, host)
           |> Poison.encode!

    Request.request_query :post,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          body,
                          instance <> "/" <> "users"
  end

  @doc """
  Updates an existing user in a Cloud SQL 'instance' with the given 'host',
  'name' and 'password'.
  """
  @spec update_user(binary, binary, binary, binary) :: HTTPResponse.t
  def update_user(instance, host, name, password) do 
    body = Map.new |> Map.put_new(:password, password) |> Poison.encode!

    Request.request_query :put,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          body,
                          instance <> "/" <> "users"
                            <> "?" <> "host=#{host}" <> "&"
                                   <> "name=#{name}"

  end

  @doc """
  Deletes a user with the given 'host' and 'name' from the Cloud SQL 'instance'.
  """
  @spec delete_user(binary, binary, binary) :: HTTPResponse.t
  def delete_user(instance, host, name) do 
    Request.request_query :delete,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "users"
                            <> "?" <> "host=#{host}" <> "&"
                                   <> "name=#{name}"
  end

  ###################
  ### Backup Runs ###
  ###################

  @doc """
  Lists all backup runs associated with a given 'instance' and configuration 
  in the reverse chronological order of the backup initiation time.
  """
  @spec list_backup_runs(binary) :: HTTPResponse.t
  def list_backup_runs(instance) do 
    Request.request_query :get,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "backupRuns"
  end

  @doc """
  Retrieves a resource containing information about a backup run with the ID
  of 'run_id' and belonging to the given 'instance'.
  """
  @spec get_backup_run(binary, binary | number) :: HTTPResponse.t
  def get_backup_run(instance, run_id) do 
    gbr instance, run_id
  end

  defp gbr(instance, run_id) when is_integer(run_id) do 
    Request.request_query :get,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "backupRuns" 
                                   <> "/" <> Integer.to_string(run_id)
  end

  defp gbr(instance, run_id) do 
    Request.request_query :get,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "backupRuns" 
                                   <> "/" <> run_id
  end

  @doc """
  Deletes the backup taken by a backup run with ID 'run_id' and belonging to 
  the given 'instance'. 
  """
  @spec delete_backup_run(binary, binary | number) :: HTTPResponse.t
  def delete_backup_run(instance, run_id) do 
    dbr instance, run_id
  end

  defp dbr(instance, run_id) when is_integer(run_id) do 
    Request.request_query :delete,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "backupRuns"
                                   <> "/" <> Integer.to_string(run_id)
  end

  defp dbr(instance, run_id) do 
    Request.request_query :delete,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "backupRuns"
                                   <> "/" <> run_id
  end

  ########################
  ### SSL Certificates ###
  ########################

  @doc """
  Lists all of the current SSL certificates for the 'instance'.
  """
  @spec list_ssl_certs(binary) :: HTTPResponse.t
  def list_ssl_certs(instance) do 
    Request.request_query :get,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "sslCerts"

  end

  @doc """
  Retrieves a particular SSL certificate belonging to the given 'instance' and 
  with the provided 'sh1_fingerprint'. Does not include the private key 
  (required for usage). The private key must be saved from the response 
  to initial creation.
  """
  @spec get_ssl_cert(binary, binary) :: HTTPResponse.t
  def get_ssl_cert(instance, sha1_fingerprint) do 
    Request.request_query :get,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "sslCerts" <> "/" <> sha1_fingerprint
  end

  @doc """
  Creates an SSL certificate for the given 'instance' and gives it the name
  specified in 'common_name' and returns it along with the private key and 
  server certificate authority. 

  For First Generation instances, the new certificate does not take effect 
  until the instance is restarted.
  """
  @spec insert_ssl_cert(binary, binary) :: HTTPResponse.t
  def insert_ssl_cert(instance, common_name) do 
    body = Map.new |> Map.put_new("commonName", common_name) |> Poison.encode!

    Request.request_query :post,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          body,
                          instance <> "/" <> "sslCerts"
  end

  @doc """
  Deletes the SSL certificate with the given 'sha1_fingerprint' from the 
  specified 'instance'.
  """
  @spec delete_ssl_cert(binary, binary) :: HTTPResponse.t
  def delete_ssl_cert(instance, sha1_fingerprint) do 
    Request.request_query :delete,
                          @instance_ep,
                          [],
                          "",
                          instance <> "/" <> "sslCerts" <> "/" <> sha1_fingerprint
  end

  @doc """
  Generates a short-lived X509 certificate containing the provided 'public_key' 
  and signed by a private key specific to the target 'instance'. Users may use 
  the certificate to authenticate as themselves when connecting to the database.
  """
  @spec create_ephemeral_ssl_cert(binary, binary) :: HTTPResponse.t
  def create_ephemeral_ssl_cert(instance, public_key) do 
    body = Map.new |> Map.put_new("public_key", public_key) |> Poison.encode!

    Request.request_query :post,
                          @instance_ep,
                          [{"Content-Type", "application/json"}],
                          body,
                          instance <> "/" <> "createEphemeral"
  end
end
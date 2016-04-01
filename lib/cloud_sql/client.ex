defmodule GCloudex.CloudSQL.Client do
  alias GCloudex.CloudSQL.Request, as: Request

  @project_id Application.get_env(:goth, :json) 
              |> Poison.decode! 
              |> Map.get("project_id")

  #################
  ### Instances ###
  #################

  def list_instances do
    Request.request :get
  end

  def get_instance(instance) do
    Request.request_query :get, [], "", instance
  end
  
  def insert_instance(name, settings, tier) do
    settings = settings
               |> Map.put_new(:tier, tier)

    body     = Map.new
               |> Map.put_new(:name, name)
               |> Map.put_new(:settings, settings)
               |> Poison.encode!

    Request.request :post, [{"Content-Type", "application/json"}], body
  end

  def delete_instance(instance) do 
    Request.request_query :delete, [], "", instance
  end

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
                          [{"Content-Type", "application/json"}], 
                          body, 
                          instance <> "/clone"
  end

  #################
  ### Databases ###
  #################

  def list_databases(instance) do 
    Request.request_query :get, [], "", instance <> "/databases"
  end

  def insert_database(instance, name) do

    body = Map.new
           |> Map.put_new("instance", instance)
           |> Map.put_new("name", name)
           |> Map.put_new("project", @project_id)
           |> Poison.encode!

    Request.request_query :post, 
                          [{"Content-Type", "application/json"}],
                          body,
                          instance <> "/databases"

  end

  def get_database(instance, database) do 
    Request.request_query :get, [], "", 
      instance <> "/databases" <> "/" <> database
  end
end
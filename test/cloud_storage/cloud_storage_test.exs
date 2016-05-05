defmodule Test.Dummy.CloudStorage do 
  use ExUnit.Case
  use GCloudex.CloudStorage.Impl, :cloud_storage

  @endpoint "storage.googleapis.com"
  @project_id GCloudex.get_project_id

  def request_service do
    %{
      verb: :get,
      host: @endpoint,
      body: "",
      headers: 
        [
          {
            {"x-goog-project-id", @project_id},
            {"Authorization", "Bearer Dummy Token"}
          }
        ],
      opts: []
    }
  end

  def request(verb, bucket, headers \\ [], body \\ "") do
    %{
      verb: verb,
      host: bucket <> "." <> @endpoint,
      body: body,
      headers: 
        headers ++ 
        [
          {
            {"x-goog-project-id", @project},
            {"Authorization", "Bearer Dummy Token"}
          }
        ],
      opts: []        
    }
  end

  def request_query(verb, bucket, headers \\ [], body \\ "", parameters) do
    %{
      verb: verb,
      host: bucket <> "." <> @endpoint <> "/" <> parameters,
      body: body,
      headers: 
        headers ++ 
        [
          {
            {"x-goog-project-id", @project},
            {"Authorization", "Bearer Dummy Token"}
          }
        ],
      opts: []        
    }    
  end
end

defmodule CloudStorageTest do
  use ExUnit.Case, async: true
  alias Test.Dummy.CloudStorage, as: API

  @endpoint "storage.googleapis.com"
  @project_id GCloudex.get_project_id

  test "list_buckets" do 
    expected = build_expected(:get, @endpoint, [], "", [])

    assert expected == API.list_buckets
  end

  ###############
  ### Helpers ###
  ###############

  defp build_expected(verb, host, headers, body, parameters) do
    map = %{
      verb: verb, 
      host: host, 
      headers: 
        headers ++         
        [
          {
            {"x-goog-project-id", @project_id},
            {"Authorization", "Bearer Dummy Token"}
          }
        ],
      body: body,
      opts: []
    }
  end
end
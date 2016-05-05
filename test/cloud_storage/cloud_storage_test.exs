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
          {"x-goog-project-id", @project_id},
          {"Authorization", "Bearer Dummy Token"}
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
          {"Authorization", "Bearer Dummy Token"}
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
          {"Authorization", "Bearer Dummy Token"}
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
    expected = build_expected(:get, @endpoint, [{"x-goog-project-id", @project_id}], "")

    assert expected == API.list_buckets
  end

  test "delete_bucket" do 
    expected = build_expected(:delete, "bucket" <> "." <> @endpoint, [], "")

    assert expected == API.delete_bucket "bucket"
  end

  test "list_objects" do
    expected = build_expected(:get, "bucket" <> "." <> @endpoint, [], "")

    assert expected == API.list_objects "bucket"
  end

  test "list_objects with query from non-empty list" do 
    expected = build_expected(
      :get,
      "bucket" <> "." <> @endpoint <> "/" <> "?" <> "key1=abc&key2=def",
      [],
      ""
    )

    assert expected == API.list_objects "bucket", [{"key1", "abc"}, {"key2", "def"}]
  end

  test "list list_objects with query from empty list" do 
    expected = build_expected(
      :get,
      "bucket" <> "." <> @endpoint <> "/" <> "?" <> "",
      [],
      ""
    )

    assert expected == API.list_objects "bucket", []
  end



  ###############
  ### Helpers ###
  ###############

  defp build_expected(verb, host, headers, body, parameters \\ :empty) do
    map = %{
      verb: verb, 
      host: host, 
      headers: 
        headers ++         
        [{"Authorization", "Bearer Dummy Token"}],
      body: body,
      opts: []
    }

    map = 
      if parameters != :empty do 
        Map.put(map, host, host <> "/" <> parameters)
      else
        map
      end
  end
end
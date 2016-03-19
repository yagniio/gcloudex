defmodule GCloudex.CloudStorage.Client do
  alias GCloudex.CloudStorage.Request, as: Request

  @moduledoc """
  Client/Wrapper for Google Cloud Storage.
  """

  @endpoint "storage.googleapis.com"
  @project  Application.get_env(:gcloudex, :storage_proj)

  ###################
  ### GET Service ###
  ###################

  @doc"""
  Lists all the buckets in the specified project.
  """
  def list_buckets do
    Request.request_service
  end

  #####################
  ### DELETE Bucket ###
  #####################

  @doc"""
  Deletes and empty bucket.
  """
  def delete_bucket(bucket) do
    Request.request :delete, bucket, [], ""
  end

  ##################
  ### GET Bucket ###
  ##################

  @doc"""
  Lists all the objects in the specified 'bucket'.
  """
  def list_objects(bucket) do
    Request.request :get, bucket, [], ""
  end

  @doc"""
  Lists all the objects in the specified 'bucket' using the
  given 'query_params'. The query parameters must be passed as a list of tuples
  [{param_1, value_1}, {param_2, value_2}].
  """
  def list_objects(bucket, query_params) do
    Request.request_query :get, bucket, [], "",
      "?" <> parse_query_params(query_params, "")
  end

  @doc"""
  Lists the specified 'bucket' ACL.
  """
  def get_bucket_acl(bucket) do
    Request.request_query :get, bucket, [], "", "?acl"
  end

  @doc"""
  Lists the specified 'bucket' CORS configuration.
  """
  def get_bucket_cors(bucket) do
    Request.request_query :get, bucket, [], "", "?cors"
  end

  @doc"""
  Lists the specified 'bucket' lifecycle configuration.
  """
  def get_bucket_lifecycle(bucket) do
    Request.request_query :get, bucket, [], "", "?lifecycle"
  end

  @doc"""
  Lists the specified 'bucket' location.
  """
  def get_bucket_region(bucket) do
    Request.request_query :get, bucket, [], "", "?location"
  end

  @doc"""
  Lists the specified 'bucket' logging configuration.
  """
  def get_bucket_logging(bucket) do
    Request.request_query :get, bucket, [], "", "?logging"
  end

  @doc"""
  Lists the specified 'bucket' class.
  """
  def get_bucket_class(bucket) do
    Request.request_query :get, bucket, [], "", "?storageClass"
  end

  @doc"""
  Lists the specified 'bucket' versioning configuration.
  """
  def get_bucket_versioning(bucket) do
    Request.request_query :get, bucket, [], "", "?versioning"
  end

  @doc"""
  Lists the specified 'bucket' website configuration.
  """
  def get_bucket_website(bucket) do
    Request.request_query :get, bucket, [], "", "?website"
  end

  ###################
  ### HEAD Bucket ###
  ###################

  @doc"""
  Indicates if the specified 'bucket' exists or whether the request has READ
  access to it.
  """
  def exists_bucket(bucket) do
    Request.request :head, bucket, [], ""
  end

  ##################
  ### PUT Bucket ###
  ##################

  @doc"""
  Creates a bucket with the specified 'bucket' name if available. This
  function will create the bucket in the default region 'US' and with
  the default class 'STANDARD'.
  """
  def create_bucket(bucket) do
    headers = [{"x-goog-project-id", @project}]

    Request.request :put, bucket, headers, ""
  end

  @doc"""
  Creates a bucket with the specified 'bucket' name if available and in
  the specified 'region'. This function will create the bucket with the
  default class 'STANDARD'.
  """
  def create_bucket(bucket, region) do
    headers = [{"x-goog-project-id", @project}]
    body    =
      """
      <CreateBucketConfiguration>
        <LocationConstraint>#{region}</LocationConstraint>
      </CreateBucketConfiguration>
      """

    Request.request :put, bucket, headers, body
  end

  @doc"""
  Creates a bucket with the specified 'bucket' name if available and in
  the specified 'region' and with the specified 'class'.
  """
  def create_bucket(bucket, region, class) do
    headers = [{"x-goog-project-id", @project}]

    body =
      """
      <CreateBucketConfiguration>
        <LocationConstraint>#{region}</LocationConstraint>
        <StorageClass>#{class}</StorageClass>
      </CreateBucketConfiguration>
      """
    Request.request :put, bucket, headers, body
  end

  @doc"""
  Sets or modifies the existing ACL in the specified 'bucket'
  with the given 'acl_config' in XML format.
  """
  def set_bucket_acl(bucket, acl_config) do
    Request.request_query :put, bucket, [], acl_config, "?acl"
  end

  @doc"""
  Sets or modifies the existing CORS configuration in the specified 'bucket'
  with the given 'cors_config' in XML format.
  """
  def set_bucket_cors(bucket, cors_config) do
    Request.request_query :put, bucket, [], cors_config, "?cors"
  end

  @doc"""
  Sets or modifies the existing lifecyle configuration in the specified
  'bucket' with the given 'lifecycle_config' in XML format.
  """
  def set_bucket_lifecycle(bucket, lifecycle_config) do
    Request.request_query :put, bucket, [], lifecycle_config,
      "#{bucket}?lifecycle"
  end

  @doc"""
  Sets or modifies the existing logging configuration in the specified
  'bucket' with the given 'logging_config' in XML format.
  """
  def set_bucket_logging(bucket, logging_config) do
    Request.request_query :put, bucket, [], logging_config, "?logging"
  end

  @doc"""
  Sets or modifies the existing versioning configuration in the specified
  'bucket' with the given 'versioning_config' in XML format.
  """
  def set_bucket_versioning(bucket, versioning_config) do
    Request.request_query :put, bucket, [], versioning_config, "?versioning"
  end

  @doc"""
  Sets or modifies the existing website configuration in the specified
  'bucket' with the given 'website_config' in XML format.
  """
  def set_bucket_website(bucket, website_config) do
    Request.request_query :put, bucket, [], website_config, "?websiteConfig"
  end

  #####################
  ### DELETE Object ###
  #####################

  @doc"""
  Deletes the 'object' in the specified 'bucket'.
  """
  def delete_object(bucket, object) do
    Request.request_query :delete, bucket, [], "", object
  end

  @doc"""
  Deletes the 'object' in the specified 'bucket' using the
  given 'query_params'. The query parameters must be passed as a list of tuples
  [{param_1, value_1}, {param_2, value_2}].
  """
  def delete_object(bucket, object, query_params) do
    Request.request_query :delete, bucket, [], "",
      object <> "?" <> parse_query_params(query_params, "")
  end

  ##################
  ### GET Object ###
  ##################

  @doc"""
  Downloads the 'object' from the specified 'bucket'. The requester must have
  READ permission.
  """
  def get_object(bucket, object) do
    Request.request_query :get, bucket, [], "", object
  end

  @doc"""
  Downloads the 'object' from the specified 'bucket' using the given
  'query_params'. The query parameters must be passed as a list of tuples
  [{param_1, value_1}, {param_2, value_2}]. The requester must have READ
  permission.
  """
  def get_object(bucket, object, query_params) do
    Request.request_query :get, bucket, [], "",
      object <> "?" <> parse_query_params(query_params, "")
  end

  @doc"""
  Lists the 'object' ACL from the specified 'bucket'. The requester must have
  FULL_CONTROL permission.
  """
  def get_object_acl(bucket, object) do
    Request.request_query :get, bucket, [], "", object <> "?acl"
  end

  ###################
  ### HEAD Object ###
  ###################

  @doc"""
  Lists metadata for the given 'object' from the specified 'bucket'.
  """
  def get_object_metadata(bucket, object) do
    Request.request_query :head, bucket, [], "", object
  end

  @doc"""
  Lists metadata for the given 'object' from the specified 'bucket' using the
  given 'query_params'. The query parameters must be passed as a list of tuples
  [{param_1, value_1}, {param_2, value_2}].
  """
  def get_object_metadata(bucket, object, query_params) do
    Request.request_query :head, bucket, [], "", object <> "?" <> query_params
  end

  ##################
  ### PUT Object ###
  ##################

  @doc"""
  Uploads the file in the given 'filepath' to the specified 'bucket'.
  If a 'bucket_path' is specified then the filename must be included at
  the end:

    put_object "somebucket",
               "/home/user/Documents/this_file",
               "new_folder/some_other_folder/this_file"

    => # This will upload the file to the directory in 'bucket_path' and
         will create the directories if they do not exist.
  """
  def put_object(bucket, filepath, bucket_path \\ :empty) do
    body = {:file, filepath}

    case bucket_path do
      :empty -> Request.request_query :put, bucket, [], body, filepath
      _      -> Request.request_query :put, bucket, [], body, bucket_path
    end
  end

  @doc"""
  Copies the specified 'source_object' into the given 'new_bucket' as
  'new_object'.
  """
  def copy_object(new_bucket, new_object, source_object) do
    headers = [{"x-goog-copy-source", source_object}]
    Request.request_query :put, new_bucket, headers, new_object
  end

  @doc"""
  Sets or modifies the 'object' from the specified 'bucket' with the provided
  'acl_config' in XML format.
  """
  def set_object_acl(bucket, object, acl_config) do
    Request.request_query :put, bucket, [], acl_config, object <> "?acl"
  end

  @doc"""
  Sets or modifies the 'object' from the specified 'bucket' with the provided
  'acl_config' in XML format and using the given 'query_params'. The query
  parameters must be passed as a list of tuples
  [{param_1, value_1}, {param_2, value_2}].
  """
  def set_object_acl(bucket, object, acl_config, query_params) do
    Request.request_query :put, bucket, [], acl_config,
      object <> "?acl" <> "&" <> parse_query_params(query_params, "")
  end

  ########################
  ### HELPER FUNCTIONS ###
  ########################

  defp parse_query_params([{param, val} = _head | []], query), do: query <> param <> "=" <> val
  defp parse_query_params([{param, val} = _head | tail], query) do
    parse_query_params tail, query <> param <> "=" <> val <> "&"
  end
end

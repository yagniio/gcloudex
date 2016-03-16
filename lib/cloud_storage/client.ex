defmodule GCloudex.CloudStorage.Client do
  alias GCloudex.CloudStorage.Request, as: Request

  @moduledoc """
  
  """

  @endpoint "storage.googleapis.com"
  @project  Application.get_env(:gcloudex, :storage_proj)

  ###################
  ### GET Service ###
  ###################
  
  def list_buckets do
    Request.request_service
  end

  #####################
  ### DELETE Bucket ###
  #####################

  def delete_bucket(bucket) do 
    Request.request :delete, bucket, [], ""
  end

  ##################
  ### GET Bucket ###
  ##################

  def list_objects(bucket) do
    Request.request :get, bucket, [], "" 
  end

  def get_bucket_acl(bucket) do 
    Request.request_query :get, bucket, [], "", "?acl"
  end  

  def get_bucket_cors(bucket) do 
    Request.request_query :get, bucket, [], "", "?cors"
  end

  def get_bucket_lifecycle(bucket) do 
    Request.request_query :get, bucket, [], "", "?lifecycle"
  end

  def get_bucket_region(bucket) do 
    Request.request_query :get, bucket, [], "", "?location"
  end

  def get_bucket_logging(bucket) do 
    Request.request_query :get, bucket, [], "", "?logging"
  end

  def get_bucket_class(bucket) do 
    Request.request_query :get, bucket, [], "", "?storageClass"
  end

  def get_bucket_versioning(bucket) do 
    Request.request_query :get, bucket, [], "", "?versioning"
  end

  def get_bucket_website(bucket) do 
    Request.request_query :get, bucket, [], "", "?website"
  end

  ###################
  ### HEAD Bucket ###
  ###################

  def exists_bucket(bucket) do 
    Request.request :head, bucket, [], ""
  end

  ##################
  ### PUT Bucket ###
  ##################

  def create_bucket(bucket) do 
    headers = [{"x-goog-project-id", @project}]

    Request.request :put, bucket, headers, ""
  end

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

  def set_bucket_acl(bucket, acl_config) do 
    Request.request_query :put, bucket, [], acl_config, "?acl"
  end

  def set_bucket_cors(bucket, cors_config) do 
    Request.request_query :put, bucket, [], cors_config, "?cors"
  end

  def set_bucket_lifecycle(bucket, lifecycle_config) do 
    Request.request_query :put, bucket, [], lifecycle_config, "#{bucket}?lifecycle"
  end

  def set_bucket_logging(bucket, logging_config) do 
    Request.request_query :put, bucket, [], logging_config, "?logging"
  end

  def set_bucket_versioning(bucket, versioning_config) do 
    Request.request_query :put, bucket, [], versioning_config, "?versioning"
  end

  def set_bucket_website(bucket, website_config) do 
    Request.request_query :put, bucket, [], website_config, "?websiteConfig"
  end

  #####################
  ### DELETE Object ###
  #####################

  def delete_object(bucket, object) do 
    Request.request_query :delete, bucket, [], "", object
  end  

  ##################
  ### GET Object ###
  ##################

  def get_object(bucket, object) do 
    Request.request_query :get, bucket, [], "", object
  end

  def get_object_acl(bucket, object) do 
    Request.request_query :get, bucket, [], "", object <> "?acl"
  end  

  ###################
  ### HEAD Object ###
  ###################

  def get_object_metadata(bucket, object) do 
    Request.request_query :head, bucket, [], "", object
  end

  ##################
  ### PUT Object ###
  ##################

  def put_object(bucket, filepath) do 
    body = {:file, filepath}

    Request.request_query :put, bucket, [], body, filepath
  end

  def copy_object(new_bucket, new_object, source_object) do 
    headers = [{"x-goog-copy-source", source_object}]
    Request.request_query :put, new_bucket, headers, new_object
  end
end
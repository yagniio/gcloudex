defmodule GCloudex.ComputeEngine.Images do
  use GCloudex.ComputeEngine, :client

  @moduledoc """
  Wrapper for the Compute Engine's Images endpoint.
  """

  @doc """
  Retrieves the list of private images available (project scoped only).
  """
  @spec list_images(map) :: HTTPResponse.t
  def list_images(query_params \\ %{}) do
    query = query_params |> URI.encode_query

    HTTP.request :get, @no_zone_ep <> "/global/images", [], "", query
  end

  @doc """
  Returns the specified 'image'.
  """
  @spec get_image(binary, binary) :: HTTPResponse.t
  def get_image(image, fields \\ "") do 
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end  

    HTTP.request(:get, @no_zone_ep <> "/global/images/#{image}", [], "", query)
  end

  @doc """
  Creates an image with the provided 'image_resource'.
  """
  @spec insert_image_with_resource(map, binary) :: HTTPResponse.t
  def insert_image_with_resource(image_resource, fields \\ "") when is_map(image_resource) do 
    body  = image_resource |> Poison.encode!
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end      

    HTTP.request(
      :post, 
      @no_zone_ep <> "/global/images", 
      [{"Content-Type", "application/json"}], 
      body,
      query)    
  end

  @doc """
  Creates an image with the given 'name' and 'source_url'. This function uses
  the minimal amount of parameters needed to build the image. For a more 
  detailed image creation use insert_image_with_resource/2 where more complex 
  Image Resources can be passed.
  """
  @spec insert_image(binary, binary, binary) :: HTTPResponse.t
  def insert_image(name, source_url, fields \\ "") do
    body  = %{"name" => name, "rawDisk" => %{"source" => source_url}} |> Poison.encode!
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end  

    HTTP.request(
      :post, 
      @no_zone_ep <> "/global/images", 
      [{"Content-Type", "application/json"}], 
      body,
      query)
  end

  @doc """
  Deletes the specified 'image'.
  """
  @spec delete_image(binary, binary) :: HTTPResponse.t
  def delete_image(image, fields \\ "") do
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end  

    HTTP.request(:delete, @no_zone_ep <> "/global/images/#{image}", [], "", query)
  end

  @doc """
  Sets the deprecation status of an 'image' using the data provided in the
  'request_params'. 
  """
  @spec deprecate_image(binary, map, binary) :: HTTPResponse.t
  def deprecate_image(image, request_params, fields \\ "") do 
    body  = request_params |> Poison.encode!
    query = 
      if fields == "" do 
        fields
      else
        %{"fields" => fields} |> URI.encode_query
      end

    HTTP.request(
      :post,
      @no_zone_ep <> "/global/images/#{image}/deprecate", 
      [{"Content-Type", "application/json"}], 
      body, 
      query)
  end
end
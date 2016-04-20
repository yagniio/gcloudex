defmodule GCloudex.ComputeEngine.Images do
  use GCloudex.ComputeEngine, :client

  @doc """
  Retrieves the list of private images available (project scoped only).
  """
  @spec list_images(binary) :: HTTPResponse.t
  def list_images(fields \\ "") do
    query = fields |> URI.encode

    Request.request :get, @no_zone_ep <> "/global/images", [], "", query
  end

  @doc """
  Returns the specified 'image'.
  """
  @spec get_image(binary, binary) :: HTTPResponse.t
  def get_image(image, fields \\ "") do 
    query = fields |> URI.encode

    Request.request(:get, @no_zone_ep <> "/global/images/#{image}", [], "", query)
  end

  @doc """
  Creates an image with the provided 'image_resource'.
  """
  @spec insert_image(map) :: HTTPResponse.t
  def insert_image(image_resource) when is_map(image_resource) do 
    body  = image_resource |> Poison.encode!

    Request.request(
      :post, 
      @no_zone_ep <> "/global/images", 
      [{"Content-Type", "application/json"}], 
      body)    
  end

  @doc """
  Creates an image with the given 'name' and 'source_url'. This function uses
  the minimal amount of parameters needed to build the image. For a more 
  detailed image creation use insert_image/1 where more complex Image
  Resources can be passed.
  """
  @spec insert_image(binary, binary, binary) :: HTTPResponse.t
  def insert_image(name, source_url, fields \\ "") do
    body  = %{"name" => name, "rawDisk" => %{"source" => source_url}} |> Poison.encode!
    query = fields |> URI.encode

    Request.request(
      :post, 
      @no_zone_ep <> "/global/images", 
      [{"Content-Type", "application/json"}], 
      body,
      query)
  end

  def delete_image(image, fields \\ "") do
    query = fields |> URI.encode

    Request.request(:delete, @no_zone_ep <> "/global/images/#{image}", [], "", query)
  end
end
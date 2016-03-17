defmodule GCloudex.CloudStorage.Request do
  alias HTTPoison, as: HTTP
  alias GCloudex.Auth, as: Auth

  @moduledoc """
  Builds and sends HTTP requests for the Google Cloud Storage client module.
  """

	### MUST ADD THE PARAMETER FOR DESIRED SCOPE ###

  @endpoint "storage.googleapis.com"
  @project  Application.get_env(:gcloudex, :storage_proj)

	@doc"""
	Sends an HTTP request according to the Service resource in the Google Cloud
	Storage documentation.
	"""
  def request_service do 
    HTTP.request(
      :get,
      @endpoint,
      "",
      [
        {"x-goog-project-id", @project},
        {"Authorization", "Bearer #{Auth.get_token_storage(:full_control)}"}
      ],
      []
    )
  end

	@doc"""
	Sends an HTTP request without any query parameters.
	"""
  def request(verb, bucket, headers \\ [], body \\ "") do 
    HTTP.request(
      verb,
      bucket <> "." <> @endpoint,
      body,
      headers ++ [{"Authorization", "Bearer #{Auth.get_token_storage(:full_control)}"}],
      []
    )
  end

	@doc"""
	Sends an HTTP request with the specified query parameters.
	"""
  def request_query(verb, bucket, headers \\ [], body \\ "", parameters) do 
    HTTP.request(
      verb, 
      bucket <> "." <> @endpoint <> "/" <> parameters,
      body,
      headers ++ [{"Authorization", "Bearer #{Auth.get_token_storage(:full_control)}"}],
      []
    )
  end
end

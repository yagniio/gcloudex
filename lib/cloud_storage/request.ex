defmodule GCloudex.CloudStorage.Request do
  alias HTTPoison, as: HTTP
  alias GCloudex.Auth, as: Auth

  @moduledoc """
  Offers HTTP requests to be used in by the Google Cloud Storage wrapper.
  """

  ### MUST ADD THE PARAMETER FOR DESIRED SCOPE ###

  @endpoint "storage.googleapis.com"
  @project  Application.get_env(:gcloudex, :project)

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
      headers ++ [{"Authorization",
                   "Bearer #{Auth.get_token_storage(:full_control)}"}],
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
      headers ++ [{"Authorization",
                   "Bearer #{Auth.get_token_storage(:full_control)}"}],
      []
    )
  end
end

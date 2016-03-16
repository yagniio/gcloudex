defmodule GCloudex.Auth do
  alias Goth,      as: GoogleAuth

  @storage_scope_full_control "https://www.googleapis.com/auth/devstorage.full_control"

  def get_token_storage(type) do 
    case type do 
      :full_control ->
        {:ok, get_token_response} = GoogleAuth.Token.for_scope @storage_scope_full_control

        get_token_response
        |> Map.get(:token)
    end
  end   
end

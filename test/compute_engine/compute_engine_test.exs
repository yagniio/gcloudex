defmodule Test.Dummy.ComputeEngine do
  use GCloudex.ComputeEngine.Impl, :compute_engine
  
  @project_id GCloudex.get_project_id

  def request(verb, endpoint, headers, body, parameters \\ "") do 
    %{
      verb: verb,
      endpoint: endpoint,
      body: body
      headers: 
        headers ++ 
        [
          {"x-goog-project-id", @project_id},
          {"Authorization", "Bearer #{Auth.get_token_storage(:compute)}"}
        ],
      opts: []
    }
  end
end

defmodule ComputeEngineTest do 
  use ExUnit.Case, async: true
  alias Test.Dummy.ComputeEngine, as: API

  @endpoint "storage.googleapis.com"
  @project_id GCloudex.get_project_id

end
defmodule GCloudex do

  @moduledoc """
  Collection of client API's for Google Cloud Platform.
  """

  def get_project_id do
    :goth
    |> Application.get_env(:json) 
    |> Poison.decode! 
    |> Map.get("project_id")
  end
end

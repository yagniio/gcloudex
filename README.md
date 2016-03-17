# GCloudex

 Collection of client/wrappers for several Google Cloud Platform service's API's 

## Installation

  1. Add gcloudex to your list of dependencies in `mix.exs`:

        def deps do
          [{:gcloudex, git: "git@github.com:sashaafm/gcloudex.git"}]
        end

  2. Ensure gcloudex is started before your application:

        def application do
          [applications: [:gcloudex]]
        end

## Roadmap

 1. Google Cloud Storage
 2. Google Compute Engine
 3. Google Cloud Datastore

### Cloud Storage usage example:

> GCloudex.CloudStorage.Client.list_buckets # => {:ok, %HTTPoison.Response{body: ..., status_code: 200}}
> GCloudex.CloudStorage.CLient.put_object "bucket_name", "this_file.txt" # => {:ok, %HTTPoison.Response{body: ..., status_code: 200}}

require 'yaml'

Puppet::Functions.create_function(:'pe_metric_curl_cron_jobs::to_yaml') do
  dispatch :to_yaml do
    param 'Hash', :hash_or_array
  end
  dispatch :to_yaml do
    param 'Array', :hash_or_array
  end

  def to_yaml(hash_or_array)
    hash_or_array.to_yaml
  end
end

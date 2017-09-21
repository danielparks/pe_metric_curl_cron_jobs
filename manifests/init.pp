class pe_metric_curl_cron_jobs (
  # DEPRECATED API ==============================
  Optional[String]        $puppet_server_metrics_ensure  = undef,
  Optional[Array[String]] $puppet_server_hosts           = undef,
  # CURRENT API =================================
  String        $base_dir                      = '/opt/puppetlabs/pe_metric_curl_cron_jobs',
  String        $output_dir                    = "${base_dir}/output",
  Integer       $collection_frequency          = 5,
  Integer       $retention_days                = 90,
  String        $puppetserver_metrics_ensure   = pick($pe_metric_curl_cron_jobs::puppet_server_metrics_ensure, 'present'),
  Array[String] $puppetserver_hosts            = pick($pe_metric_curl_cron_jobs::puppet_server_hosts, [ '127.0.0.1' ]),
  Integer       $puppetserver_port             = 8140,
  String        $puppetdb_metrics_ensure       = 'present',
  Array[String] $puppetdb_hosts                = [ '127.0.0.1' ],
  Integer       $puppetdb_port                 = 8081,
  String        $orchestrator_metrics_ensure   = 'present',
  Array[String] $orchestrator_hosts            = [ '127.0.0.1' ],
  Integer       $orchestrator_port             = 8143,
  String        $activemq_metrics_ensure       = 'absent',
  Array[String] $activemq_hosts                = [ '127.0.0.1' ],
  Integer       $activemq_port                 = 8161,
  String        $tidy_hour                     = '1',
) {
  $scripts_dir = "${base_dir}/scripts"

  user { 'pe_metric_curl_cron_jobs':
    ensure     => present,
    home       => $output_dir,
    managehome => false,
    system     => true,
    shell      => '/sbin/nologin',
  }

  file {
    [$base_dir, $scripts_dir]:
      ensure       => directory,
      owner        => 'root',
      group        => 'root',
      mode         => '0555',
      purge        => true,
      force        => true,
      recurse      => true,
      # Don't purge the output directory:
      recurselimit => 1,
    ;
    "${scripts_dir}/tk_metrics" :
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0555',
      source => 'puppet:///modules/pe_metric_curl_cron_jobs/tk_metrics',
    ;
    $output_dir:
      ensure => directory,
      owner  => 'pe_metric_curl_cron_jobs',
      group  => 'pe_metric_curl_cron_jobs',
      mode   => '0755',
    ;
  }

  include pe_metric_curl_cron_jobs::puppetserver

  include pe_metric_curl_cron_jobs::puppetdb

  include pe_metric_curl_cron_jobs::orchestrator

  include pe_metric_curl_cron_jobs::activemq

  # Emit deprecation warnings if necessary
  if ($puppet_server_metrics_ensure != undef) {
    warning('Using deprecated parameter pe_metric_curl_cron_jobs::puppet_server_metrics_ensure! please use pe_metric_curl_cron_jobs::puppetserver_metrics_ensure instead.')
  }
  if ($puppet_server_hosts != undef) {
    warning('Using deprecated parameter pe_metric_curl_cron_jobs::puppet_server_hosts! please use pe_metric_curl_cron_jobs::puppetserver_hosts instead.')
  }

}

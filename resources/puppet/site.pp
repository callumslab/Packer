include chocolatey

class { 'wsus_client':
  server_url           => 'http://wsus.hosting.zen.co.uk',
  enable_status_server => true,
}

package { 'nscp':
  ensure   => installed,
  provider => 'chocolatey',
}

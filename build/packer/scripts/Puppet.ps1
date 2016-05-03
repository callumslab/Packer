# Download and install Puppet
Invoke-WebRequest -Uri 'https://downloads.puppetlabs.com/windows/puppet-agent-x64-latest.msi' -OutFile 'c:\zendata\puppet-agent-x64-latest.msi'

msiexec /qn /norestart /i c:\zendata\puppet-agent-x64-latest.msi

#Running the below to force Windows to download the CA chain and avoid the following error (when downloading puppet modules later):
#Error: Could not connect via HTTPS to https://forgeapi.puppetlabs.com
#  Unable to verify the SSL certificate
#    The certificate may not be signed by a valid CA
#    The CA bundle included with OpenSSL may not be valid or up to date
Invoke-WebRequest -Uri 'https://forgeapi.puppetlabs.com' | Out-Null

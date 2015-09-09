name              "keepalived"
maintainer        "C2 Team"
maintainer_email  "pacificador@defesa.mil.br"
license           "Apache 2.0"
description       "Fork keepalived Opscode, Inc. - Installs and configures keepalived"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.3.0"
supports          "ubuntu"
supports          "debian"

recipe "keepalived", "Installs and configures keepalived"

source_url 'https://github.com/chef-cookbooks/keepalived' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/keepalived/issues' if respond_to?(:issues_url)

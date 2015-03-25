name              "keepalived"
maintainer        "Chef Software, Inc."
maintainer_email  "cookbooks@chef.io"
license           "Apache 2.0"
description       "Installs and configures keepalived"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.2.0"
supports          "ubuntu"
supports          "centos"

recipe "keepalived", "Installs and configures keepalived"

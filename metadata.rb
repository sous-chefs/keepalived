name              "keepalived"
maintainer        "C2 Team"
maintainer_email  "pacificador@defesa.mil.br"
license           "Apache 2.0"
description       "Fork keepalived Opscode, Inc. - Installs and configures keepalived"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.3.0"
supports          "ubuntu"

recipe "keepalived", "Installs and configures keepalived"

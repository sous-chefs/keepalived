name              "keepalived"
maintainer        "Rackspace US, Inc."
maintainer_email  "rcb-deploy@lists.rackspace.com"
license           "Apache 2.0"
description       "Installs and configures keepalived"
long_description  IO.read(File.join(File.dirname(__FILE__), "README.md"))
version           "1.0.5"

%w{ amazon centos debian fedora oracle redhat scientific ubuntu }.each do |os|
  supports os
end

%w{ sysctl osops-utils }.each do |dep|
  depends dep
end

recipe "keepalived", "Installs and configures keepalived"

attribute "haproxy/admin_port",
  :description => "The haproxy admin port",
  :default => "8040"

attribute "keepalived/shared_address",
  :description => "Determine if the address is shared",
  :default => "false"

attribute "keepalived/global/notification_emails",
  :description => "The email address keepalived sends notifications to",
  :default => "admin@example.com"

attribute "keepalived/global/notification_email_from",
  :description => "The email address keepalived come from",
  :default => 'keepalived@#{node["domain"] || "example.com"}"'

attribute "keepalived/global/smtp_server",
  :description => "The smtp server keepalived will use to send notifications",
  :default => "127.0.0.1"

attribute "keepalived/global/smtp_connect_timeout",
  :description => "The smtp server timeout for notifications",
  :default => "30"

attribute "keepalived/global/router_id",
  :description => "The keepalived router id",
  :default => 'node["fqdn"]'

attribute "keepalived/global/router_ids",
  :description => "The keepalived router ids collection",
  :default => "{}"

attribute "keepalived/check_scripts",
  :description => "The keepalived check scripts collections",
  :default => "{}"

attribute "keepalived/instance_defaults/state",
  :description => "The default state to apply to instances",
  :default => "MASTER"

attribute "keepalived/instance_defaults/priority",
  :description => "The default priority to apply to instances",
  :default => "100"

attribute "keepalived/instance_defaults/virtual_router_id",
  :description => "The default virtual router id to apply to instances",
  :default => "10"

attribute "keepalived/instances",
  :description => "The keepalived instances",
  :default => "8040"

attribute "keepalived/vs_defaults/lb_algo",
  :description => "The default algorythm to apply to virtual servers",
  :default => "rr"

attribute "keepalived/vs_defaults/lb_kind",
  :description => "The default load balancing kind to apply to virtual servers",
  :default => "nat"

attribute "keepalived/vs_defaults/delay_loop",
  :description => "The default delay loop to apply to virtual servers",
  :default => "15"

attribute "keepalived/vs_defaults/protocol",
  :description => "The default protocl to apply to virtual servers",
  :default => "tcp"

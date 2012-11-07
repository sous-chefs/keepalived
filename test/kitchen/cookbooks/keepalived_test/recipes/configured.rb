node.set[:keepalived][:shared_address] = true
node.set[:keepalived][:global][:notification_emails] = 'admin@example.com'
node.set[:keepalived][:global][:notification_email_from] = "keepalived@example.com"
node.set[:keepalived][:global][:smtp_server] = '127.0.0.1'
node.set[:keepalived][:global][:smtp_connect_timeout] = 30
node.set[:keepalived][:global][:router_id] = 'DEFAULT_ROUT_ID'
node.set[:keepalived][:check_scripts][:chk_init] = {
  :script => 'killall -0 init',
  :interval => 2,
  :weight => 2
}
node.set[:keepalived][:instances][:vi_1] = {
  :ip_addresses => '10.0.2.254',
  :interface => 'eth0',
  :track_script => 'chk_init',
  :nopreempt => false,
  :advert_int => 1,
  :authentication_type => nil, # :pass or :ah
  :authentication_pass => 'secret'
}

include_recipe 'keepalived'

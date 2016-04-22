require 'spec_helper'

describe Keepalived::Helpers do
  let(:smtp_check) do
    ChefKeepalived::Resource::SmtpCheck.new('port-465').tap do |r|
      r.fwmark 3
      r.delay_before_retry 10
      r.helo_name 'smtp.example.com'
      r.warmup 3
      r.host(
        connect_ip: '192.168.1.20',
        connect_port: 3306,
        bindto: '192.168.1.5',
        bind_port: 3308,
        connect_timeout: 5,
        fwmark: 3
      )
    end
  end

  let(:smtp_check_string) do
    "fwmark 3\n\twarmup 3\n\thost {\n\t\tconnect_ip 192.168.1.20\n\t\tconnect_port 3306\n\t\tbindto 192.168.1.5\n\t\tbind_port 3308\n\t\tconnect_timeout 5\n\t\tfwmark 3\n\t\t}\n\tdelay_before_retry 10\n\thelo_name smtp.example.com"
  end

  it 'converts a resource to an appropriate sub-block' do
    expect(Keepalived::Helpers.conf_string(smtp_check, Keepalived::SmtpCheck::OPTIONS)).to eq smtp_check_string
  end

  let(:hash) do
    { path: '/', status_code: 200 }
  end

  let(:hash_string) { "url {\n\t\tpath /\n\t\tstatus_code 200\n\t\t}" }

  it 'properly converts hashes to config blocks' do
    expect(Keepalived::Helpers.convert(:url, hash)).to eq hash_string
  end

  let(:array) do
    %w( me@example.com root@localhost )
  end

  let(:array_string) { "notification_email {\n\t\tme@example.com\n\t\troot@localhost\n\t\t}" }

  it 'properly converts arrays to config blocks' do
    expect(Keepalived::Helpers.convert(:notification_email, array)).to eq array_string
  end

  it 'properly converts boolean options to config directives' do
    expect(Keepalived::Helpers.convert(:debug, true)).to eq 'debug'
  end

  it 'properly converts string/integer options to config directives' do
    expect(Keepalived::Helpers.convert(:weight, 5)).to eq 'weight 5'
  end

  it 'properly configures sub-blocks' do
    expect(Keepalived::Helpers.sub_block(:notification_email_from, "me@example.com\n\t\troot@localhost")).to eq "notification_email_from {\n\t\tme@example.com\n\t\troot@localhost\n\t\t}"
  end
end

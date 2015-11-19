mpd_config "mpd" do
  bind_to_address "0.0.0.0"
  port '6600'
  audio_outputs ([
    {
      'type' => "httpd",
      'name' => "HTTP Stream",
      'encoder' => "vorbis",
      'port' => "8000",
      'bind_to_address' => "0.0.0.0",
      'quality' => "10.0",
      #'bitrate' => "128",
      'format' => "44100:16:2",
      'max_clients' => "0",
    },
    {
      'type' => "null",
      'name' => "Null Output",
      'mixer_type' => "none",
    }
  ])
  action :install
end

## create startup script for phusion baseimage

file "/etc/my_init.d/95_chef_startup" do
  content(<<-EOF
#!/bin/bash
#{node['chef_client']['bin']} #{node['chef_client']['daemon_options'].join(' ')} -o mpd::startup
  EOF
  )
  mode '0755'
end

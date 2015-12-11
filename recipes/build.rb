mpd_config "mpd" do
  bind_to_address "0.0.0.0"
  port '6600'
  inputs ([
    {
      'plugin' => "curl"
    }
  ])
  audio_outputs ([
    {
      'type' => "httpd",
      'name' => "HTTP Stream",
      'encoder' => "flac",
      'compression' => "3",
      'port' => "8000",
      'bind_to_address' => "0.0.0.0",
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

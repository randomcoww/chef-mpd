actions :install, :startup
default_action :install

attribute :name, :kind_of => [String], :name_attribute => true
attribute :mpd_package, :kind_of => [String], :default => 'mpd'
attribute :service_name, :kind_of => [String], :default => 'mpd'
attribute :mpd_conf, :kind_of => [String], :default => '/etc/mpd.conf'
attribute :mpd_conf_template, :kind_of => [String], :default => 'mpd.conf.erb'
attribute :mpd_conf_cookbook, :kind_of => [String], :default => 'mpd'

attribute :user, :kind_of => [String], :default => 'mpd'
attribute :bind_to_address, :kind_of => [String], :default => 'localhost'
attribute :port, :kind_of => [String], :default => '6600'

attribute :music_directory, :kind_of => [String], :default => '/var/lib/mpd/music'
attribute :playlist_directory, :kind_of => [String], :default => '/var/lib/mpd/playlists'

attribute :db_file, :kind_of => [String], :default => '/var/lib/mpd/tag_cache'
attribute :state_file, :kind_of => [String], :default => '/var/lib/mpd/state'
attribute :sticker_file, :kind_of => [String], :default => '/var/lib/mpd/sticker.sql'

attribute :mpd_conf_variables, :kind_of => [Hash], :default => {
  'filesystem_charset' => 'UTF-8',
  'id3v1_encoding' => 'UTF-8',
}

attribute :inputs, :kind_of => [Array], :default => [
  {
    'plugin' => 'curl'
  }
]

attribute :audio_outputs, :kind_of => [Array], :default => [
  {
    'type' => 'alsa',
    'name' => 'My ALSA Device'
  }
]

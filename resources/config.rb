actions :install
default_action :install

attribute :service, :kind_of => [String], :name_attribute => true

attribute :mpd_packages, :kind_of => [Array], :default => [
  'mpd'
]

attribute :user, :kind_of => [String], :default => 'mpd'

attribute :mpd_conf_cookbook, :kind_of => [String], :default => 'mpd'
attribute :mpd_conf_template, :kind_of => [String], :default => 'mpd.conf.erb'

attribute :port, :kind_of => [String], :default => '6600'
attribute :bind_to_address, :kind_of => [String], :default => '0.0.0.0'

## main conf
attribute :mpd_conf_file, :kind_of => [String], :default => '/etc/mpd.conf'
## mount external music path
attribute :music_directory, :kind_of => [String], :default => '/var/lib/mpd/music'
## service state - mount from volume container
attribute :cache_directory, :kind_of => [String], :default => '/var/lib/mpd/cache'
## playlists - possibly mount from volume container
attribute :playlist_directory, :kind_of => [String], :default => '/var/lib/mpd/playlists'

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

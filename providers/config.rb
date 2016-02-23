def load_current_resources
  @current_resource = Chef::Resource::MpdConfig.new(new_resource.service)
  @current_resource
end




def install_packages
  new_resource.mpd_packages.each do |e|
    package e do
      action :upgrade
      notifies :restart, mpd_service
    end
  end
end

def mpd_service
  return @mpd_service unless @mpd_service.nil?

  @mpd_service = runit_service new_resource.service do
    run_template_name 'mpd'
    log_template_name 'mpd'
    options(
      mpd_conf_file: new_resource.mpd_conf_file,
      user: new_resource.user,
      create_directories: [
        new_resource.music_directory,
        new_resource.cache_directory,
        new_resource.playlist_directory
      ],
      change_owners: [
        new_resource.cache_directory,
        ::File.join(new_resource.cache_directory, '*'),
        new_resource.playlist_directory,
        ::File.join(new_resource.playlist_directory, '*')
      ]
    )
    restart_on_update false
    action :nothing
  end

  return @mpd_service
end

def mpd_conf_file
  return @mpd_conf_file unless @mpd_conf_file.nil?

  @mpd_conf_file = template "#{new_resource.service}_mpd_conf_file" do
    path new_resource.mpd_conf_file
    source new_resource.mpd_conf_template
    owner new_resource.user
    cookbook new_resource.mpd_conf_cookbook
    variables ({
      'user' => new_resource.user,
      'bind_to_address' => new_resource.bind_to_address,
      'port' => new_resource.port,
      'music_directory' => new_resource.music_directory,
      'cache_directory' => new_resource.cache_directory,
      'playlist_directory' => new_resource.playlist_directory,
      'inputs' => new_resource.inputs,
      'audio_outputs' => new_resource.audio_outputs,
    })
    action :nothing
    notifies :restart, mpd_service
  end

  return @mpd_conf_file
end




def action_install
  converge_by("Install MPD") do
    install_packages
    mpd_conf_file.run_action(:create)
    mpd_service.run_action(:enable)
  end
end

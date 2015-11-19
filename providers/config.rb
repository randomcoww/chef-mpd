def load_current_resources
  @current_resource = Chef::Resource::MpdConfig.new(new_resource.name)
  @current_resource
end





def mpd_package
  return @mpd_package unless @mpd_package.nil?

  @mpd_package = package new_resource.mpd_package do
    action :nothing
  end

  return @mpd_package
end

def mpd_service
  return @mpd_service unless @mpd_service.nil?

  @mpd_service = runit_service new_resource.service_name do
    run_template_name 'mpd'
    log_template_name 'mpd' 
    options(
      conf: new_resource.mpd_conf
    )
    #restart_on_update false
    action :nothing
  end

  return @mpd_service
end

def mpd_conf
  return @mpd_conf unless @mpd_conf.nil?

  mpd_service

  [new_resource.music_directory].each do |d|
    directory d do
      owner new_resource.user
      recursive true
      action :nothing
    end.run_action(:create_if_missing)
  end

  [new_resource.playlist_directory].each do |d|
    directory d do
      owner new_resource.user
      recursive true
      action :nothing
    end.run_action(:create)
  end

  [new_resource.db_file, new_resource.state_file, new_resource.sticker_file].each do |f|
    directory ::File.dirname(f) do
      owner new_resource.user
      recursive true
      action :nothing
    end.run_action(:create)
  end

  @mpd_conf = template "#{new_resource.name}_mpd_conf" do
    path new_resource.mpd_conf
    source new_resource.mpd_conf_template
    owner new_resource.user
    cookbook new_resource.mpd_conf_cookbook
    variables ({
      'mpd_conf_variables' => {
        'user' => new_resource.user,
        'bind_to_address' => new_resource.bind_to_address,
        'port' => new_resource.port,

        'music_directory' => new_resource.music_directory,
        'playlist_directory' => new_resource.playlist_directory,

        'db_file' => new_resource.db_file,
        'state_file' => new_resource.state_file,
        'sticker_file' => new_resource.sticker_file,

      }.merge(new_resource.mpd_conf_variables),

      'inputs' => new_resource.inputs,
      'audio_outputs' => new_resource.audio_outputs,
    })
    action :nothing
    notifies :restart, "service[#{new_resource.service_name}]"
  end

  return @mpd_conf
end





def action_install
  converge_by("Install MPD") do
    mpd_package.run_action(:install)
    mpd_conf.run_action(:create)
    mpd_service.run_action(:enable)
  end
end

def action_startup
  converge_by("Startup configuration for MPD") do
    mpd_conf.run_action(:create)
  end
end

Vagrant.configure(2) do |config|
  config.vm.box = "gbailey/amzn2"
  config.vm.network "forwarded_port", guest:1194, host:1194, protocol:"udp"
  config.vm.hostname = "vpn"

  [
    'docker-openvpn@data.service',
    'openvpn-backup.tar.gz'
  ].each do |file|
    src = "files/#{file}"
    dest = "/tmp/#{file}"
    config.vm.provision "file", source: src, destination: dest
  end

  config.vm.provision "file", source: "scripts/configure_node.sh", destination: "/tmp/configure_node.sh"
  config.vm.provision "shell", inline: "/tmp/configure_node.sh"
end

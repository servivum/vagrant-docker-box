Vagrant.configure(2) do |config|
    config.vm.hostname = "servivum.dev"

    # See Vagrant documentation for more information.
    config.vm.box = "debian/jessie64"
    config.vm.network "private_network", ip: "192.168.13.37"
    config.ssh.forward_agent = true

    if OS.windows?
        config.vm.synced_folder ".", "/vagrant", type: "smb", mount_options: ["mfsymlinks,dir_mode=0755,file_mode=0755"]
    elsif OS.mac?
        config.vm.synced_folder ".", "/vagrant", type: "nfs"
    end

    # Fix "stdin: is not a tty" message
    config.vm.provision "fix-no-tty", type: "shell" do |s|
        s.privileged = false
        s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    end

    # Installing and configuring essentials
    config.vm.provision :shell, path: "vagrant/10_base.sh"

    # Install Docker & Docker Compose. The Docker provisioner of vagrant is behind in version.
    config.vm.provision :shell, path: "vagrant/15_docker.sh"

    # Run Docker Compose file on each startup
    config.vm.provision "shell", run: "always", inline: <<-SHELL
        cd /vagrant
        docker-compose up -d
    SHELL

    # Custom tasks from inline Shell commands
    config.vm.provision "shell", inline: <<-SHELL
        # Put your Shell commands here ...
        echo "Running inline custom tasks ..."
    SHELL

    # Custom tasks from external file. Recommended for many commands.
    config.vm.provision :shell, path: "vagrant/30_custom.sh"

    # Show IP address and hostname
    config.vm.provision "shell", inline: "
    echo \" \"
    echo \"--- PUT THIS LINE IN YOUR HOST FILE ---\"
    echo \" \"
    echo `/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'` `hostname -f`
    echo \" \"
    echo \"---------------------------------------\"
    echo \" \"
    ", run: "always"

    # Introduction message
    config.vm.post_up_message = "Servivum Docker environment is up and running! See https://github.com/servivum/vagrant-docker-box for more details."
end

# OS detection is used for shared folder type.
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end
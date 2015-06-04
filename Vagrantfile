# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

settings = YAML.load_file 'vagrant.yml'

PASSWORD_ERROR_MESSAGE = "You need to set your postgres password in vagrant.yml to something other than 'password'"

raise PASSWORD_ERROR_MESSAGE if settings["postgres"]["password"] == "password"

project_name = settings["project"]["name"]
postgresql_username = settings["postgres"]["username"]
postgresql_password = settings["postgres"]["password"]
forwarded_ports = settings["forwarded_ports"] || { :"3000" => 3000 }

Vagrant.configure(2) do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "ubuntu/trusty64"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/#{project_name}"

  config.vbguest.auto_update = true

  config.vm.provider :virtualbox do |vb|
    vb.memory = "2048"
  end

  forwarded_ports.each do |guest_port, host_port|
    config.vm.network :forwarded_port, guest_ip: "0.0.0.0", guest: guest_port, host: host_port, autocorrect: true
  end

  config.ssh.forward_agent = true

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  config.omnibus.chef_version = '12.0.3'

  # Generate a postgres password hash
  # echo -n '<your_password>''postgres' | openssl md5 | sed -e 's/.* /md5/'

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
    chef.add_recipe "apt"

    chef.json = {
      apt: {
        compiletime: true
      }
    }
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "postgresql::ruby"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "postgresql::client"

    # Install Ruby 2.1.2 and Bundler
    # Set an empty root password for MySQL to make things simple
    chef.json = {
      rbenv: {
        user_installs: [{
          user: "vagrant",
          rubies: ["2.2.2"],
          global: "2.2.2",
          local: "2.2.2",
          gems: {
            "2.2.2" => [
              {
                name: "bundler"
              },
              {
                name: "mailcatcher"
              }
            ]
          }
        }]
      },
      postgresql: {
        contrib: {
          extensions: [
            "plpgsql"
          ],
          packages: [
          "postgresql-contrib-9.3"
          ]
        },
        pg_hba: [
          {
            type: 'local',
            db: 'all',
            user: postgresql_username,
            addr: '',
            method: 'trust'
          }
        ],
        password: {
          postgres: "dce2f13b5c9349d9cfe21ca6f8b278fc"
        }
      },
      run_list: ["recipe[postgresql::server]"]
    }
  end

  user_creation_plsql = <<-SCRIPT_SQL
    DO
      \\\\$\\\\$
      BEGIN
        IF NOT EXISTS (
          SELECT * FROM pg_catalog.pg_user WHERE usename = '#{postgresql_username}'
        )
        THEN CREATE USER #{postgresql_username} WITH CREATEDB LOGIN PASSWORD '#{postgresql_password}';
        END IF;
      END
      \\\\$\\\\$
    ;
  SCRIPT_SQL

  setup_postgres_script = <<-SCRIPT
    echo '===== Creating PostgreSQL databases and users'
    su postgres -c "psql -c \\"#{user_creation_plsql}\\""
  SCRIPT

  change_ssh_directory_script = <<-SCRIPT
    if [ $(pwd) != "~/#{project_name}" ]; then
      echo "cd ~/#{project_name}" >> ~/.profile
    fi
  SCRIPT

  bundle_script = <<-SCRIPT
    echo '===== Bundling'
    bundle
    rbenv rehash
  SCRIPT

  config.vm.provision :shell, inline: "chown -R vagrant /home/vagrant/.rbenv"
  config.vm.provision :shell, inline: setup_postgres_script
  config.vm.provision :shell, privileged: false, inline: change_ssh_directory_script
  config.vm.provision :shell, privileged: false, inline: bundle_script

end

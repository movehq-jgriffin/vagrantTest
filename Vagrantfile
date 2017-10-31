VM_NAME = "vtiger_6.4.0"
VM_IP = "192.168.70.10"

MEMORY_SIZE_MB = 4096
# Do not increase number of cpus. For some stupid reason, Vagrant actually
# decreases in performance when it's >1
NUMBER_OF_CPUS = 1
# Set this to wherever your code is! "Default" is C:/moveCRM/Code/moveCRM1.0
REPO_LOCAL = "C:/vtigerTest/vtigercrm/"

Vagrant.configure('2') do |config|
  config.vm.box = "bento/ubuntu-14.04"
	# Prevent TTY Errors
	config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
	# Allow SSH Agent Forward from The Box
	config.ssh.forward_agent = true
	config.ssh.insert_key = false
	config.vm.hostname = "vagrant.dev"
	
	# Network settings
	config.vm.network :private_network, ip: VM_IP
	# config.vm.network "forwarded_port", guest: 80, host: 8000, auto_correct: true
	# config.vm.network "forwarded_port", guest: 443, host: 44300, auto_correct: true
	# config.vm.network "forwarded_port", guest: 3306, host: 33060, auto_correct: true
	# config.vm.network "forwarded_port", guest: 5432, host: 54320, auto_correct: true
	
	config.vm.synced_folder REPO_LOCAL, '/var/www/public/'
	config.vm.provision "file", source: "~/.ssh/", destination: "/home/vagrant/"
	#config.vm.synced_folder '~/Downloads', '/home/vagrant/Downloads'
	#config.vm.synced_folder '~/Desktop', '/home/vagrant/Desktop'

  config.vm.define "vtiger" do |vtiger|
    vtiger.vm.provider "virtualbox" do |v|
      v.name = VM_NAME
			v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", MEMORY_SIZE_MB]
      v.customize ["modifyvm", :id, "--cpus", NUMBER_OF_CPUS]
    end

    vtiger.vm.provision :shell, :path => "vag_provision.sh"
  end
end
    # # Configure A Few Parallels Settings
    # config.vm.provider "parallels" do |v|
    #   v.update_guest_tools = true
    #   v.memory = 2048
    #   v.cpus = 1
    # end

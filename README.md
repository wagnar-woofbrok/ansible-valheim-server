# ansible-valheim-server

Ansible and docker setup for a Valheim game server for coop.

Why Ansible?
* can be run from a laptop or PC
* requires ONLY a private key SSH connection to the game server machine
* only prerequisite is Python3 and ansible installed on both setup and server machines
* automate server setup because tedious manual tasks are boring and a waste of time

## Requirements

1. an Ubuntu VPS/remote server (hereafter called "server") to deploy dockerized game server on. Require private key SSH access to the server; Ansible does not (seem to) support passwords on keys so don't set one; generate the keys on or move the private key to your local machine
2. Local machine running either Bash Linux (debian, ubuntu, etc) or OS X
3. Install these dependencies on local machine: `python3` and `ansible`


## Usage

There are two ways to use this project to setup a Valheim game server:

### 1.a. Ansible only

If you already have a VPS or remote machine setup with SSH access to deploy on, you can use these steps to deploy onto it via Ansible:

1. Copy `.env.example` to `.env` and set the desired values within `.env` for your deploy
2. Make the `ansible-playbook.sh` script executable
```
$ sudo chmod +x ./ansible-playbook.sh
```

3. Run th playbook script on your local machine, which first loads `.env` variables into the environment before running the playbook:
```
$ ./ansible-playbook.sh
```

### 1.b. Ansible + Terraform
#### DigitalOcean Droplet

If you watn to automate both setting up the remote machine to host the game server and deploying the dockerized game server, you can use Terraform + Ansible.

The only provider currently configured it DigitalOcean, which requres configuring the files in `terraform/` as desired and setting the DigitalOcean Personal Access Token (PAT). This setup will also require you to know a little about Terraform and is only for more technical users.

The instructions here are the same, except you run a different playbook using the aptly named script `ansible-terraform-playbook.sh`. The two playbooks are each configured for their respective tasks, so you only need to configure and run the correct script/playbook.


### 2. Connect to your server and start playing

WORK IN PROGRESS - NOT YET READY FOR PRODUCTION USAGE

Lastly, you'll want to connect to your game server in Valheim! Read [lloeche's instructions on finding your game server](https://github.com/lloesche/valheim-server-docker#finding-your-server) to connect and start playing.


## Notes
### Public vs Private Game Servers

One of the `.env` variables is `PUBLIC`, and is a boolean flag (1 or 0, true or false respectively) setting for whether or not your game server appears on the public servers list. The default value in this ansible setup is `0` (private).

### Server Type and Client Matching

The dockerized game server itself is thanks to `lloesche` and the source can be found [here](https://github.com/lloesche/valheim-server-docker). This dockerized setup allows choosing different types of Valheim play, either `Vanilla` or a form of modded server. It is important to note that all types *other than* `Vanilla` require all connecting clients (players) to configure the corresponding modding client on their machines!

### Volumes and Game Server Files

There are three directories on the server machine that are mounted as volumes for the game server's files, including (if you enable it) the backups of the game world itself. These are the directories you'd want to backup or save to be able to reload your world on another machine, and they are:

* /opt/valheim/server
* /opt/valheim/saves
* /opt/valheim/backups


## TODO
* Follow the [instructions for webhooks + events](https://github.com/lloesche/valheim-server-docker#discord-log-filter-event-hook-example) to configure webhooks to notify #cheddar-goblins; for example, when a player spawns in the world
* Use the [lloesche directions](https://github.com/lloesche/valheim-server-docker) to configure BepInEx or ValheimPlus mods on the server
* Firewall! Configure kernel options and UFW rules to lockdown the game server from hacker bois
* Setup 2nd droplet and rsync to automatically backup game files to backup server
* Replace `sudo` and root user with another user; on DigitalOcean this will require adding and configurng a new user in the prerequisites steps; also requires adding user to docker group `usermod -aG docker ${USER}`; this should include replacing the SSH user as a non-root user, since DigitalOcean defaults to always using the root user for everything when a droplet is created
* [Run playbook with Vault to encrypt ENV vars like ssh-key](https://docs.ansible.com/ansible/playbooks_vault.html#running-a-playbook-with-vault)
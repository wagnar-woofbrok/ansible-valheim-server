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

1. Copy `.env.example` to `.env` and set the desired values within `.env` for your deploy
2. Make the `ansible-playbook.sh` script executable
```
$ sudo chmod +x ./ansible-playbook.sh
```

3. Run th playbook script on your local machine, which first loads `.env` variables into the environment before running the playbook:
```
$ ./ansible-playbook.sh
```

This starts the provisioning process and sets the system up, registers the docker-compose services as a SystemD service so it starts on boot after docker, and then begins the process of deploying the game server itself.

If this is the first time (which if you're running Ansible it probably is), then the game world has to be created which can take several minutes or longer. Look for this line in the logs (using `$ docker-compose -f /opt/valheim/docker-compose.yml logs`) to verify the world is ready for players to connect:

```
valheim-valheim-1  | Jul 24 14:16:58 /supervisord: valheim-server DEBUG - [185] - Server is now listening on UDP port 2456
```

Once the server is waiting for players to connect, follow [these detailed instructions from lloesche](https://github.com/lloesche/valheim-server-docker#finding-your-server) to find and connect to your game server in Valheim.


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


# Special Thanks and Contributions

Big thank you to [lloesche](https://github.com/lloesche/valheim-server-docker#event-hooks) for creating a docker-compose Valheim game server with excellent options!


## TODO
* Follow the [instructions for webhooks + events](https://github.com/lloesche/valheim-server-docker#discord-log-filter-event-hook-example) to configure webhooks to notify #cheddar-goblins; for example, when a player spawns in the world
* Use the [lloesche directions](https://github.com/lloesche/valheim-server-docker) to configure BepInEx or ValheimPlus mods on the server
* Firewall! Configure kernel options and UFW rules to lockdown the game server from hacker bois
* Setup 2nd droplet and rsync to automatically backup game files to backup server
* Use [bashly cli generator](https://bashly.dannyb.co/usage/getting-started/) to combine `ansible-playbook.sh` and `terraform/tf.sh` together so one script allows all actions, including: terraform actions, ansible actions
* Review [docs on FluentD + docker-compose](https://docs.fluentd.org/container-deployment/docker-compose) for gathering and using infrastructure logs; ideally, filter logs => Discord webhook notify world events
* Replace `sudo` and root user with another user; on DigitalOcean this will require adding and configurng a new user in the prerequisites steps; also requires adding user to docker group `usermod -aG docker ${USER}`; this should include replacing the SSH user as a non-root user, since DigitalOcean defaults to always using the root user for everything when a droplet is created
* [Run playbook with Vault to encrypt ENV vars like ssh-key](https://docs.ansible.com/ansible/playbooks_vault.html#running-a-playbook-with-vault); also enable use of ssh-agent in script to allow using ssh private keys that are passphrase protected for connections to Ansible nodes; include configuring SSH certificates and CA for better SSH security
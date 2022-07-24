# ansible-valheim-server

Ansible and docker setup for a Valheim game server for coop.

Why Ansible?
* can be run from a laptop or PC
* requires ONLY a private key SSH connection to the game server machine
* only prerequisite is Python3 and ansible installed on both setup and server machines
* automate server setup because tedious manual tasks are boring and a waste of time

## Requirements

1. a VPS/remote server (hereafter called "server") to deploy dockerized game server on
    1.a. private key SSH access to the server; Ansible does not (seem to) support passwords on keys so don't set one; generate the keys on or move the private key to your local machine
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

4. TODO -   directions for connecting to game server from Valheim!


## Notes
### Public vs Private Game Servers

One of the `.env` variables is `PUBLIC`, and is a boolean flag (1 or 0, true or false respectively) setting for whether or not your game server appears on the public servers list. The default value in this ansible setup is `0` (private).

### Server Type and Client Matching

The dockerized game server itself is thanks to `mbround18` and the source can be found [here](https://github.com/mbround18/valheim-docker). This dockerized setup allows choosing different types of Valheim play, either `Vanilla` or a form of modded server. It is important to note that all types *other than* `Vanilla` require all connecting clients (players) to configure the corresponding modding client on their machines!


## TODO
* Use the [mbround18 mods guide](https://github.com/mbround18/valheim-docker/blob/main/docs/tutorials/getting_started_with_mods.md) to configure BepInEx mods on the server
* [Run playbook with Vault to encrypt ENV vars like ssh-key](https://docs.ansible.com/ansible/playbooks_vault.html#running-a-playbook-with-vault)
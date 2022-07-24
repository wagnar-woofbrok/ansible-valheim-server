#!/bin/bash
set -o nounset -o pipefail -o errexit

# Load variables from .env and export them for Ansible
set -o allexport
source "$(dirname "$0")/.env"
set +o allexport

echo $PRIVATE_SSH_KEY_FILE

# Run (env configured) Ansible Playbook
exec ansible-playbook -i inventory.yml playbook.yml
#!/bin/bash
set -o nounset -o pipefail -o errexit

# Load variables from .env and export them for Ansible
set -o allexport
source "$()/.env"
set +o allexport

# Run (env configured) Ansible Playbook
exec ansible-playbook playbook.yml
# Docker Role

This role installs and configures Docker on Rocky Linux 10 hosts using dnf.

## Tasks performed
- Removes old Docker packages
- Installs dnf-plugins-core
- Adds Docker repository
- Installs Docker packages
- Enables and starts Docker and containerd services
- Ensures docker group exists

# GNOME Desktop Role

This Ansible role installs and configures the GNOME desktop environment on Rocky Linux systems, optimized for cloud-based VMs.

## Requirements

- Rocky Linux 8 or 9
- Root or sudo access
- Sufficient disk space (GNOME installation requires ~2-3 GB)

## Role Variables

### Package Installation

- `gnome_groups`: List of GNOME package groups to install (default: `["Server with GUI"]`)
- `gnome_packages`: Additional GNOME packages to install
- `gnome_optional_packages`: Optional productivity packages

### System Configuration

- `gnome_enable_graphical_target`: Enable graphical target (default: `true`)
- `gnome_set_default_target`: Set graphical.target as default (default: `true`)
- `gnome_enable_gdm`: Enable GDM service (default: `true`)

### Display Manager (GDM) Settings

- `gnome_wayland_enable`: Enable Wayland display server (default: `true`)
- `gnome_enable_autologin`: Enable automatic login (default: `false`)
- `gnome_autologin_user`: Username for automatic login (default: `""`)

### User Settings

- `gnome_configure_user_settings`: Configure user-specific GNOME settings (default: `false`)
- `gnome_user`: Username to configure settings for (required if `gnome_configure_user_settings` is true)

### VM Optimizations

- `gnome_vm_optimizations`: Enable VM-specific optimizations (default: `true`)
- `gnome_disable_animations`: Disable animations for better performance (default: `true`)

## Dependencies

None

## Example Playbook

### Basic Installation

```yaml
---
- hosts: workstations
  become: true
  roles:
    - role: gnome
```

### With Custom Configuration

```yaml
---
- hosts: workstations
  become: true
  roles:
    - role: gnome
      vars:
        gnome_wayland_enable: false
        gnome_vm_optimizations: true
        gnome_optional_packages:
          - firefox
          - libreoffice
          - gimp
```

### With Automatic Login (Development/Testing Only)

```yaml
---
- hosts: dev_workstations
  become: true
  roles:
    - role: gnome
      vars:
        gnome_enable_autologin: true
        gnome_autologin_user: developer
```

### With User Settings Configuration

```yaml
---
- hosts: workstations
  become: true
  roles:
    - role: gnome
      vars:
        gnome_configure_user_settings: true
        gnome_user: pnl
        gnome_disable_animations: true
```

## Post-Installation

After running this role:

1. The system will be configured to boot into graphical mode
2. GDM (GNOME Display Manager) will be enabled and started
3. You may need to reboot the system for all changes to take effect:

```bash
ansible-playbook -i inventories/dev/hosts.yml playbooks/reboot.yml -l <target_host>
```

4. Access the GUI:
   - If using a VM: Connect via console (VNC/SPICE)
   - If using SSH: You can use X11 forwarding or VNC

## VM-Specific Notes

For Rocky Linux VMs created from cloud templates:

- The role automatically installs SPICE guest agent and QEMU guest agent for better VM integration
- Kernel parameters are tuned for VM performance
- GNOME animations are disabled by default to improve responsiveness
- Wayland is enabled by default but can be disabled for better compatibility with some VNC clients

## Security Considerations

- **Automatic Login**: Not recommended for production systems. Only use in development/testing environments
- **Remote Access**: Consider setting up VNC or enabling X11 forwarding for remote GUI access
- **Firewall**: If using VNC, ensure proper firewall rules are configured

## Troubleshooting

### System still boots to text mode

Check the default target:
```bash
systemctl get-default
```

Set it manually if needed:
```bash
systemctl set-default graphical.target
systemctl reboot
```

### GDM not starting

Check GDM status:
```bash
systemctl status gdm
journalctl -u gdm
```

### Black screen or display issues in VM

Try disabling Wayland:
```yaml
gnome_wayland_enable: false
```

## Tags

The role supports the following tags:

- `gnome`: All GNOME tasks
- `packages`: Package installation only
- `gdm`: GDM configuration only
- `target`: Graphical target configuration only
- `settings`: User settings configuration only
- `vm-optimization`: VM optimization tasks only

Example:
```bash
ansible-playbook playbook.yml --tags "gnome,packages"
```

## License

MIT

## Author Information

Created for managing Rocky Linux workstation deployments.

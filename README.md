# Ansible Playbook

This collection of Ansible playbooks is designed to automate the setup and configuration of various services and applications. Each playbook is tailored for specific tasks, such as installing software, configuring servers, or managing system settings.

## Directory Structure

```
ansible-playbook/
├── ansible.cfg
├── inventories/
│   ├── dev/
│   │   ├── hosts.yml
│   │   └── group_vars/
│   │       └── all.yml
│   └── sample/
│       └── hosts.yml
├── keys/
│   └── id_*
├── playbooks/
│   ├── setup-baseline.yml
│   ├── reboot.yml
│   └── ...
├── roles/
│   ├── chrony/
│   │   ├── tasks/main.yml
│   │   └── templates/chrony.conf.j2
│   └── ...
└── requirements.yml
```

This structure allows for easy organization and management of playbooks, roles, and inventory files.

## Usage

To run a playbook, use the following command:

Ensure you have Ansible installed and configured correctly, and that you have the necessary permissions to execute the playbooks on the target hosts. 

```bash
ansible-playbook -i inventories/dev/hosts.yml playbooks/setup-baseline.yml
```



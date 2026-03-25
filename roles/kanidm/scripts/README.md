# Kanidm User Management Scripts

## add-new-user.py

A Python script to dynamically add users to Kanidm from a YAML configuration file.

### Prerequisites

- Python 3.6+
- PyYAML library: `pip install pyyaml`
- `kanidm` CLI tool installed and configured

### Usage

```bash
# Basic usage
./add-new-user.py /path/to/person.yml

# Specify a different admin user
./add-new-user.py /path/to/person.yml --admin my_admin

# Dry run (print what would be done without executing)
./add-new-user.py /path/to/person.yml --dry-run
```

### Configuration File Format

See `../templates/person.yml` for a complete example. The YAML file should have the following structure:

```yaml
person:
  username: "johndoe"  # Optional: will be derived from email if not specified
  name: "John Doe"     # Display name
  first_name: "John"   # Optional
  last_name: "Doe"     # Optional
  email: "john.doe@example.com"  # Optional
  gid_number: "1001"   # Optional: POSIX GID number
  groups:              # Optional: list of groups to add user to
    - "posixusers"
    - "developers"
  enabled: true        # Optional: default is true
  ssh_public_keys:     # Optional: SSH public keys to add
    id_ed25519:
      - "ssh-ed25519 AAAAC3... user@host"
    id_rsa:
      - "ssh-rsa AAAAB3... user@host"
```

### Examples

#### Example 1: Create a basic user

```yaml
person:
  username: "jdoe"
  name: "Jane Doe"
  email: "jane.doe@example.com"
```

Run: `./add-new-user.py user-config.yml`

#### Example 2: Create a user with POSIX attributes

```yaml
person:
  username: "bob"
  name: "Bob Smith"
  first_name: "Bob"
  last_name: "Smith"
  email: "bob.smith@example.com"
  gid_number: "2001"
  groups:
    - "posixusers"
    - "admins"
```

#### Example 3: Create a user with SSH keys

```yaml
person:
  username: "alice"
  name: "Alice Johnson"
  email: "alice@example.com"
  ssh_public_keys:
    laptop_key:
      - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbc123... alice@laptop"
    desktop_key:
      - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxyz789... alice@desktop"
```

### Features

- **Automatic username derivation**: If no username is specified, it will be derived from the email address
- **Optional fields**: Only the fields you specify will be configured
- **Multiple SSH keys**: Add multiple SSH keys with different names
- **Group membership**: Automatically add users to specified groups
- **Error handling**: Clear error messages if something goes wrong
- **POSIX support**: Configure POSIX attributes for Linux/Unix integration

### Notes

- The script requires authentication as an admin user (default: `idm_admin`)
- Make sure your `kanidm` client is configured and authenticated before running the script
- SSH keys with placeholder text (starting with `<`) will be skipped
- The script will exit with code 0 on success, non-zero on failure

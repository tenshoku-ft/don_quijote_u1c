Debian installation script
===

# Prerequisite

## Debian-based environment

It uses binaries inside chroot environment except for debootstrap.

```
sudo apt-get install debootstrap
```

## Usage

1. `mount` root file system on `/target` or just create empty directory `/target`
2. Run `common.sh` with `sudo` priviledge
3. Wait patiently
4. profit!


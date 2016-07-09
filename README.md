### virt-install scripts to install Debian 8 under KVM/QEMU


Work in progress - use on your own risk!!!

## Setup

WARNING: These scripts has currently many hard-coded assumptions:


* It is expected, that you have Host (L)Ubuntu 16.04 LTS, 64-bit
  with KVM/QEMU and virt-install installed, for example using:
```bash
sudo apt-get install virt-manager qemu-kvm libvirt-bin \
                     ubuntu-vm-builder bridge-utils virt-viewer \
                     virt-install
``` 

> Please Logout/Login to ensure that you are member of new
> `libvirtd` group


* There must exist writable directory `/opt/install/OS/Debian/tmp`
  for Debian netboot files (required by `virt-install`).
  Fetch these mandatory files invoking:

```bash
./mirror_installer.sh
```

* There must exist writable directory `/opt/virtual-images/KVM/`
  (virtual disk images are created there)

* You mast have local web server providing unpacked tree of 
  `debian-8.5.0-amd64-CD-1.iso`
  
* This debian tree must be available on URL http://192.168.122.1/isos/debian8_cd1

When you met all requirements you may create new debian VM issuing command like

```bash
./create-debian.sh debian
```

## Bugs

# APT repository error at the end of installation

Workaround: enter "Continue"

# GRUB install location dialog (should be silent)

Workaround: select `/dev/vda` manually

# We should use mirror of debian tree instead of unpacked ISOs

Installing from unpacked ISO is comfortable but has drawbacks:

* no GPG checking
* APT is later unable to work with it...




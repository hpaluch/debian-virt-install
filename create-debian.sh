
distiso=/opt/install/OS/Debian/debian-8.5.0-amd64-CD-1.iso
distdir=/isos/debian8_cd1

# see mirror_installer.sh
instdir=/opt/install/OS/Debian/tmp/ftp.us.debian.org/debian/dists/stable/main/installer-amd64

[ $# -eq 1 ] || {

	echo "Usage: $0 vm_name"
	exit 1
}
vm="$1"
invalid_chars=`echo "$vm" | tr -d 'a-z' | tr -d 'A-Z' | tr -d '0-9' | tr -d  '-'`
[ -n "$invalid_chars" ] && {
	echo "VM name contains forbidden characters: $invalid_chars"
	echo "Use only: a-z A-Z 0-9 - (must be valid hostname)"
	exit 2
}

# virt-install example inspired by http://honk.sigxcpu.org/con/Preseeding_Debian_virtual_machines_with_virt_install.html
# WARNING: filename must be exaclte preseed.cfg !
set -xe
cd `dirname $0`
virt-install \
              --virt-type kvm \
              --name ${vm} \
              --ram 1024 \
              --disk /opt/virtual-images/KVM/${vm}.raw,size=8,sparse=true,bus=virtio \
              --vnc \
              --location $instdir \
              --initrd-inject=preseed.cfg \
              -x "auto"


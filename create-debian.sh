#!/bin/bash

# to override this value, use:
#    VM_DOMAIN=mydomain.dom ./create-debian.sh vm1
VM_DOMAIN=${VM_DOMAIN:-kvm.dom}
diskbase=${VM_DISKBASE:-/opt/virtual-images/KVM}
# in gigabytes
disksize=${VM_DISKSIZE:-8}
mirror_host=${MIRROR_HOST:-ftp.linux.cz}
mirror_dir=${MIRROR_DIR:-/pub/linux/debian}

booturl=http://$mirror_host$mirror_dir/dists/jessie/main/installer-amd64/

diskfile=$diskbase/${vm}.raw

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
# WARNING: filename must be exactly preseed.cfg !
set -xe
cd `dirname $0`

sed 's/@HOSTNAME@/'"${vm}"'/;
     s/@DOMAIN@/'"${VM_DOMAIN}"'/;
     s/@MIRROR_HOST@/'"$mirror_host"'/;
     s!@MIRROR_DIR@!'"$mirror_dir"'!;' \
   preseed.cfg.in > preseed.cfg

#diff preseed.cfg{.in,}
#exit 2

http_proxy=http://127.0.0.1:3128 virt-install \
              --virt-type kvm \
              --name ${vm} \
              --ram 1024 \
              --disk "$diskfile,size=8,sparse=true,bus=virtio" \
              --vnc \
              --location $booturl \
              --initrd-inject=preseed.cfg \
              -x "auto"

cat <<EOF
# to STOP vm:
virsh destroy ${vm}
# to DELETE vm:
virsh undefine ${vm}
rm -- ${diskfile}
EOF


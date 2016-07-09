


set -ex

cd /opt/install/OS/Debian/tmp

base=http://ftp.us.debian.org/debian/dists/stable/main/installer-amd64/current/images

wget -x -N  $base/MANIFEST
wget -x -N  $base/netboot/debian-installer/amd64/linux
wget -x -N  $base/netboot/debian-installer/amd64/initrd.gz


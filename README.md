### virt-install scripts to install Debian 8 under KVM/QEMU


Work in progress - use on your own risk!!!

## Setup



* It is expected, that you have Host (L)Ubuntu 16.04 LTS, 64-bit
  with KVM/QEMU and virt-install installed, for example using:
```bash
sudo apt-get install virt-manager qemu-kvm libvirt-bin \
                     ubuntu-vm-builder bridge-utils virt-viewer \
                     virt-install
``` 

> Please Logout/Login to ensure that you are member of new
> `libvirtd` group

* Install Squid proxy for faster VM re-creation:
```bash
sudo apt-get install squid
```
* patch /etc/squid/squid.conf as:
```diff
--- /tmp/squid/etc/squid/squid.conf	2016-06-08 15:50:12.000000000 +0200
+++ /etc/squid/squid.conf	2016-07-10 08:38:42.156893967 +0200
@@ -974,6 +974,9 @@
 #acl localnet src fc00::/7       # RFC 4193 local private network range
 #acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
 
+#  access from KVM NAT network
+acl localnet src 192.168.122.0/24
+
 acl SSL_ports port 443
 acl Safe_ports port 80		# http
 acl Safe_ports port 21		# ftp
@@ -1183,7 +1186,7 @@
 # Example rule allowing access from your local networks.
 # Adapt localnet in the ACL section to list your (internal) IP networks
 # from where browsing should be allowed
-#http_access allow localnet
+http_access allow localnet
 http_access allow localhost
 
 # And finally deny all other access to this proxy
@@ -3249,7 +3252,7 @@
 #	this value to maximize the byte hit rate improvement of LFUDA!
 #	See cache_replacement_policy for a discussion of this policy.
 #Default:
-# maximum_object_size 4 MB
+maximum_object_size 32 MB
 
 #  TAG: cache_dir
 #	Format:
@@ -3407,7 +3410,7 @@
 #
 
 # Uncomment and adjust the following to add a disk cache directory.
-#cache_dir ufs /var/spool/squid 100 16 256
+cache_dir ufs /var/spool/squid 2048 16 256
 
 #  TAG: store_dir_select_algorithm
 #	How Squid selects which cache_dir to use when the response
@@ -4816,7 +4819,7 @@
 refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
 refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
 # example lin deb packages
-#refresh_pattern (\.deb|\.udeb)$   129600 100% 129600
+refresh_pattern (\.deb|\.udeb)$   129600 100% 129600
 refresh_pattern .		0	20%	4320
 
 #  TAG: quick_abort_min	(KB)
```
* (Re)start squid
```bash
systemctl restart squid
```





WARNING: These scripts has currently many hard-coded assumptions:

* KVM NAT network is expected to have 192.168.122.1 gateway IP address
  (default) - squid must listen also there...

* There must exist writable directory `/opt/virtual-images/KVM/`
  (virtual disk images are created there) - or set variable
  `VM_DISKBASE`


When you met all requirements you may create new debian VM issuing command like

```bash
./create-debian.sh debian1
```

>  note - the VM has assigned default domain `kvm.dom` - use this command to override

```bash
VM_DOMAIN=mydomain.dom ./create-debian.sh debian1
```



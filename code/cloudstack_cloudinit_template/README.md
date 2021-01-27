# Template creation

http://docs.cloudstack.apache.org/en/4.14.0.0/adminguide/templates/_create_linux.html

This document  show step
## The overview process as follow:

An overview of the procedure is as follow:

1. Upload your Linux ISO. 
   For more information, see “Adding an ISO”.
   http://docs.cloudstack.apache.org/en/4.11.1.0/adminguide/templates/virtual_machines.html#adding-an-iso

2. Create a VM Instance with this ISO.
   For more information, see “Creating VMs”.
   http://docs.cloudstack.apache.org/en/4.11.1.0/adminguide/templates/virtual_machines.html#creating-vms

3. Prepare the Linux VM
   *see detail instructions below*

4. Create a template from the VM.
   For more information, see “Build the template”.
   http://docs.cloudstack.apache.org/en/4.11.1.0/adminguide/templates/_create_linux.html#creating-a-template-from-an-existing-virtual-machine


## Now prepare the Linux VM (step3)
The following steps will prepare a basic Linux installation for templating.

### Install neccessary packages

#### Ubuntu/Debian

```bash
apt update
apt upgrade -y
apt install sudo acpid ntp vim openssh-server
reboot

```

#### CentOS

```bash
ifup eth0
yum update -y
reboot

```

### Password management
First ensure the **root** user account is **enabled** by giving it a **password** and then login as root to continue.

```bash
sudo passwd root

logout

```

### Hostname Management

#### Centos
CentOS configures the hostname by default on boot. 

#### Ubuntu / Debian
This script first checks if the current hostname is localhost, if true, it will get the host-name, domain-name and fixed-ip from the DHCP lease file.

The script also recreates openssh-server keys, which should have been deleted before templating (shown below). Save the following script to /etc/dhcp/dhclient-exit-hooks.d/sethostname.

```bash

hostname localhost
echo "localhost" > /etc/hostname

cat <<EOF >>/etc/dhcp/dhclient-exit-hooks.d/sethostname
#!/bin/sh
# dhclient change hostname script for Ubuntu
oldhostname=$(hostname -s)
if [ $oldhostname = 'localhost' ]
then
    sleep 10 # Wait for configuration to be written to disk
    hostname=$(cat /var/lib/dhcp/dhclient.eth0.leases  |  awk ' /host-name/ { host = $3 }  END { printf host } ' | sed     's/[";]//g' )
    fqdn="$hostname.$(cat /var/lib/dhcp/dhclient.eth0.leases  |  awk ' /domain-name/ { domain = $3 }  END { printf     domain } ' | sed 's/[";]//g')"
    ip=$(cat /var/lib/dhcp/dhclient.eth0.leases  |  awk ' /fixed-address/ { lease = $2 }  END { printf lease } ' | sed     's/[";]//g')
    echo "cloudstack-hostname: Hostname _localhost_ detected. Changing hostname and adding hosts."
    printf " Hostname: $hostname\n FQDN: $fqdn\n IP: $ip"

    # Update /etc/hosts
    awk -v i="$ip" -v f="$fqdn" -v h="$hostname" "/^127/{x=1} !/^127/ && x { x=0; print i,f,h; } { print $0; }" /etc/hosts > /etc/hosts.dhcp.tmp
    mv /etc/hosts /etc/hosts.dhcp.bak
    mv /etc/hosts.dhcp.tmp /etc/hosts

    # Rename Host
    echo $hostname > /etc/hostname
    hostname -b -F /etc/hostname
    echo $hostname > /proc/sys/kernel/hostname

    # Recreate SSH2
    export DEBIAN_FRONTEND=noninteractive
    dpkg-reconfigure openssh-server
fi
### End of Script ###
EOF

chmod 774  /etc/dhcp/dhclient-exit-hooks.d/sethostname
```

### Prepare Cloud-Init
http://docs.cloudstack.apache.org/projects/cloudstack-administration/en/latest/virtual_machines.html#user-data-and-meta-data

#### Ubuntu / Debian

```bash

sudo apt install cloud-init

```

#### CentOS

```bash

yum install cloud-init

```

```bash
cat <<EOF >>/etc/cloud/cloud.cfg.d/99_cloudstack.cfg
datasource:
  CloudStack: {}
  None: {}
datasource_list:
  - CloudStack
EOF
```

For more detail: https://cloudinit.readthedocs.io/en/latest/topics/datasources.html#cloudstack

#### RancherOS
https://rancher.com/docs/os/v1.2/en/boot-process/cloud-init/


### Adding Password Management to Your Templates

http://docs.cloudstack.apache.org/en/latest/adminguide/templates/_password.html#adding-password-management-to-templates

```bash
wget - O /etc/init.d/cloud-set-guest-password https://raw.githubusercontent.com/apache/cloudstack/master/setup/bindir/cloud-set-guest-password.in

chmod +x /etc/init.d/cloud-set-guest-password
```

### Remove the udev persistent device rules
#### CentOS

```bash
rm -f /etc/udev/rules.d/70*
rm -f /var/lib/dhclient/*
```

#### Ubuntu
```bash
rm -f /etc/udev/rules.d/70*
rm -f /var/lib/dhcp/dhclient.*
```

### Cleanup
```bash

cat /dev/null > /var/log/audit/audit.log 2>/dev/null
cat /dev/null > /var/log/wtmp 2>/dev/null
logrotate -f /etc/logrotate.conf 2>/dev/null
rm -f /var/log/*-* /var/log/*.gz 2>/dev/null

history -c
unset HISTFILE

# As root, remove any custom user accounts created during the installation process.
deluser myuser --remove-home

```
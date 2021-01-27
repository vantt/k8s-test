# RKE (Rancher Kubernettes Engine) Introduction
RKE is a cli-tool that run on your laptop/workstation, and help doing the creation/modification a k8s cluster.

# Install RKE

## Linux

```bash

wget -O /usr/loca/bin/rke https://github.com/rancher/rke/releases/download/v1.2.2/rke_linux-amd64
chmod +x /usr/loca/bin/rke

rke --version

```

## MacOS
```bash

# install
brew install rke

rke --version

# upgrade
brew upgrade rke

```


# Prepare the Nodes for the Kubernetes cluster
https://rancher.com/docs/rke/latest/en/os/

- OpenSSH 7.0+ must be installed on each node.
- The SSH user used for node access must be a member of the docker group on the node.
- sshd config /etc/ssh/sshd_config: AllowTcpForwarding yes
- swap disabled
- file sysctl.conf: net.bridge.bridge-nf-call-iptables=1
- Kernal modules required: br_netfilter, ip6_udp_tunnel,ip_set,ip_set_hash_ip,ip_set_hash_net,iptable_filter,iptable_nat,iptable_mangle,iptable_raw,nf_conntrack_netlink,nf_conntrack,nf_conntrack_ipv4,nf_defrag_ipv4,nf_nat,nf_nat_ipv4,nf_nat_masquerade_ipv4,nfnetlink,udp_tunnel,veth,vxlan,x_tables,xt_addrtype,xt_conntrack,xt_comment,xt_mark,xt_multiport,xt_nat,xt_recent,xt_set,xt_statistic,xt_tcpudp


### The SSH user used for node access must be a member of the docker group on the node:

```bash
usermod -aG docker <user_name>

```

sed -n -e '/^net\.bridge\.bridge-nf-call-iptables/!p' -e '$anet.bridge.bridge-nf-call-iptables = 1' -i /etc/sysctl.conf
sed -n -e '/^AllowTcpForwarding/!p' -e '$aAllowTcpForwarding yes' -i /etc/ssh/sshd_config

## Enable Kernel Modules
https://opensource.com/article/18/5/how-load-or-unload-linux-kernel-module

### Test enabled kernel modules

```bash
for module in br_netfilter ip6_udp_tunnel ip_set ip_set_hash_ip ip_set_hash_net iptable_filter iptable_nat iptable_mangle iptable_raw nf_conntrack_netlink nf_conntrack nf_conntrack_ipv4   nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 nfnetlink udp_tunnel veth vxlan x_tables xt_addrtype xt_conntrack xt_comment xt_mark xt_multiport xt_nat xt_recent xt_set  xt_statistic xt_tcpudp;
do
    if ! lsmod | grep -q $module; then
        echo "module $module is not present";
    fi;
done
```     
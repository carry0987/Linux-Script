## K3s

### Install
To install K3s on a Linux machine, you can follow the official installation guide found on the [K3s Documentation](https://docs.k3s.io/)

### Setup
Install K3s using the script provided by Rancher. This will install and configure a lightweight Kubernetes cluster.

```bash
curl -sfL https://get.k3s.io | sh -
```

To specify an alternate version or additional options, you can customize the above command as needed.

### Use K3s Without Sudo
Configuring your system to use `kubectl` commands without `sudo` involves setting up the `KUBECONFIG` environment variable.

1. Change the permissions of the `k3s.yaml` file to allow your user to read it:
```bash
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
```

2. Copy the `.kube` directory to your home directory:
```bash
sudo mv /root/.kube $HOME/.kube # this will write over any previous configuration
```

3. Update the permissions of the `.kube` directory:
```bash
sudo chown -R $USER $HOME/.kube
sudo chgrp -R $USER $HOME/.kube
```

This guide sets up a basic K3s installation and ensures that you can run basic Kubernetes commands without needing `sudo`.

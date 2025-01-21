## K3s

### Install
To install K3s on a Linux machine, you can follow the official installation guide found on the [K3s Documentation](https://docs.k3s.io/)

### Disable swap
In order to effectively proceed with the installation and setup of K3s, it's recommended to disable swap on your Linux machine. Kubernetes does not recommend using swap due to potential issues with resource management. Here are the commands to disable swap:

1. Temporarily disable swap:
```bash
sudo swapoff -a
```

2. To permanently disable swap, edit the `/etc/fstab` file and comment out (add `#` at the beginning) the line that contains the swap partition:
```bash
#/swapfile swap swap defaults 0 0
```
The above is an example line. Adjust it according to your system's configuration. After editing, reboot the system.
You can now continue with the K3s installation.

### Setup
Install K3s using the script provided by Rancher. This will install and configure a lightweight Kubernetes cluster.

```bash
curl -sfL https://get.k3s.io | sh -
```

To specify an alternate version or additional options, you can customize the above command as needed.

### Use K3s Without Sudo
Configuring your system to use `kubectl` commands without `sudo` involves setting up the `KUBECONFIG` environment variable.

1. **Set the `KUBECONFIG` Environment Variable:**

   First, set up the `KUBECONFIG` environment variable in your current shell session to point to your local configuration file:
   ```bash
   export KUBECONFIG=~/.kube/config
   ```

2. **Generate the Local Configuration File:**

   Create the `.kube` directory and generate the configuration file using the following command:
   ```bash
   mkdir -p ~/.kube
   sudo k3s kubectl config view --raw > "$KUBECONFIG"
   chmod 600 "$KUBECONFIG"
   ```
   This ensures that your Kubernetes configuration file is only readable by your user, maintaining security.

3. **Persist Configuration Across Reboots:**

   To ensure the `KUBECONFIG` environment variable is automatically set in every new terminal session, add it to your `~/.profile` or `~/.bashrc` file:
   ```bash
   echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
   source ~/.bashrc
   ```
   If you use a different shell (e.g., zsh), make similar additions in your `~/.zshrc`.

By setting it up this way, you can run `kubectl` without needing `sudo`, while maintaining proper security for your `k3s.yaml` file.

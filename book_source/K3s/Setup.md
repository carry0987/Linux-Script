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

For example, to install K3s without the default `traefik` ingress controller, you can use the following command:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -
```

### Verify Installation
After the installation is complete, you can verify the status of the K3s service using the following command:

```bash
sudo systemctl status k3s
```

If the service is running, you should see an output indicating that the service is active and running.

### Check Pods
You can also check the status of the pods in the `kube-system` namespace to ensure that the core components of K3s are running correctly:

```bash
kubectl get pods -n kube-system
```

### Work with firewall

#### Disable UFW (Uncomplicated Firewall)

For a straightforward setup of K3s, it is common to disable UFW to avoid any issues with network traffic and port access. If you choose this approach, execute the following:

```bash
sudo ufw disable
```

Disabling UFW will allow all network traffic, facilitating K3s without additional configuration.

#### Configure UFW for K3s

If you prefer to keep UFW enabled for added security, you must ensure that K3s can communicate using specific ports. Here are the essential steps and rules to enable:

1. **Allow SSH Traffic:**

    Before enabling UFW, ensure that SSH traffic is allowed to maintain remote access:

    ```bash
    sudo ufw allow OpenSSH
    ```

    This command allows SSH on the default port **`22`**.  
    If your SSH uses a different port, be sure to specify it accordingly (e.g., `sudo ufw allow 2222/tcp` for port **`2222`**).

2. **Enable UFW:**

    After ensuring SSH is allowed, you can safely enable UFW:
    ```bash
    sudo ufw enable
    ```

3. **Allow K3s Default Ports:**

    K3s typically uses several ports for cluster communication and applications. Make sure these ports are open:

    ```bash
    # Allow standard Kubernetes API server port
    sudo ufw allow 6443/tcp #apiserver
    sudo ufw allow from 10.42.0.0/16 to any #pods
    sudo ufw allow from 10.43.0.0/16 to any #services
    ```

    Other ports that may be required include:
    ```bash
    # Required only if using HA with embedded etcd
    sudo ufw allow 2379/tcp  # etcd server client API
    sudo ufw allow 2380/tcp  # etcd server communication

    # Enable kubelet metrics traffic between all nodes
    sudo ufw allow 10250/tcp

    # Flannel VXLAN - required only if using the Flannel VXLAN backend
    sudo ufw allow 8472/udp

    # Required only for Flannel WireGuard backend
    sudo ufw allow 51820/udp  # For Flannel WireGuard with IPv4
    sudo ufw allow 51821/udp  # For Flannel WireGuard with IPv6

    # Required only for embedded distributed registry (Spegel)
    sudo ufw allow 5001/tcp
    ```
    Adjust the rules based on your specific requirements and configurations.

3. **Verify UFW Status:**

    After configuring the rules, verify the status to ensure the correct ports are allowed:
    ```bash
    sudo ufw status
    ```

By selectively allowing these ports, K3s can function while maintaining UFW’s protection for other unnecessary traffic. Always ensure that only the necessary ports and services are exposed to avoid security risks.

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

## How to Remove K3s

### Stop K3s Services
To completely remove K3s from your Linux system, ensure that all related services are stopped and configurations are cleared.

**Stop All K3s Services:**
Before uninstalling, use the `k3s-killall.sh` script to stop any running K3s services and processes.

```bash
sudo /usr/local/bin/k3s-killall.sh
```

### Uninstall K3s

Removing K3s from your Linux system is straightforward. Follow these steps to ensure a clean removal of the lightweight Kubernetes distribution.

1. **Uninstall K3s:**
    The simplest way to remove K3s is by using the uninstall script provided during the installation. This script will remove all K3s components and configurations.

    ```bash
    /usr/local/bin/k3s-uninstall.sh
    ```

2. **Verify Removal:**
    Ensure all K3s services and configurations are removed:

- **Check Services:**
    Confirm no K3s services are running.
    ```bash
    systemctl status k3s
    ```

- **Remove Directories:**
    Check and manually remove any leftover directories related to K3s if necessary, such as:
    ```bash
    sudo rm -rf /etc/rancher/k3s
    ```

3. **Remove CLI Alias:**
    If you used aliases for K3s commands, ensure to remove them from your shell configuration files (e.g., `.bashrc`, `.zshrc`).

4. **Remove Environment Variables:**
    If you set any environment variables, such as `KUBECONFIG`, to point to your K3s configuration, be sure to unset or remove these from your shell configuration files.

By following these steps, you can completely remove K3s from your system, leaving it ready for any new installations or configurations. If you encounter any issues, refer to the [K3s Documentation](https://docs.k3s.io/) for more detailed troubleshooting steps.

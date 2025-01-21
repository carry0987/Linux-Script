## Helm

### Description

Helm is a package manager for Kubernetes. It is a tool that streamlines installing and managing Kubernetes applications. Think of it like apt/yum/homebrew for Kubernetes.

### Installation

1. **Adding Helm GPG Key to Keyrings**
    ```bash
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    ```
    - `curl https://baltocdn.com/helm/signing.asc`: Downloads the Helm signing key using `curl`.
    - `| gpg --dearmor`: Pipes the downloaded key into `gpg` to convert the ASCII key into a binary format.
    - `| sudo tee /usr/share/keyrings/helm.gpg > /dev/null`: Writes the binary key to `/usr/share/keyrings/helm.gpg`, effectively adding the Helm keyring to the system's list of trusted keys. `> /dev/null` sends any output messages to a null device, suppressing them from appearing in the terminal.

2. **Install Transport over HTTPS**
    ```bash
    sudo apt install apt-transport-https --yes
    ```
    - `sudo apt install apt-transport-https --yes`: Ensures that the package `apt-transport-https` is installed, which is required for `apt` to retrieve packages over HTTPS. The `--yes` flag automatically confirms the installation without user interaction.

3. **Adding Helm Repository to Sources List**
    ```bash
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    ```
    - `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main"`: Constructs a new source list entry. The architecture is dynamically set using `$(dpkg --print-architecture)`, and the entry is signed by the previously added Helm GPG key.
    - `| sudo tee /etc/apt/sources.list.d/helm-stable-debian.list`: Writes the new source list entry to `/etc/apt/sources.list.d/helm-stable-debian.list`, making the Helm repository available to `apt`.

4. **Updating Package List**
    ```bash
    sudo apt update
    ```
    - `sudo apt update`: Updates the local package index to include the new Helm repository, ensuring that `apt` is aware of the latest packages available for installation.

5. **Installing Helm**
    ```bash
    sudo apt install helm
    ```
    - `sudo apt install helm`: Installs Helm using `apt`, now that the package index has been updated to include Helm's repository.

These steps collectively configure the system to recognize the Helm package repository and ultimately install Helm using the system's package manager.

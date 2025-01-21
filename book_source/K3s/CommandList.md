## Common K3s Commands

Here's a guide on how to manage your K3s cluster, including starting services, checking the status of nodes and pods, stopping services, and adding nodes. Additionally, we'll cover the usage of `kubectl apply` to manage deployments.

### Start K3s Service

To start the K3s service if it's not already running, use:

```bash
sudo systemctl start k3s
```

### Check K3s Service Status

To check the status of the K3s service, use:

```bash
sudo systemctl status k3s
```

### Check Cluster Status

You can check the status of your nodes, pods, and services using the following `kubectl` commands:

- **View Nodes:**

    This command shows the list and status of all nodes in your cluster.

    ```bash
    kubectl get nodes
    ```

- **View Pods:**

    To list all pods in the default namespace or specify another namespace with `-n <namespace>`:

    ```bash
    kubectl get pods
    ```

- **View Services:**

    Lists all services running in the default namespace, or specify another namespace.

    ```bash
    kubectl get svc
    ```

### Deploy Applications

To deploy an application using a YAML configuration file such as `nginx-deployment.yml`:

**Apply Deployment:**
This command will create or update resources defined in the YAML file, handling the deployment of pods and services.

```bash
kubectl apply -f nginx-deployment.yml
```

- **Note:** `kubectl apply` will ensure that services and pods are restarted and updated automatically as defined in the YAML file.

**Delete Deployment:**
To delete a deployment, use the following command:

```bash
kubectl delete -f nginx-deployment.yml
```

- **Note:** This command will delete the resources defined in the YAML file.

### Check Deployment Status

To check the status of a deployment, use the following command:

```bash
kubectl get deployments
```

This command will show the status of all deployments in the default namespace.

### Check Pod Status

To check the status of pods in a deployment, use:

```bash
kubectl get pods
```

This command will show the status of all pods in the default namespace.

### Check Service Status

To check the status of services in a deployment, use:

```bash
kubectl get svc
```

This command will show the status of all services in the default namespace.

### Scale Deployments

To scale a deployment, use the following command:

```bash
kubectl scale deployment <deployment-name> --replicas=<number-of-replicas>
```

This command will scale the deployment to the specified number of replicas.

### Update Deployments

To update a deployment with a new image or configuration, use:

```bash
kubectl set image deployment/<deployment-name> <container-name>=<new-image>
```

This command will update the deployment with the new image.

### Delete Deployments

To delete a deployment, use the following command:

```bash
kubectl delete deployment <deployment-name>
```

This command will delete the specified deployment.

### Stop K3s Service

To stop the K3s service, if needed:

```bash
sudo systemctl stop k3s
```

### Add a Node to the K3s Cluster

To add a new node to your existing K3s cluster, perform the following:

1. **Get the Token:**

    Retrieve the node token from the server, which is required for joining nodes:

    ```bash
    sudo cat /var/lib/rancher/k3s/server/node-token
    ```

2. **Install K3s on the New Node:**

    Run the K3s installation script with the server's IP address and token to join the cluster:

    ```bash
    curl -sfL https://get.k3s.io | K3S_URL=https://<server-ip>:6443 K3S_TOKEN=<node-token> sh -
    ```

By following these commands and procedures, you can effectively manage your K3s cluster, ensuring smooth deployment and scaling of your applications. For further details on each command, consult the [Kubernetes kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/).

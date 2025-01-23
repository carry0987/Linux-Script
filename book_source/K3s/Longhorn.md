## Longhorn

### Install

To set up Longhorn in your K3s environment using Helm, follow these steps:

First, you should create a namespace for Longhorn:

```bash
kubectl create namespace longhorn-system
```

Next, add the Longhorn Helm repository to your Helm setup and update it:

```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
```

Now, you can install Longhorn in the `longhorn-system` namespace:

```bash
helm install longhorn longhorn/longhorn -n longhorn-system
```

This command will deploy all necessary Longhorn components in your K3s environment.

### Configuration

After installing Longhorn, you can configure it to suit your specific storage needs. Longhorn automatically provides a storage class named `longhorn`, which you can use to create PersistentVolumeClaims (PVCs).

To define a PVC using Longhorn, create a YAML file:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: longhorn-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: longhorn
```

Apply this configuration to create a PVC:

```bash
kubectl apply -f longhorn-pvc.yml
```

### Verify Installation

1. **Check Longhorn Pods:**
   Ensure all Longhorn components are running:

   ```bash
   kubectl get pods -n longhorn-system
   ```

2. **Access the Longhorn UI:**
   To use Longhorn's UI for management, use port forwarding to access it locally:

   ```bash
   kubectl -n longhorn-system port-forward svc/longhorn-frontend 8080:80
   ```

   Then visit `http://localhost:8080` in your web browser.

### Testing Longhorn

To test Longhorn, you can deploy a simple application that uses the PVC:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-longhorn
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test-longhorn
  template:
    metadata:
      labels:
        app: test-longhorn
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: storage
      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: longhorn-pvc
```

Apply this configuration and verify that the application is using Longhorn storage:

```bash
kubectl apply -f test-longhorn.yml
kubectl get pods
```

### Enable Monitoring and Alerting

Longhorn integrates well with Prometheus and Grafana. Consider setting these up for monitoring Longhorn's usage statistics and performance metrics.

With Longhorn installed, you now have a robust and reliable storage solution that's well integrated into your K3s cluster, enhancing your storage capabilities and management. If you require further customization or encounter any issues, the community and Longhorn documentation provide excellent resources.

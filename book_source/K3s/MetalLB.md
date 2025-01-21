## MetalLB

### Install
To set up MetalLB in your K3s environment, follow these steps:

First, create a namespace for MetalLB:

```bash
kubectl create namespace metallb-system
```

Next, use the Helm chart to install MetalLB. Make sure you have added the MetalLB repository to Helm and updated it:

```bash
helm repo add metallb https://metallb.github.io/metallb
helm repo update
```

Now, install MetalLB in the `metallb-system` namespace:

```bash
helm install metallb metallb/metallb --namespace metallb-system
```

This will install all the necessary MetalLB components into your K3s environment.

### Configuration
Once MetalLB is installed, you need to configure an IP address pool from which it can allocate addresses for LoadBalancer services.

Create a configuration file `metallb-config.yaml` with an IP range that matches your network setup:

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  namespace: metallb-system
  name: my-ip-pool
spec:
  addresses:
  - 192.168.32.200-192.168.32.220 # Adjust IP range as per your local setup
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  namespace: metallb-system
  name: my-l2-advertisement
spec:
  ipAddressPools:
  - my-ip-pool
```

Apply the configuration:

```bash
kubectl apply -f metallb-config.yaml
```

### Verify Installation
1. **Check MetalLB Pods:**
   Ensure all MetalLB pods are running:

   ```bash
   kubectl get pods -n metallb-system
   ```

2. **Test LoadBalancer:**
   Deploy a simple service with `LoadBalancer` type to test MetalLB:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: test-loadbalancer
   spec:
     selector:
       app: nginx
     ports:
       - protocol: TCP
         port: 80
         targetPort: 80
     type: LoadBalancer
   ```

   Apply and observe the `EXTERNAL-IP`:

   ```bash
   kubectl apply -f test-loadbalancer.yaml
   kubectl get services
   ```

### Networking Notes
When using MetalLB:
- Ensure the IP address range you specify does not conflict with any other devices on the network.
- If using Layer 2 mode, all nodes in the cluster must be in the same Layer 2 domain (i.e., connected to the same switch/bridging network).

### Enable Logging
For troubleshooting, you can enable logging on MetalLB to see allocation activity:

```bash
kubectl logs <metallb-controller-pod-name> -n metallb-system
kubectl logs <metallb-speaker-pod-name> -n metallb-system
```

Replace `<metallb-controller-pod-name>` and `<metallb-speaker-pod-name>` with the actual pod names using `kubectl get pods`.

Setting up MetalLB in your K3s environment allows you to simulate cloud-like external IP addressing, optimizing your configurations for a multi-server deployment.

## ExternalDNS

### Install ExternalDNS

To integrate ExternalDNS with your K3s cluster using Cloudflare, follow these steps:

1. **Create Kubernetes Secret for Cloudflare API Token:**

    You'll need a Cloudflare API token with the necessary permissions (Zone:Read, DNS:Edit). Replace `YOUR_API_TOKEN` with your Cloudflare API token.

    ```bash
    kubectl create secret generic cloudflare-api-key --from-literal=apiKey=YOUR_API_TOKEN -n kube-system
    ```

2. **Create values.yml for Helm Configuration:**

    Create a `values.yml` file to configure ExternalDNS with Cloudflare as the DNS provider:

    ```yaml
    provider:
        name: cloudflare
    env:
        - name: CF_API_TOKEN
        valueFrom:
            secretKeyRef:
            name: cloudflare-api-key
            key: apiKey
    ```

3. **Add and Install ExternalDNS with Helm:**

    Add the ExternalDNS Helm repository and update it:

    ```bash
    helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
    helm repo update
    ```

    Now, install ExternalDNS in the `kube-system` namespace:

    ```bash
    helm upgrade --install external-dns external-dns/external-dns --namespace kube-system --values values.yml
    ```

### Verify Installation

1. **Check ExternalDNS Pods:**

    Ensure the ExternalDNS pods are running by executing:

    ```bash
    kubectl get pods -n kube-system | grep external-dns
    ```

2. **Configure a Service with DNS Annotations:**

    To test ExternalDNS, deploy a service annotated with the desired hostname. Example for an Nginx service:

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
        name: nginx
    spec:
        selector:
        matchLabels:
            app: nginx
        template:
        metadata:
            labels:
            app: nginx
        spec:
            containers:
            - name: nginx
            image: nginx
            ports:
            - containerPort: 80
    ---
    apiVersion: v1
    kind: Service
    metadata:
        name: nginx
        annotations:
        external-dns.alpha.kubernetes.io/hostname: "your.domain.com"
    spec:
        type: LoadBalancer
        selector:
        app: nginx
        ports:
        - protocol: TCP
        port: 80
        targetPort: 80
    ```

    Apply the configuration and check for the assigned `EXTERNAL-IP`:

    ```bash
    kubectl apply -f nginx-service.yml
    kubectl get services
    ```

### Networking Notes

- **Cloudflare Configuration:**
  Ensure the DNS zone in Cloudflare is correctly set up and the API token has the necessary permissions.
- **IP Address Consideration:**
  If using MetalLB, ensure the `EXTERNAL-IP` assigned by MetalLB to a service does not conflict with other network devices.

### Enable Logging

To troubleshoot any issues with ExternalDNS, enable logging by observing the ExternalDNS pod logs:

```bash
kubectl logs deployment/external-dns -n kube-system
```

This setup allows ExternalDNS to dynamically manage DNS records for services exposed via a LoadBalancer in your K3s environment, aligning with a Cloudflare configuration for easy DNS management.

### Key Considerations and Common Issues

1. **Service Type Matters:**

   - **LoadBalancer**: ExternalDNS typically requires services to have the type `LoadBalancer`. This is because a LoadBalancer assigns an external IP that ExternalDNS can use to update DNS records. In a cloud environment, this usually results in a publicly accessible IP.

   - **NodePort**: If your environment does not support LoadBalancer and you are using `NodePort`, ensure you manually associate the Node's external IP with the DNS name in Cloudflare. This requires that you know the external IPs of the nodes and appropriately handle traffic routing.

2. **IP Address Visibility:**

   - A service of type `LoadBalancer` or `NodePort` needs to expose a public or routable IP for ExternalDNS to work effectively. In environments like MetalLB, ensure the IP range used does not conflict with local network devices.

3. **MetalLB and Internal IP Issues:**

   - When using MetalLB, services configured as `LoadBalancer` can end up with internal IPs (e.g., `192.168.x.x`). While useful for local testing, these are not suitable for global DNS exposure.

   - To expose services externally with MetalLB, consider setting up a NAT or reverse proxy for external access, and then manually adjust DNS entries or use a different cloud provider or infrastructure that provides public IPs natively.

4. **DNS Annotations:**

    - Ensure that services meant to be exposed via ExternalDNS have the correct DNS annotations, such as:

        ```yaml
        metadata:
        annotations:
            external-dns.alpha.kubernetes.io/hostname: "your.domain.com"
        ```

5. **Cloudflare Configuration:**

   - Ensure the Cloudflare API token has the proper permissions and the domain configured in your annotations matches the zones managed in Cloudflare.

### Verification Steps

- **Pod and Service Status:**

    Before assuming ExternalDNS configuration issues, verify that all involved Kubernetes resources, such as Deployments, Services, and the ExternalDNS deployment itself, are running and correctly configured.

    ```bash
    kubectl get pods -n kube-system | grep external-dns
    kubectl get services
    ```

- **Logs and Debugging:**

    Check logs for ExternalDNS for insight into any DNS updates or errors:

    ```bash
    kubectl logs deployment/external-dns -n kube-system
    ```

- **Cloudflare Dashboard:**

  Confirm that DNS records are updated in Cloudflare by checking the domain's DNS settings. Ensure the ExternalDNS service has updated these records corresponding to the correct IP addresses exposed by your services.

Setting ExternalDNS correctly, especially with the combination of MetalLB and internal K3s environments, demands careful handling of network configurations and service types. For production-grade setups, ensure robust IP management and DNS adjustments that reflect real-world accessibility needs.

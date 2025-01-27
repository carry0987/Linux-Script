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
          - image: nginx
            name: nginx
            ports:
            - containerPort: 80
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx
      annotations:
        external-dns.alpha.kubernetes.io/hostname: example.com
        external-dns.alpha.kubernetes.io/ttl: "120" #optional
        external-dns.alpha.kubernetes.io/target: "YOUR_PUBLIC_IP" #optional
        external-dns.alpha.kubernetes.io/cloudflare-proxied: "true" #optional
    spec:
      selector:
        app: nginx
      type: LoadBalancer
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

### BGP vs. NAT: Best Practices in Different Network Scenarios

In on-prem or private data center environments, if you want services within a K8s cluster to have "true" public IPs, there are generally two approaches:

1. **NAT / Forwarding (Single IP / Few IPs)**
    - **Applicable Scenarios**: You have one or a few public IPs, the ISP has not provided you with an announcable IP block, or the equipment (such as FortiGate) has not enabled BGP.
    - **Approach**: Use DNAT / Port Forwarding on the firewall or router (e.g., FortiGate) to forward external 80/443 traffic to the cluster's MetalLB IP or NodePort.
    - **ExternalDNS Configuration**: You need to manually point the annotation to the public IP (external firewall IP). Otherwise, ExternalDNS might automatically read a private IP.
    - **Pros and Cons**:
        - Pros: Simple deployment, no need for ISP cooperation, or BGP environment.
        - Cons: If multiple services share the same IP, multiple Port Forwards are needed on FortiGate or use the same IP protocol to achieve multiple virtual hosts.

2. **BGP Exchange (Multiple / Announcable IP Block)**
    - **Applicable Scenarios**: You have multiple public IPs (e.g., /29, /28 blocks) and can perform BGP Peering with the ISP or upstream equipment, with an ASN or route announcement permission.
    - **Approach**: Install MetalLB and enable BGP mode, letting MetalLB be the BGP Speaker to announce the public IP assigned to a service directly to the router or upstream network.
    - **ExternalDNS Configuration**: ExternalDNS can automatically write the public IP assigned by MetalLB into DNS. No manual override needed.
    - **Pros and Cons**:
        - Pros: Each service gets a truly independent public IP without NAT; a cleaner traffic path; scalable expansion.
        - Cons: Requires network equipment to support BGP and ownership of announcable IP blocks; configuration and maintenance are relatively complex.

> **Conclusion**:
> - If you only have one public IP, or cannot use BGP, **NAT** with ExternalDNS manual override or Ingress/Gateway with internal IPs are common practices.
> - If you have sufficient public IP blocks and network equipment/ISP supports BGP, then **BGP** is a more "standard" and efficient approach, avoiding cumbersome manual NAT and DNS overrides.

---

After setting up ExternalDNS correctly, especially when combined with MetalLB in on-prem environments, it's crucial to check external IPs, DNS records, and firewall / route forwarding. Using BGP on ISP or enterprise networks allows each service to obtain a real public IP; otherwise, in a single IP + NAT environment, manual annotations can direct ExternalDNS to the firewall's external IP, with the firewall forwarding the traffic. These adjustments must be tailored to actual network conditions.

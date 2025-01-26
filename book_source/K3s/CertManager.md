## Cert-Manager

### Install Cert-Manager

To install Cert-Manager using Helm in your K3s cluster, follow these steps:

1. **Add the Jetstack Helm Repository:**

    You'll need to add the Jetstack Helm repository to get the Cert-Manager charts.

    ```bash
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```

2. **Create a Namespace for Cert-Manager:**

    It is recommended to install Cert-Manager in its own namespace, `cert-manager`.

    ```bash
    kubectl create namespace cert-manager
    ```

3. **Install Cert-Manager with Helm:**

    Use Helm to install Cert-Manager into the `cert-manager` namespace.

    ```bash
    helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --set crds.enabled=true
    ```

4. **Verify Installation:**

    Ensure that all Cert-Manager pods are up and running:

    ```bash
    kubectl get pods -n cert-manager
    ```

### Verify Installation

To fully verify the Cert-Manager installation, the best approach is to issue a test certificate. This involves creating a self-signed issuer and a certificate resource in a test namespace. Follow these steps:

1. **Create Test Resources:**

   Create a YAML file called `test-resources.yaml` with the following content:

   ```yaml
   apiVersion: v1
   kind: Namespace
   metadata:
     name: cert-manager-test
   ---
   apiVersion: cert-manager.io/v1
   kind: Issuer
   metadata:
     name: test-selfsigned
     namespace: cert-manager-test
   spec:
     selfSigned: {}
   ---
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: selfsigned-cert
     namespace: cert-manager-test
   spec:
     dnsNames:
     - example.com
     secretName: selfsigned-cert-tls
     issuerRef:
       name: test-selfsigned
   ```

2. **Apply the Test Resources:**

   Apply the configuration to create the namespace, issuer, and certificate:

   ```bash
   kubectl apply -f test-resources.yaml
   ```

3. **Check the Certificate Status:**

   After applying, check the status of the newly created certificate. You might need to wait a few seconds for cert-manager to process the certificate request.

   ```bash
   kubectl describe certificate selfsigned-cert -n cert-manager-test
   ```

   You should see something like this in the output:
   
   ```
   Spec:
     Common Name: example.com
     Issuer Ref:
       Name: test-selfsigned
     Secret Name: selfsigned-cert-tls
   Status:
     Conditions:
       Last Transition Time: YYYY-MM-DDTHH:MM:SSZ
       Message: Certificate is up to date and has not expired
       Reason: Ready
       Status: True
       Type: Ready
     Not After: YYYY-MM-DDTHH:MM:SSZ
   Events:
     Type    Reason     Age   From          Message
     ----    ------     ----  ----          -------
     Normal  CertIssued  4s    cert-manager  Certificate issued successfully
   ```

4. **Clean Up the Test Resources:**

   Once you've verified that the certificate is issued successfully, you can clean up the resources:

   ```bash
   kubectl delete -f test-resources.yaml
   ```

If all the above steps complete without any errors, your Cert-Manager installation is functioning properly!

### Create a Certificate Issuer with Let's Encrypt

1. **Set Up an Issuer or ClusterIssuer:**

    You'll need to create an Issuer or ClusterIssuer for your cluster to get certificates. Here's an example configuration for a ClusterIssuer using Let's Encrypt:

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-staging
    spec:
      acme:
        server: https://acme-staging-v02.api.letsencrypt.org/directory
        email: your-email@example.com
        privateKeySecretRef:
          name: letsencrypt-staging
        solvers:
        - http01:
            ingress:
              class: nginx
    ```

    Apply the issuer configuration:

    ```bash
    kubectl apply -f issuer.yml
    ```

2. **Request a Certificate:**

    Deploy a test application with a certificate request to confirm Cert-Manager is functioning correctly. You may create a `Certificate` resource and check if it gets issued.

3. **Debugging and Logs:**

    Utilize logs for troubleshooting issues with Cert-Manager:

    ```bash
    kubectl logs -l app=cert-manager -n cert-manager
    ```

4. **Verify Certificates:**

    Inspect the `Certificate` resources and verify `Secrets` issued:

    ```bash
    kubectl get certificates -A
    kubectl get secrets -A | grep your-certificate-name
    ```

### Create a Certificate Issuer with Cloudflare

This guide will walk you through setting up a **Cloudflare-based issuer** with Cert-Manager on your K3s cluster. It builds upon the same structure shown in the previous example but replaces the issuer configuration with Cloudflare-specific settings. We assume that you have already:

- **Installed Cert-Manager** using Helm.
- Configured your K3s cluster properly.

Below are the steps to create a secret for your Cloudflare API token and a ClusterIssuer that uses DNS-01 validation.

---

#### 1. Create a Cloudflare API Token

1. **Log into Cloudflare**:  
   Go to the [Cloudflare Dashboard](https://dash.cloudflare.com/) and navigate to **My Profile** → **API Tokens**.

2. **Generate a Token**:  
   Create an API token with `DNS:Edit`, `Zone:Read` (or broader) permission for the specific zone you will be validating.

3. **Copy the Token**:  
   After creating the token, copy it somewhere safe (e.g., `abc123xyz...`). You will need it in the next step.

---

#### 2. Create a Kubernetes Secret for the Cloudflare Token

You need to store your Cloudflare API token as a secret in your cluster. If Cert-Manager is installed in the `cert-manager` namespace, you can place the secret there as well:

```bash
kubectl create secret generic cloudflare-api-token-secret \
  --from-literal=api-token='abc123xyz...' \
  -n cert-manager
```

- **Secret Name**: `cloudflare-api-token-secret`  
- **Key**: `api-token`

Alternatively, you can create this secret via a YAML manifest:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token-secret
  namespace: cert-manager
type: Opaque
data:
  # Base64-encoded token string
  api-token: <BASE64_ENCODED_CLOUDFLARE_TOKEN>
```

> **Note**: Make sure your API token is base64-encoded if you choose the YAML approach. For example:
> ```bash
> echo -n "abc123xyz..." | base64
> ```

---

#### 3. Create a ClusterIssuer for Cloudflare

Cert-Manager uses a ClusterIssuer (or Issuer) to obtain certificates. Below is an example **ClusterIssuer** that uses Let’s Encrypt **production** endpoint (you can also switch to the staging endpoint for testing).

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cloudflare-issuer
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: cloudflare-issuer-account-key
    solvers:
      - dns01:
          cloudflare:
            # Reference your secret and the key where the token is stored
            apiTokenSecretRef:
              name: cloudflare-api-token-secret
              key: api-token
```

1. **`server`**: Points to the Let’s Encrypt ACME URL.  
   - Production: `https://acme-v02.api.letsencrypt.org/directory`  
   - Staging: `https://acme-staging-v02.api.letsencrypt.org/directory`

2. **`email`**: The email address associated with your Let’s Encrypt account.

3. **`privateKeySecretRef.name`**: The Secret where Cert-Manager will store your ACME account’s private key. You can name this Secret as you like (e.g., `cloudflare-issuer-account-key`).

4. **`apiTokenSecretRef.name`**: The name of the secret you created in the previous step (`cloudflare-api-token-secret`).

5. **`apiTokenSecretRef.key`**: The key in that secret where the token is stored (default: `api-token`).

Once you’ve created the YAML file (e.g., `cloudflare-issuer.yaml`), apply it:

```bash
kubectl apply -f cloudflare-issuer.yaml
```

---

#### 4. Verify Your Cloudflare Issuer

Check the status of your **ClusterIssuer**:

```bash
kubectl describe clusterissuer cloudflare-issuer
```

Look for `Status: True` or any events indicating whether your issuer is ready. If you see error messages, consult the Cert-Manager controller logs:

```bash
kubectl logs -l app=cert-manager -n cert-manager
```

---

#### 5. Request a Certificate

Once the issuer is ready, you can request a certificate for a specific domain. For example, to get a certificate for `example.adakrei.com`, create a `Certificate` manifest like the following:

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-adakrei-com-cert
  namespace: default
spec:
  secretName: example-adakrei-com-tls
  issuerRef:
    name: cloudflare-issuer
    kind: ClusterIssuer
  dnsNames:
    - example.adakrei.com
```

Apply this file:

```bash
kubectl apply -f certificate.yaml
```

Cert-Manager will perform a DNS-01 challenge using your Cloudflare API token to create a `_acme-challenge.example.adakrei.com` TXT record. After successful validation, a TLS certificate will be issued and stored in the `example-adakrei-com-tls` secret.

Use the following commands to verify:

```bash
kubectl describe certificate example-adakrei-com-cert
kubectl get secret example-adakrei-com-tls
```

You should see the secret containing `tls.crt` and `tls.key` if everything is working properly.

---

#### Summary

1. **Install Cert-Manager** (already completed).  
2. **Create a Secret** for your Cloudflare API token (`cloudflare-api-token-secret`).  
3. **Create a ClusterIssuer** referencing the Cloudflare token (`cloudflare-issuer`).  
4. **Request a Certificate** to confirm correct DNS-01 validation.  
5. **Use the TLS Secret** in your Ingress, Gateway, or HTTPRoute to enable HTTPS.

With these steps, you should have a fully functioning **Cloudflare-based issuer** in your K3s cluster, enabling Cert-Manager to automatically issue and renew certificates via Let’s Encrypt. If you encounter issues, check the Cert-Manager logs and ensure your Cloudflare API token has the necessary DNS edit permissions for the relevant zone.

### Uninstall Cert-Manager

To uninstall Cert-Manager from your K3s cluster, follow these steps:

1. **Delete the Cert-Manager Release:**

    Use Helm to delete the Cert-Manager release:

    ```bash
    helm delete cert-manager -n cert-manager
    ```

2. **Delete the Cert-Manager Namespace:**

    Remove the `cert-manager` namespace:

    ```bash
    kubectl delete namespace cert-manager
    ```

By following these steps, you can install Cert-Manager in your K3s cluster using Helm. Ensure your Kubernetes environment is properly prepared and configured for Cert-Manager to issue and manage certificates.

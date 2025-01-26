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

### Create a Certificate Issuer

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

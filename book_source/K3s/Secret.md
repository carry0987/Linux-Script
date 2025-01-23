kubectl create secret tls cloudflare-tls --cert=cert.pem --key=privkey.pem -n istio-system

kubectl get secrets -n istio-system
## Secrets in K3s

> **Note**: In this guide, if the `-n` (namespace) option is omitted, the default namespace (`default`) will be used automatically.

### Create a Secret

1. **Create a Secret from a Literal Value:**

   Use the `kubectl` command to create a secret directly from the command line with literal values:

   ```bash
   kubectl create secret generic my-secret --from-literal=username=myuser --from-literal=password=mypassword -n my-namespace
   ```

2. **Create a Secret from a File:**

   You can create a secret from files containing sensitive information:

   ```bash
   kubectl create secret generic my-file-secret --from-file=config.json=/path/to/config.json -n my-namespace
   ```

### View a Secret

To view the details of a secret with base64-encoded data:

```bash
kubectl get secret my-secret -n my-namespace -o yaml
```

Decode a specific piece of secret data:

```bash
kubectl get secret my-secret -n my-namespace -o jsonpath="{.data.username}" | base64 --decode
```

### Manage/Update a Secret

Use these methods to update secrets:

1. **Edit the Secret Directly:**

   Be cautious as the data is base64 encoded:

   ```bash
   kubectl edit secret my-secret -n my-namespace
   ```

2. **Recreate/Update a Secret:**

   Delete the old secret and create it again with new data:

   ```bash
   kubectl delete secret my-secret -n my-namespace
   kubectl create secret generic my-secret --from-literal=username=newuser --from-literal=password=newpassword -n my-namespace
   ```

### Delete a Secret

Delete a secret, ensuring the correct namespace is specified:

```bash
kubectl delete secret my-secret -n my-namespace
```

### Verify a Secret

List secrets to confirm existence in the intended namespace:

```bash
kubectl get secrets -n my-namespace
```

### Namespace Considerations

- Always specify `-n` to target the desired namespace, preventing unintended interactions with other resources.
- If necessary, create namespaces prior to secret operations using:

  ```bash
  kubectl create namespace my-namespace
  ```

By understanding these commands, you'll effectively manage your Kubernetes secrets, ensuring sensitive data is securely handled within your cluster environments.

---

## Creating a `cloudflare-tls` Secret

In this example, we will create a secret called `cloudflare-tls` to store TLS certificates and keys. Make sure to specify the namespace using `-n`, or it will default to the `default` namespace if omitted.

### Prerequisites

- Ensure that you have your TLS certificate (`tls.crt`) and private key (`tls.key`) files ready.

### Create the TLS Secret

Use the following command to create a TLS type secret. This secret type is specifically for holding SSL/TLS certificates and keys:

1. **Store TLS Certificate and Key**:

   Use the `kubectl` command to create the secret, specifying the files for the certificate and key:

   ```bash
   kubectl create secret tls cloudflare-tls \
    --cert=path/to/tls.crt \
    --key=path/to/tls.key \
    -n my-namespace
   ```

### Verify the Secret

To confirm that the `cloudflare-tls` secret was created successfully, and to view its basic details:

```bash
kubectl get secret cloudflare-tls -n my-namespace -o yaml
```

This will show the created secret details in YAML format, where the certificate and key are stored in a base64-encoded form.

### Use the `cloudflare-tls` Secret

You can reference this secret in your Kubernetes resources, such as Ingress or a specific application that requires TLS configuration, by using its name and namespace.

### Namespace Considerations

- Always ensure you specify `-n my-namespace` to correctly place the secret in the desired namespace.
- If working with multiple environments, carefully manage secrets across different namespaces to avoid exposure or accidental overwriting.

By following these steps, you can securely manage your TLS secrets within your Kubernetes environment. If you need further clarification or examples, let me know!

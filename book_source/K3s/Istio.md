## Istio
This guide provides step-by-step instructions for installing the Gateway API CRDs and Istio on your Kubernetes cluster, leveraging the built-in support for Gateway API to manage ingress traffic.

## Prerequisites

- Ensure any platform-specific setup is complete.
- Verify the requirements for Pods and Services in your Kubernetes cluster.
- Install the latest Helm client. Note that Helm versions released before the oldest currently-supported Istio release are neither tested nor recommended.

## Gateway API CRD Installation

To install Gateway API CRDs, execute the following command:

```sh
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/latest/download/standard-install.yaml
```

## Istio Installation

Follow these steps to install Istio using Helm charts:

### Configure the Helm Repository

To add and update the Istio Helm repository, use:

```sh
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```

### Install the Istio Base Chart

The Istio base chart contains cluster-wide Custom Resource Definitions (CRDs) that must be installed before deploying the Istio control plane. Install it using:

```sh
helm install istio-base istio/base -n istio-system --set defaultRevision=default --create-namespace
```

Validate the installation:

```sh
helm ls -n istio-system
```

Ensure the `istio-base` status is `deployed`.

### Install the Istio Discovery Chart

Deploy the Istio control plane:

```sh
helm install istiod istio/istiod -n istio-system --wait
```

Verify the installation:

```sh
helm ls -n istio-system
```

Check the status to ensure `istiod` is deployed:

```sh
helm status istiod -n istio-system
```

Check `istiod` service installation:

```sh
kubectl get deployments -n istio-system --output wide
```

### Configuring and Using Gateway API

With Gateway API CRDs installed, define your Gateway and HTTPRoute resources. This will automatically provision gateway deployments and services based on the Gateway configurations.

Refer to the Gateway API documentation for defining:

- **Gateway**: Resource defining how ingress traffic is handled.
- **HTTPRoute**: Specifies routing rules to route traffic based on HTTP properties.

### When Using Gateway API CRDs, You Can Omit:

- **Optional Step: Install an Ingress Gateway**

To install an ingress gateway, create a separate namespace and deploy the chart:

```sh
kubectl create namespace istio-ingress
helm install istio-ingress istio/gateway -n istio-ingress --wait
```

Ensure the namespace does not have an `istio-injection=disabled` label for the gateway to function properly.

## Updates and Advanced Customization

To update Istio configurations or perform advanced customization, refer to the available configuration options using:

```sh
helm show values istio/<chart-name>
```

## Uninstall Istio

To remove Istio from your cluster, follow these steps:

1. Check installed Istio charts:

    ```sh
    helm ls -n istio-system
    ```

2. (Optional) Delete any ingress gateway installations:

    ```sh
    helm delete istio-ingress -n istio-ingress
    kubectl delete namespace istio-ingress
    ```

3. Remove Istio discovery chart:

    ```sh
    helm delete istiod -n istio-system
    ```

4. Remove Istio base chart:

    ```sh
    helm delete istio-base -n istio-system
    ```

5. Delete `istio-system` namespace:

    ```sh
    kubectl delete namespace istio-system
    ```

Ensure you understand the implications of each command before execution in your production environment.

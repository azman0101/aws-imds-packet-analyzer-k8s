aws-imds-packet-analyzer
=========================

A tiny toolset to build and deploy the aws-imds-packet-analyzer as a privileged DaemonSet.

Files
- `daemonset.yaml` - Kubernetes DaemonSet + Namespace manifest (hostNetwork + privileged container).
- `Dockerfile` - Builds an image with BCC and the aws-imds-packet-analyzer Python script.
- `build.sh` - Small helper to build the image locally.

Build & push

1. Edit the image name in `daemonset.yaml` (replace `ghcr.io/azman0101` with your registry URL).
2. Build and tag the image locally:

```bash
./build.sh ghcr.io/azman0101/aws-imds-packet-analyzer:latest
```

3. Push to your registry:

```bash
docker push ghcr.io/azman0101/aws-imds-packet-analyzer:latest
```

Deploy to Kubernetes

```bash
kubectl apply -f daemonset.yaml
```

Notes and caveats
- The container requires privileged access and host mounts (`/proc`, `/sys`, `/lib/modules`, `/usr/src`) to inspect packets and kernel data.
- Building BCC inside the container works but can increase image size. You may prefer to build BCC artifacts outside and copy them into a slimmer runtime image.
- The BCC build depends on kernel headers/versions; runtime compatibility depends on host kernel and libbcc version. If you encounter issues, build the image on a host with the same kernel/headers as your target cluster nodes or mount header files at build time.
- Running this DaemonSet in production requires security review because it runs privileged and accesses host internals.

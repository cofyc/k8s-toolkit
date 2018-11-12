# k8s

## Generate kube config files for all kubelets

```
SERVER=https://...
./hack/gen-node-kubeconfig.sh $SERVER $(kubectl get nodes -ojsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
./hack/copy-and-restart-kubelet.sh
```

## Generate master files

```
SERVER=https://...
./hack/gen-master-files.sh $SERVER
```

## Copy master files to other master

```
./hack/copy-master-files.sh <other-master>
```

## Restart kube-apiserver/kube-controller-manager/kube-scheduler on each master

```
./hack/restart-master-components.sh
```

check:

```
kubectl -n kube-system get pods -l tier=control-plane -o wide
```

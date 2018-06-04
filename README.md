# Prometheus Java Agent as sidecar

This is a simple demonstration of using jmx prometheus java exporter from a sidecar.

With adding this sidecar container to ANY kubernetes pod which runs a java process: all the JMX values will be exported to prometheus using a HTTP metrics endpoint.

  1. The sidecar container checks the available java processes (process namespace sharing is required which is a 1.10 alpha feature. See: https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/)

  2. Tries to attach the agent if not yet attached. (if the JMX metrics web page is not available)

See the `k8s-example.yaml` for an example.

It requires:

 1. Shared `/tmp/` directory (it is used by the Java Attach API)

 2. Running the java process and the sidecar both with the same user (at least for java8)

 3. `shareProcessNamespace: true` (alpha feature)

Note: A [fork](http://github.com/flokkr/jmxpromo) of the jmx_exporter is used to suppert the dynamic agent attachment.

## Try it out

The easiest way to try it out is using [skaffold](https://github.com/GoogleContainerTools/skaffold)

```
skaffold dev
kubectl port-forward jmxpromo-sidecar-demo-65b978c8bb-pqkwb 28942:28942
curl localhost:28942
```



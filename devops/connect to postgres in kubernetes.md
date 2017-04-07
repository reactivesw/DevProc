# Connect to Postgres in Kubernetes

## 1. port-forward command

Here is the [introduction](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/) about port-forward

## 2. connect to postgres

1. Forward port 5452 on the local to port 5432 of postgres pod

```shell
kubectl port-forward {postgres pod name} 5452:5432

```

The output is similar to this:

```shell
Forwarding from 127.0.0.1:5452 -> 5432
Forwarding from [::1]:5452 -> 5432
```

2. connect to postgres use local port

```shell
psql -h localhost -p 5452 -U postgres
```
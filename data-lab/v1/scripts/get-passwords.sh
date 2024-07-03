#!/bin/bash

DASHBOARD_PASS=`kubectl get secret -n kube-system microk8s-dashboard-token -o jsonpath="{.data.token}" | base64 -d`
echo "Kubernetes Dashboard Token: $DASHBOARD_PASS"
echo ""

PGPASS=`kubectl get secret --namespace default pg-release-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d`
echo "Postgres: $PGPASS"
echo ""

MINIO_USER=`kubectl get secret --namespace minio-operator microk8s-user-1 -o jsonpath="{.data.CONSOLE_ACCESS_KEY}" | base64 -d`
MINIO_PASS=`kubectl get secret --namespace minio-operator microk8s-user-1 -o jsonpath="{.data.CONSOLE_SECRET_KEY}" | base64 -d`
echo "Minio User: $MINIO_USER"
echo "Minio Pass: $MINIO_PASS"

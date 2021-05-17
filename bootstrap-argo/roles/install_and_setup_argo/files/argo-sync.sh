#!/bin/bash -x

# Extract argocd secret
oc extract secret/openshift-gitops-cluster -n openshift-gitops --confirm --to /tmp

# Get Argo CD route 
ROUTE=$(oc get route openshift-gitops-server -n openshift-gitops -o jsonpath='{.spec.host}')

# Log into Argo CD 
argocd login ${ROUTE} --username admin --password $(cat /tmp/admin.password) --insecure=true

# Sync Parent app
argocd app sync argo-cd

# Sync children apps
argocd app sync -l  arogcd.argoproj.io/common-label=cluster-config-children-apps

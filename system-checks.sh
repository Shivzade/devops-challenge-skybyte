#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="devops-challenge"
APP_LABEL="app.kubernetes.io/instance=skybyte-app"

echo "==> Locating pod"

POD=$(kubectl get pods -n ${NAMESPACE} \
  -l ${APP_LABEL} \
  -o jsonpath='{.items[0].metadata.name}')

echo "Pod: ${POD}"

echo
echo "==> Checking container UID"

kubectl exec -n ${NAMESPACE} ${POD} -- id

echo
echo "==> Checking listening ports"

kubectl exec -n ${NAMESPACE} ${POD} -- sh -c "netstat -tulpn || ss -tulpn"

echo
echo "==> Checking Linux capabilities"

kubectl exec -n ${NAMESPACE} ${POD} -- sh -c "grep CapEff /proc/1/status"

echo
echo "==> Port-forwarding service"

kubectl port-forward svc/skybyte-app \
  -n ${NAMESPACE} \
  8080:80 >/tmp/port-forward.log 2>&1 &

PF_PID=$!

sleep 5

cleanup() {
  kill ${PF_PID} >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo
echo "==> Validating application endpoint"

RESPONSE=$(curl -s http://localhost:8080/)

echo "${RESPONSE}"

echo "${RESPONSE}" | grep "Hello, Candidate"

echo
echo "==> Validating metrics endpoint"

curl -s http://localhost:8080/metrics | grep http_requests_total

echo
echo "==> Testing pod recovery"

OLD_POD=${POD}

kubectl delete pod ${OLD_POD} -n ${NAMESPACE}

echo
echo "==> Waiting for replacement pod"

kubectl wait \
  --for=condition=ready pod \
  -l ${APP_LABEL} \
  -n ${NAMESPACE} \
  --timeout=30s

NEW_POD=$(kubectl get pods -n ${NAMESPACE} \
  -l ${APP_LABEL} \
  -o jsonpath='{.items[0].metadata.name}')

echo
echo "Old pod: ${OLD_POD}"
echo "New pod: ${NEW_POD}"

if [ "${OLD_POD}" = "${NEW_POD}" ]; then
  echo "ERROR: Pod did not rotate"
  exit 1
fi

echo
echo "==> Rollout recovery successful"

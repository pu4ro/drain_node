#!/bin/bash

# 노드 이름을 스크립트 파라미터로 입력받음
NODE_NAME=$1

# 노드 이름이 입력되지 않았으면 사용 방법 안내 후 종료
if [ -z "$NODE_NAME" ]; then
  echo "Usage: $0 <node-name>"
  exit 1
fi

# (1) 노드를 cordon하여 스케줄링을 막음
echo "[INFO] Cordoning node: $NODE_NAME"
kubectl cordon "$NODE_NAME"

# (2) 노드를 drain하여 Pod 종료
# 단일 노드이므로, 다른 노드로 옮길 수 없고, 결국 Pod가 모두 종료됨
# 필요 시 --force, --ignore-daemonsets 등을 조합하여 사용
echo "[INFO] Draining node: $NODE_NAME"
kubectl drain "$NODE_NAME" \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force \
  --grace-period=30

echo "[INFO] Node drain complete. All Pods have been terminated."
echo "[INFO] Safe to shutdown now."


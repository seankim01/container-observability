#!/bin/bash
#
# 스크립트 시작 전 필수 변수 입력!!
CLIENT_SECRET="lkEtZAPYu3SZGnqKvjO3cmdKJMljJgmM" ## Keycloak client secret 입력
EKS_ENDPOINT="https://59CF6B1F4B9ACD3347EA89C213FE0A5C.gr7.ap-northeast-2.eks.amazonaws.com"  ## EKS Endpoing 입력 (e.g: example.eks.amazonaws.com)
CLIENT_ID="k8s-client"  ## keycloak client id 입력
KEYCLOAK_URL="keycloak.inspire-war.shop" ## keycloak 주소 입력 (e.g: keycloak-example.co.kr)
EKS_AUTHORITY_DATA="LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJRVN0OVRKZG9YL0V3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBME1qUXdOVFV3TWpOYUZ3MHpOVEEwTWpJd05UVTFNak5hTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUM3WVFILzREK05sOFAxSU81aVpldDRzWmIwdk5JUXpwN2hXdis3MVJMWVRZZnNBSjlwalRMYkk5QUoKb3YwMmxQWTBlYlBxaThnVWpGeEZLMzgwNUxoMzlIRW9nQ2xFMXM5Ukc1SXR3U2hxNys1V0VaNTZUOFRVejRkQQpWeU5SMEdvUkR6enNsZXlzQ3d2akxFVFhlVlZwUHErakF1NU5ocjIyemJWV0tCbG00aUVsaEF4TzlmcCtXYVJZCnF1UE5PYnRHREQ5c1J3YThOTUYydFVVYjdraE9STFZiMFhMUkxqdVZpbnlxUjZRVlh1WVpEdm02RWlnL0gwZnoKWCtWcFNQYmw2Q1U2NXBleExldFV1YVlsWGp2L2NqUmdIMlVoekhaWjRMbWJ5Wm45ZEJZbFR4eitLR1NVdjVMUwo0N3lBazdQTEE2eTVseFZibWl2Q3d3ZjJHUmhCQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTVUhNYjZzY0dEVjBJNkgydVdmS2pWOEZkTnJ6QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ1dmWHU3MTZXRQprL1JFeFAyOWhDQ3VSTHk0aUJUT0FRUVdJUHhnM0lnWjB1UmxQZ1JnbExvODU2NmFmM2kvT3pGSmo0VWptRXd2CmppY3pELzEyZjRDdDRNcUw2azF3bWs4WWlCdzFJN2dJNHdwNXI2am5GbXJuUUhLVVFPYW5RdkhEdVBLdmFHa1EKdEVCMlEyUGw1a2Rza29RYW5qVSt6WDNmbGtoNFlMRXZiZitUeXRCNkJyOTFyZVV0QmorOWVBT2lmeEhrVmxvSwp6ajRCR1pGTFF3eEZ4RzBpenVDNm9VeTRXa2ZxNDF3MVQzdmE0WGgxM0dCQkV6aHVyUDYyOVFHcVkwYmF2dEVtCitkcVcyWThkUG9Bb3BkMVRjTVpFTXloaEhaNXBBeHJtSEo0Z0d6bS9ZZ1RUdEdGbnFGU1V1SDA3c010ck92QngKaGtjd0hyWU9zWHRtCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K" ## EKS API 인증 데이터 입력
REALM="k8s-realm"  ## Keycloak Reaml 입력

# 변수 확인 및 검증
if [ -z "$CLIENT_SECRET" ]; then
    echo "CLIENT_SECRET이 설정되어야 합니다."
    exit 1
fi

if [ -z "$EKS_ENDPOINT" ]; then
    echo "EKS_ENDPOINT이 설정되어야 합니다."
    exit 1
fi

if [ -z "$CLIENT_ID" ]; then
    echo "CLIENT_ID가 설정되어야 합니다."
    exit 1
fi

if [ -z "$KEYCLOAK_URL" ]; then
    echo "KEYCLOAK_URL이 설정되어야 합니다."
    exit 1
fi

if [ -z "$EKS_AUTHORITY_DATA" ]; then
    echo "EKS_AUTHORITY_DATA가 설정되어야 합니다."
    exit 1
fi

if [ -z "$REALM" ]; then
    echo "Keycloak Realm이 설정되어야 합니다."
    exit 1
fi

# 스크립트 계속 진행...
echo "모든 필수 변수가 설정되었습니다."

# 사용자 입력 변수 설정
read -p "Enter Keycloak Username: " USERNAME
read -sp "Enter Keycloak Password: " PASSWORD

# 토큰 생성
TOKEN=$(curl -X POST https://${KEYCLOAK_URL}/realms/${REALM}/protocol/openid-connect/token \
        -d grant_type=password \
        -d client_id=${CLIENT_ID} \
        -d username=${USERNAME} \
        -d password="${PASSWORD}" \
        -d scope=openid \
        -d client_secret=${CLIENT_SECRET} | jq -r '.id_token')

# 환경 변수 검증
if [ -z "$TOKEN" ]; then
    echo "TOKEN이 존재하지 않습니다."
    exit 1
fi

# KUBECONFIG 파일 생성
cat <<EOF > kubeconfig.yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${EKS_AUTHORITY_DATA}
    server: https://59CF6B1F4B9ACD3347EA89C213FE0A5C.gr7.ap-northeast-2.eks.amazonaws.com
  name: hcs-blue-eks-cluster
contexts:
- context:
    cluster: hcs-blue-eks-cluster
    user: user
  name: hcs-blue-eks-cluster
current-context: hcs-blue-eks-cluster
kind: Config
preferences: {}
users:
- name: user
  user:
    token: $TOKEN
EOF

echo "KUBECONFIG 파일이 생성되었습니다."
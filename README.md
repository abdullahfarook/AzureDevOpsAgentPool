// VSTS
kubectl create secret generic vsts \
 --from-literal=VSTS_ACCOUNT=yourOrg \
 --from-literal=VSTS_TOKEN=yourPersonalAccessToken \
 --from-literal=VSTS_POOL=NameOfYourPool

// Azure Devops
kubectl create secret generic azdevops \
 --from-literal=AZP_URL=https://dev.azure.com/yourOrg \
 --from-literal=AZP_TOKEN=yourPersonalAccessToken \
 --from-literal=AZP_POOL=NameOfYourPool

docker build -t azdevopsagent:latest .
docker tag azdevopsagent:latest server.azurecr.io/azdevopsagent:latest
docker push server.azurecr.io/azdevopsagent:latest

kubectl create secret docker-registry azcr-secret \
 --docker-server=server.azurecr.io \
 --docker-username=username \
 --docker-password=password

kubectl apply -f AzureDevOpsAgent.yaml

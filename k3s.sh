mkdir cluster && cd cluster


curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=" - write-kubeconfig=$HOME/local-cluster.config - write-kubeconfig-mode=644" sh -

systemctl status k3s

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml



mkdir whoami
cd whoami

kubectl create namespace whoami

touch whoami-deployment.yaml 
echo "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami
spec:
  selector:
    matchLabels:
      app: whoami
  replicas: 1
  template:
    metadata:
      labels:
        app: whoami
    spec:
      containers:
        - name: whoami
          image: traefik/whoami:v1.9.0
          ports:
            - containerPort: 80

" >> whoami-deployment.yaml


touch whoami-service.yaml
echo "
apiVersion: v1
kind: Service
metadata:
  name: whoami
spec:
  type: ClusterIP
  ports:
    - port: 5678
      targetPort: 80
  selector:
    app: whoami

" >> whoami-service.yaml



touch whoami-ingress.yaml
echo "
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: whoami

spec:
  rules:
    - http:
        paths:
          - path: /bar
            pathType: Prefix
            backend:
              service:
                name: whoami
                port:
                  number: 5678
          - path: /foo
            pathType: Prefix
            backend:
              service:
                name: whoami
                port:
                  number: 5678
" >> whoami-ingress.yaml


kubectl apply -f whoami-deployment.yaml
kubectl apply -f whoami-service.yaml
kubectl apply -f whoami-ingress.yaml

kubectl get pods --all-namespaces

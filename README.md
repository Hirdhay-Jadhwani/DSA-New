experiment 2:
docker --version              # Checks if Docker is installed and shows a version
docker login                  # Log in to Docker Hub
docker images                 # Lists all downloaded images
docker ps                     # Shows running containers
docker build -t sample-web-app .  # Builds Docker image from Dockerfile
docker run -p 3000:3000 sample-web-app  # Runs the Docker container
docker kill <container_name>     # Forcefully stops the container
docker stop <container_name>     # Gracefully stops the container
docker pull hello-world          # Downloads a small test image from Docker Hub
docker run hello-world           # Runs the image to confirm Docker is working properly
docker ps -a                     # Shows all containers (even stopped ones)
docker rm <container_id>         # Deletes a stopped container
docker rmi hello-world           # Removes the hello-world image
docker info                      # Shows Docker system info


experiment 3 uploaded:
● docker build -t sample-web-app .
● docker images
● docker run -p 3000:3000 sample-web-app

Experiment 4:
either this:
docker pull nginx
docker run -d --name mynginx -p 8080:80 nginx
docker ps
docker stop mynginx
docker rm mynginx
docker rmi nginx

or This:
Open cmd and paste
docker login
docker tag my-sample-app hirdhay3108/my-sample-app
docker push hirdhay3108/my-sample-app
docker pull hirdhay3108/my-sample-app:latest
docker run -p 3000:3000 hirdhay3108/my-sample-app
If the port doesn't work change the port 

Experiment 5:
Either this:
kubectl init
export KUBECONFIG=$HOME/.kube/config
kubectl get nodes
kubeadm token create --print-join-command
Copy what comes next using ctrl+insert(copy) and shift+insert(paste)
Then again paste kubectl get nodes

or this:
kubectl get nodes: Lists all cluster nodes.
kubectl create deployment nginx --image=nginx: Creates a deployment.
kubectl get deployments: View deployments.
kubectl get pods: View pods running in the cluster.
kubectl expose deployment nginx --type=NodePort --port=80: Expose deployment.
kubectl get svc: Check services and their ports

Then run these 6 commands
kubectl get nodes
kubectl get pods
kubectl get pods -A
kubectl get deployments
kubectl get svc
kubectl get namespace
kubectl version –client
kubectl cluster-info
Kubectl delete deployment nginx
kubectl get nodes
kubectl get pods
kubectl cluster-info
kubectl version
kubectl api-resources
kubectl get secrets
kubectl get events
kubectl get services

Experiment 6:
Run these commands 
kubectl run pod mypod –image=nginx
kubectl get pod mypod -o wide
Incase any error check the name after pod/ and type that one
kubectl logs pod
kubectl describe pod pod
kubectl delete pod pod



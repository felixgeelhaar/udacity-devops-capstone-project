# Udacity Cloud DevOps Nanodegree

The Capstone challenge was to create a CI/CD Pipeline with Jenkins, ECR, EKS
through Cloudformation or Ansible. This Project contains the
Cloudformationscripts for the ECR, EKS the EKS Worker Nodes and the Network.
Additionally there is the Script `aws-auth-cm.yml` which includes the role for
the worker node.

## How to

### What was hard to graps

It was hard time to find out how to connect the self-managed-worker-nodes with
the EKS Cluster. At the end it was a proper naming as stated in the AWS docs and
the `aws-auth-cm.yml` configuration which has to be applied via kubectl to the
master to find the nodes and let them join.

Additionally, I started with tw.micro nodes which failed spinning up proper pods
due to available space and for the rolling update. Therefore I upgraded them to
t2.medium and it was working smoothly.

### Learning Objectives

- Spinning up & Creating Jenkins
- Configuring Jenkins with the needed plugins and batteries (docker+kubectl)
- Pushing Docker images to an private ECR Instance (fast and easy)
- Pull Docker images from the private ECR Instance
- Deploy those images through k8s

### Application

The application is a simple static site running in an nginx container exposing
port 80.

### Deploy the Infrastructure

To begin with the CI/CD Pipeline, you need to have a EC2 Instance with Jenkins,
aws-cli, Docker & kubectl deployed.

The first parts of the infrastructure is the network (Public & Private Subnets,
VPC and the ControlPlane) through
`./create_stack.sh UdacityCapStone-Infrastructure network.yml network-params.json`.

After the network stack is up and running deploy the K8S cluster (EKS) through
`./create_stack.sh UdacityCapStone-K8S k8s-cluster.yml k8s-cluster-params.json`
This may take up to 15mins.

To enable nodes in the cluster, where the pods get deployed through Kubernetes,
run the k8s-workers script through
`./create_stack.sh UdacityCapStone-K8S-Workers k8s-workers.yml k8s-workers-params.json`
The nodes only join, if they get the correct permissions assigned. This has to
be done within the K8S Cluster through a ConfigMap. Run
`kubectl apply -f aws-auth-cm.yaml`. Make sure to have your kubectl already
configured with the EKS
(`aws eks --region region-code update-kubeconfig --name cluster_name`). To make
sure everything was successfull run `kubectl get svc` which should show the
kubernetes services.

Additionally, check `kubectl get nodes` which should show the desired state of
worker nodes.

Another component is missing: The ECR (Container Registry). Run
`./create_stack UdacityCapStone-ECR container-registry.yml container-registry-params.json`
which spins up a container registry.

To have a proper deployment double-check the parameters in environment in the
`Jenkinsfile`

### Rolling update

I've chosen the rolling update within kubernetes, which means it updates the
pods without any downtime. The rolling update updates one pod after another. If
the first pod isn't successful K8s rolls it back and spins up another instance
of the previous pod. Therefore no downtime.

Indicated is the rolling update within the `k8s/deployment.yml`-file through the
deploy strategy type. The CI/CD pipeline (`Jenkinsfile`) performs an rolling
update command to update the image to the latest image created during the build.

### useful links

- [K8S Private ECR configuration](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
- [AWS EKS Cluster](https://docs.aws.amazon.com/de_de/AWSCloudFormation/latest/UserGuide/aws-resource-eks-cluster.html)

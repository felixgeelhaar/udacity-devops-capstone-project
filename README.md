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

### useful links

- [K8S Private ECR configuration](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
- [AWS EKS Cluster](https://docs.aws.amazon.com/de_de/AWSCloudFormation/latest/UserGuide/aws-resource-eks-cluster.html)

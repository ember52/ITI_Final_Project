<h1 align="center" id="title">Jenkins CI/CD NodeJS App Deployment with K8s - ITI Cloud PD - Final Project</h1>

<p id="description">This project aims to showcase a scenario of automating of Kubernetes cluster deployment locally via Minikube, managing Kubernetes namespaces, deploying necessary pods, and configuring Jenkins CI/CD pipeline jobs for building, Dockerizing, and deploying the Node.js application.</p>


<h2 id="demo">📝 Project Tasks</h2>

<h3 id=task1">1. Setup a local Kubernetes Cluster with Minikube, and install requirements using Ansible</h3>

- Create an ansible role based on underlying OS.
- In tasks:
  - Check for dependencies and prerquests
  - Download and install Docker
  - Download and install Minikube
  - Start Minikube with Docker driver
  - Download and install terraform
```
ansible-playbook -i inventory playbook.yml
```
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/6dfa1027-49ea-424e-9e60-0d92171234be)

<h3 id=task2">2. Provision required K8s resources and namespaces "dev" and "tools"</h3>

- Create [Cluster Role, Service account, Cluster Role Binding](terraform/service-account.tf)
- Create Secrets for [MySQL](terraform/MySqlSecret.tf) and [Nexus](terraform/nexus-secret.tf)
- Create Deployment and service for [Jenkins](terraform/Jenkins.tf), [Nexus](terraform/nexus.tf), and [MySQL](terraform/MySql.tf)
- Create Service for [NodeJs-app](terraform/appService.tf)
- Create [Persistent volumes for Jenkins and Nexus](terraform/persistent-volumes.tf)
- Create namespaces ["dev"](terraform/namespaces.tf) and ["tools"](terraform/namespaces.tf)

```
terraform init
```
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/49874c37-4831-4fbe-913d-5375f0b4cf8f)

```
terraform apply
```
(1)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/cad70001-a0b3-4370-a065-c0897709539e)

(2)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/6fd0cf40-f0ae-4493-966b-dc1b3b3d7bfb)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/34d60fd1-a59f-4cfa-90f2-e628c956871f)


## 3- tools namespace will have pod for Jenkins and nexus(installed using Terraform)
#### Jenkins initial configuration:

to get initialAdminPassword
```
kubectl exec -it [jenkins-pod-name] -c jenkins -n tools -- /bin/bash -c "cat /var/jenkins_home/secrets/initialAdminPassword"
```
![Screenshot from 2024-06-21 23-09-42](https://github.com/ember52/ITI_Final_Project/assets/69374852/a89cba58-0130-48d7-aa1b-4675e9ec9fdd)

install required packages
![Screenshot from 2024-06-21 23-10-33](https://github.com/ember52/ITI_Final_Project/assets/69374852/5bbdaa19-8cd8-4741-bfe0-1985a2cc0a11)

create Username and password
![Screenshot from 2024-06-21 23-32-17](https://github.com/ember52/ITI_Final_Project/assets/69374852/56b8555e-2eb6-4cdb-bdf1-38db5fb8c5df)

Install Kubernetes Plugin
* this plugin provides the ability to create and destroy Jenkins slave/agents pods based on workload dynamically.

(1)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/81fcbaac-7880-4e02-8ed6-6c4b7541cf97)
(2)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/0c62751c-de6a-450c-94a5-4e8c9d6bf33b)
(3)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/babd181f-a5e5-473c-8a24-c0243f3bd96d)

#### Nexus initial configuration:

to get initial Password
```
kubectl exec -it [nexus-pod-name] -c nexus -n tools -- /bin/bash -c cat "/nexus-data/admin.password"
```
![Screenshot from 2024-06-22 00-13-35](https://github.com/ember52/ITI_Final_Project/assets/69374852/f2b50799-df32-4edf-9b1a-083fa4844825)


Create a new repository for docker files
![Screenshot from 2024-06-22 00-15-05](https://github.com/ember52/ITI_Final_Project/assets/69374852/d4319ede-0587-4dbd-86b8-881dc7a361c2)
Activate "Docker Bearer Token Realm" in realms, to authenticate the user and issues a bearer token.
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/80ad9925-2505-4b30-992f-30d84a68b674)


## 4- dev namespace will run two pods: one for nodejs application and another for MySQL DB
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/280602b0-659f-4275-aaa1-0f35db4f2b0d)

## 5- Create a Jenkins pipeline job to build a docker image from the nodejs app and push to nexus repository.
(1) configuration
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/444ad771-d698-4ab8-991c-8a238eaf1a84)
(2) configuration con'd
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/b7c1ebd8-ea0d-43ca-8b7b-1b91de1e6d7f)

(3) Build results
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/04ca9c44-2aee-4fd1-b3c9-8183c992484b)

(4) Image on docker-repo in nexus
![Screenshot from 2024-06-22 17-32-23](https://github.com/ember52/ITI_Final_Project/assets/69374852/fa912486-6c6b-4ba4-96b5-be678f7a90da)

## 6- Create another Jenkins pipeline job that run the Docker container on the requested environment from nexus on minikube.
(1) configuration
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/bc04aa0d-2358-4e3b-9bde-75c2a34ea91a)

(2) configuration con'd
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/291de061-256b-401a-8f0c-36d5690ea152)

(3) Build results
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/e5f71989-70d2-48ed-93b8-b4a95360813a)

(4) Deployment and running pod on "dev" namespace
![Screenshot from 2024-06-26 01-17-25](https://github.com/ember52/ITI_Final_Project/assets/69374852/a23b2182-804d-4539-8b73-bc926fb8e76a)

(5) NodeJS app is running
![Screenshot from 2024-06-26 01-17-37](https://github.com/ember52/ITI_Final_Project/assets/69374852/b74c5b8b-2891-4e30-893a-bc13a82de480)



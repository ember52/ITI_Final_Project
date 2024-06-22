# ITI_Final_Project

## 3- tools namespace will have pod for Jenkins and nexus(installed using Terraform)
#### Jenkins initial configuration:

to get initialAdminPassword
```
kubectl exec -it jenkins-8ddb87c58-dq659 -c jenkins -n tools -- bash
```
![Screenshot from 2024-06-21 23-09-42](https://github.com/ember52/ITI_Final_Project/assets/69374852/a89cba58-0130-48d7-aa1b-4675e9ec9fdd)

install required packages
![Screenshot from 2024-06-21 23-10-33](https://github.com/ember52/ITI_Final_Project/assets/69374852/5bbdaa19-8cd8-4741-bfe0-1985a2cc0a11)

create Username and password
![Screenshot from 2024-06-21 23-32-17](https://github.com/ember52/ITI_Final_Project/assets/69374852/56b8555e-2eb6-4cdb-bdf1-38db5fb8c5df)

Install Kubernetes Plugin
* this plugin provides the ability to create and destroy Jenkins slave/agents pods based on workload dynamically
(1)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/81fcbaac-7880-4e02-8ed6-6c4b7541cf97)
(2)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/0c62751c-de6a-450c-94a5-4e8c9d6bf33b)
(3)
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/babd181f-a5e5-473c-8a24-c0243f3bd96d)

#### Nexus initial configuration:

to get initial Password
```
kubectl exec -it nexus-6f69db7798-k6kkn -c nexus -n tools -- bash
```
![Screenshot from 2024-06-22 00-13-35](https://github.com/ember52/ITI_Final_Project/assets/69374852/f2b50799-df32-4edf-9b1a-083fa4844825)
(2)
![Screenshot from 2024-06-22 00-14-13](https://github.com/ember52/ITI_Final_Project/assets/69374852/acfed911-f2b3-4e67-9f84-064a7da46e92)

Create a new repository for docker files
![Screenshot from 2024-06-22 00-15-05](https://github.com/ember52/ITI_Final_Project/assets/69374852/d4319ede-0587-4dbd-86b8-881dc7a361c2)


## 4- dev namespace will run two pods: one for nodejs application and another for MySQL DB
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/280602b0-659f-4275-aaa1-0f35db4f2b0d)

## 5- Create a Jenkins pipeline job to build a docker image from the nodejs app and push to nexus repository.
(1) configuration
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/a22a11c0-0d13-4b1b-aa3d-5d2a19e5fdfa)
(2) configuration con'd
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/51ac4144-2cc0-469b-9c3d-76c94526dfeb)
(3) Build results
![image](https://github.com/ember52/ITI_Final_Project/assets/69374852/0c92e987-d1dd-4238-92dc-c2d271b3f6f9)
(4) Image on docker-repo in nexus
![Screenshot from 2024-06-22 17-32-23](https://github.com/ember52/ITI_Final_Project/assets/69374852/fa912486-6c6b-4ba4-96b5-be678f7a90da)

## 6- Create another Jenkins pipeline job that run the Docker container on the requested environment from nexus on minikube.

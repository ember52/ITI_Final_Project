# Ansible Role for Installing Minikube and Terraform

This Ansible role installs and configures Minikube and Terraform on both Ubuntu and CentOS/RedHat systems. The role includes tasks to install Docker, kubectl, Minikube, and Terraform, and ensures that Minikube is started on the target machine.

## Supported Platforms

- Ubuntu
- CentOS
- RedHat

## Role Variables

This role does not require any specific variables. It detects the operating system and applies the appropriate installation tasks automatically.

## Usage

1. Clone the repository:
    ```bash
    git clone https://github.com/ember52/ITI_Final_Project.git
    cd ITI_Final_Project/ansible
    ```

2. Run the playbook:
    ```bash
    ansible-playbook -i inventory.ini playbook.yml
    ```

## Tasks

### Main Task File

The main task file includes conditional imports based on the detected operating system.

- **Path:** `ansible/roles/minikube/tasks/main.yml`
- **Description:** This file includes tasks specific to Ubuntu and CentOS/RedHat systems based on the detected OS distribution.

### CentOS/RedHat Tasks

#### Docker Installation

- **Path:** `ansible/roles/minikube/tasks/centos/docker.yml`
- **Description:** Installs Docker and its dependencies, adds the current user to the Docker group, and ensures the Docker service is started and enabled.

#### Kubectl Installation

- **Path:** `ansible/roles/minikube/tasks/centos/kubectl.yml`
- **Description:** Downloads and installs the latest stable release of kubectl.

#### Minikube Installation

- **Path:** `ansible/roles/minikube/tasks/centos/minikube.yml`
- **Description:** Installs Minikube and starts the Minikube cluster.

#### Terraform Installation

- **Path:** `ansible/roles/minikube/tasks/centos/terraform.yml`
- **Description:** Installs the HashiCorp GPG key, adds the HashiCorp YUM repository, and installs Terraform.

### Ubuntu Tasks

#### Docker Installation

- **Path:** `ansible/roles/minikube/tasks/ubuntu/docker.yml`
- **Description:** Installs Docker prerequisites, adds Docker’s official GPG key and repository, installs Docker, and ensures the Docker service is started and enabled.

#### Kubectl Installation

- **Path:** `ansible/roles/minikube/tasks/ubuntu/kubectl.yml`
- **Description:** Downloads and installs the latest stable release of kubectl.

#### Minikube Installation

- **Path:** `ansible/roles/minikube/tasks/ubuntu/minikube.yml`
- **Description:** Installs Minikube and starts the Minikube cluster.

#### Terraform Installation

- **Path:** `ansible/roles/minikube/tasks/ubuntu/terraform.yml`
- **Description:** Installs prerequisites, adds the HashiCorp GPG key and APT repository, and installs Terraform.

## License

This project is licensed under the MIT License.

## Author

minasaeedbasta

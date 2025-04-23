# Scalable Web Application Infrastructure on AWS with EKS (Terraform)

## Architecture Overview

This document outlines the Infrastructure as Code (IaC) deployment of a scalable web application infrastructure on Amazon Web Services (AWS) utilizing Elastic Kubernetes Service (EKS) for container orchestration. The infrastructure is provisioned and managed using Terraform.

The architecture comprises the following key components:

1.  **Virtual Private Cloud (VPC):** A logically isolated section of the AWS cloud, providing network isolation and control. It includes:
    * Public Subnets: For internet-facing resources like Load Balancers.
    * Private Subnets: For internal application components (EKS nodes, databases) with controlled outbound internet access via a Network Address Translation (NAT) Gateway.
    * Internet Gateway (IGW): Enables internet access for public subnets.
    * NAT Gateway: Allows instances in private subnets to initiate outbound internet traffic without being directly exposed to the internet.
    * Route Tables: Govern network traffic routing within the VPC.

2.  **Elastic Kubernetes Service (EKS):** A managed Kubernetes service on AWS, providing a resilient and scalable control plane.
    * EKS Cluster: The core Kubernetes control plane.
    * Managed Node Groups: A managed service for provisioning and scaling the worker nodes (EC2 instances) that run containerized applications.

3.  **Application Deployment (Kubernetes Manifests):** The example 3-tier application (React Frontend, Node.js Backend, MongoDB Database) is deployed as Kubernetes resources within the EKS cluster. This includes:
    * Namespaces: For logical isolation of application components.
    * Deployments: To manage the replica sets and rolling updates of application pods.
    * Services: To provide stable network endpoints for accessing application pods (using LoadBalancer for external access).
    * Persistent Volume Claims (PVCs): To provision persistent storage for the MongoDB database.

4.  **CI/CD with ArgoCD (GitOps):** A declarative, GitOps-based continuous delivery tool for Kubernetes. ArgoCD will be deployed within the EKS cluster to manage application deployments based on configurations stored in a Git repository.

5.  **Monitoring with Prometheus and Grafana:** A comprehensive monitoring and observability stack deployed within the EKS cluster.
    * Prometheus Operator: Simplifies the deployment and management of Prometheus and Alertmanager in Kubernetes.
    * Prometheus: A time-series database for collecting and storing metrics.
    * Grafana: A data visualization and dashboarding tool for analyzing metrics collected by Prometheus.
    * ServiceMonitors: Kubernetes custom resources that declaratively define how Prometheus should discover and scrape metrics from application pods and other Kubernetes components.

## Architectural Decisions

The selection of EKS as the orchestration platform was driven by several factors:

* **Managed Kubernetes Service:** EKS offloads the operational burden of managing the Kubernetes control plane (scalability, availability, upgrades), allowing the engineering team to focus on application development and deployment.
* **Integration with AWS Ecosystem:** EKS seamlessly integrates with other AWS services, including VPC, IAM, Load Balancers, and EC2, simplifying the overall architecture and management.
* **Community Adoption and Maturity:** Kubernetes boasts a large and active community, a rich ecosystem of tools, and a mature feature set, providing flexibility and extensibility for complex application requirements.
* **GitOps with ArgoCD:** The requirement for a GitOps-based CI/CD pipeline aligns well with ArgoCD's capabilities for declarative and automated application deployments from Git repositories, enhancing auditability and consistency.

## Steps to Reproduce the Setup

Follow these steps to provision the infrastructure:

1.  **Prerequisites:**
    * AWS Account with appropriate permissions.
    * Terraform (version >= 1.0).
    * `kubectl` configured to interact with the EKS cluster (after initial deployment).
    * Helm (version >= 3.0).
    * Basic understanding of AWS, Kubernetes, Terraform, and Helm.

2.  **Clone the Repository:**
    ```bash
    git clone <https://github.com/sahilkeshri1704/khyaal-assignment.git>
    cd <khyaal-assignment>
    ```

3.  **Configure Terraform Variables:**
    * Review and customize the variables defined in `variables.tf`.
    * Populate the `terraform.tfvars` file with your desired values, including the AWS region (`ap-south-1` for Mumbai), VPC CIDR, subnet CIDRs, EKS cluster name, node group configuration, etc.

4.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

5.  **Plan the Infrastructure:**
    ```bash
    terraform plan
    ```
    Review the plan to understand the resources that will be created.

6.  **Apply the Infrastructure:**
    ```bash
    terraform apply --auto-approve
    ```
    This command will provision the VPC, EKS cluster, and managed node group in your AWS account.

7.  **Configure `kubectl`:**
    Once the EKS cluster is created, you need to configure `kubectl` to interact with it. This typically involves updating your `kubeconfig` file using the AWS CLI:
    ```bash
    aws eks update-kubeconfig --name <mumbai-eks-cluster> --region <ap-south-1>
    ```
    Replace `<your_cluster_name>` and `<your_aws_region>` with your actual values.

8.  **Deploy ArgoCD:**
    Terraform will automatically deploy ArgoCD into the `argocd` namespace of your EKS cluster. You can access the ArgoCD UI using the LoadBalancer IP created for the ArgoCD server service. Retrieve the IP using `kubectl`:
    ```bash
    kubectl get svc argo-cd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
    ```

9.  **Deploy Monitoring Stack:**
    Terraform will also deploy the Prometheus Operator and Grafana into the `monitoring` namespace. Access Grafana using the LoadBalancer IP for the Grafana service:
    ```bash
    kubectl get svc prometheus-operator-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
    ```
    Configure Prometheus data sources in Grafana as needed.

10. **Deploy Application Manifests:**
    The example application Kubernetes manifests are defined in `main.tf`. Apply these manifests using `kubectl`:
    ```bash
    kubectl apply -f main.tf
    ```


## Cost Optimization Strategies

Several strategies have been considered for cost optimization:

* **Managed Node Groups with Auto Scaling:** EKS Managed Node Groups are configured with auto-scaling capabilities, allowing the cluster to dynamically adjust the number of worker nodes based on workload demands. This ensures that you only pay for the compute capacity you actually need.
* **Instance Type Selection:** The default instance type (`t3.medium`) is a cost-effective general-purpose instance. For production workloads, right-sizing instances based on CPU and memory utilization is crucial. Tools like AWS Compute Optimizer can provide recommendations.
* **Consideration for Spot Instances:** While the current configuration uses on-demand instances for simplicity, leveraging EC2 Spot Instances for non-critical workloads within the EKS node groups can significantly reduce compute costs (up to 90% discount). This would involve configuring a separate node pool with Spot Instances and tolerations/node affinity rules in Kubernetes to manage where applications run.
* **Persistent Volume Claim (PVC) Optimization:** Carefully consider the storage requirements and access modes for PVCs. Using cost-effective storage classes like `gp3` and right-sizing the volumes can help manage storage costs.
* **Network Cost Awareness:** Be mindful of inter-AZ data transfer costs. Placing resources within the same Availability Zone whenever possible can help minimize these costs.
* **EKS Add-on Management:** Utilize managed EKS add-ons for components like VPC CNI, CoreDNS, and kube-proxy to benefit from AWS-managed updates and potentially reduce operational overhead.
* **Resource Quotas and Limit Ranges:** Implement resource quotas and limit ranges in Kubernetes namespaces to control resource consumption by different teams and applications, preventing resource sprawl and unexpected cost increases.
* **Scheduled Scaling:** For workloads with predictable usage patterns, consider using Kubernetes Horizontal Pod Autoscaler (HPA) and Cluster Autoscaler in conjunction with scheduled scaling of the node groups to match capacity with demand.

## Deliverables

* **GitHub Repository Link:** `<https://github.com/sahilkeshri1704/khyaal-assignment>`
* **Architecture Diagram:** `architecture.pdf` (Conceptual diagram illustrating the components and their interactions).

This `README.md` provides a comprehensive overview of the deployed infrastructure, the rationale behind the architectural decisions, detailed steps for reproduction, and key considerations for cost optimization.
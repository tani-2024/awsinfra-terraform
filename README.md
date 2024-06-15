# Terraform AWS Infrastructure Setup

This repository contains Terraform configurations to set up infrastructure on AWS. Below are the steps followed to create the infrastructure:

# Prerequisites
1. Terraform installed locally
2. AWS account with appropriate permissions

# Technologies
   - Amazon Web Services
   - Infrastructure as Code
   - Version Control System
   - Virtualization     

## Steps to be followed

1. **Create S3 Bucket for Terraform State**:
   - Manually create an S3 bucket.
   - Create a backend configuration file (`backend.tf`) to store the state files of the infrastructure.

2. **Create VPC**:
   - Use Terraform to create a Virtual Private Cloud (VPC).

3. **Create Subnets**:
   - Create 4 subnets within the VPC, 2 public and 2 private.

4. **Create Internet Gateway (IGW)**:
   - Create an internet gateway and a public route table to route outbound traffic to the IGW.

5. **Associate Route Table**:
   - Associate the public route table with the 2 public subnets.

6. **Create NAT Gateway**:
   - Create an Elastic IP and a NAT gateway.
   - Create a private route table to route outbound traffic to the NAT gateway.

7. **Associate Route Table**:
   - Associate the private route table with the 2 private subnets.

8. **Create Security Group**:
   - Create a security group for EC2 instances and the load balancer.
   - Generate SSH keys for EC2 instances.

9. **Create Application Load Balancer (ALB)**:
   - Create an ALB in the 2 public subnets for high availability and fault tolerance.
   - Set up a listener and a target group for the ALB.

10. **Create Auto Scaling Group**:
    - Instead of creating EC2 instances directly, create them using an auto scaling group.
    - First, create a launch configuration for the auto scaling group.
    - Then, create the auto scaling group and mention the target group for EC2 instances.

11. **Create CloudWatch**:
    - Create a CloudWatch for CPU Utilization metrics.

12. **Create Hosted Zone in Route 53**:
    - Create a hosted zone in Route 53.
    - Inside the hosted zone, create a CNAME type record that will resolve the DNS name of the load balancer to the DNS name of the record.



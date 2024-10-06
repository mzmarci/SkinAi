#!/bin/bash
# Update the package manager
sudo yum update -y

# Install Java (Jenkins requires Java)
sudo yum install -y java-11-openjdk

# Add Jenkins repository and key
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Install Jenkins
sudo yum install -y jenkins

# Start Jenkins service and enable it to start at boot
sudo systemctl start jenkins
sudo systemctl enable jenkins


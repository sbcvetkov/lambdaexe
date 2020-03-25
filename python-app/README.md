# Python App

## Overview

This Python application obtains parameters from `SSM Parameter Store` and then connects to an RDS instance and gets general RDS data.

Example:
```[lambdauser@archlinux python-app]$ python lambdaexe.py 
PostgreSQL 9.6.9 on x86_64-pc-linux-gnu, compiled by gcc (GCC) 4.8.3 20140911 (Red Hat 4.8.3-9), 64-bit
```

An important prerequisite is to have a valid credential configuration.

### CodePipeline

CodePipeline creates a Docker image and pushes it to ECR. The Docker image essentially wraps up the Python app along with its requirements.

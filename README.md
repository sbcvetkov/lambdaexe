# lambdaexe-python-rds

### Prerequisites
Make sure you have your `/.aws/credentials` in place, which is mandatory for running the project. This is important for the Python app, as well, since it relies on `boto` to connect to SSM.

### How to run 
In order to make complete use of the project one should:
1. Apply the terraform code
2. Clone the CodeCommit repo (you can get the URL from the output of the terraform execution) and put the necessary code there (namely web-app and python-app) 
3. Observe the results

### Overview

This project makes use of [this repo](https://github.com/slalompdx/terraform-aws-codecommit-cicd/tree/master) with a lot of customisation, so as to align its usage to the objectives of the task.




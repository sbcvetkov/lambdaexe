# Terraform 

## Overview

The teraform section of the project consists of a main directory (`lambdaexe_infra`) and two modules (`cicd-module` and `networking-module`). 

### Modules

The `cicd-module` takes care of the S3 bucket creation, as well as the CodeCommit, CodePipeline, CodeBuild and their relevant security settings. 

The `networking-module` creates the networking resources needed to run the project. 

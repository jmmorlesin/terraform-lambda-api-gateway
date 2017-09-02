# Lambda function with API Gateway endpoint using Terraform #

This project shows a proof of concept of a serverless API based on a lambda function connected to API Gateway in order to create a public endpoint using Terraform.

Requirements
------------

- Ant to build the zip file with the Node.js lambda function (You can zip as well manually the content of the src folder into the poc.zip file in the root path)      
- Terraform to build the infrastructure as code (See more in [https://www.terraform.io/](https://www.terraform.io/))    
- An AWS account with an user with enough privileges to read/write in a S3 bucket and to create roles, lambda functions and API Gateway endpoints.      
- A bucket in S3 with versioning enabled to store the terraform state file (This can prevent a lot of problems. More information at [https://www.terraform.io/docs/backends/types/s3.html](https://www.terraform.io/docs/backends/types/s3.html))  

Before you start
----------------

The terraform script needs the file *./terraform/develop/sensitive.tf*. You can find an example of that file in *./terraform/develop/sensitive.tf.template*

This is the content of the file
```
variable "aws_account" { default = "xxxxxxxxxxxx" }
variable "aws_profile" { default = "xxxxxxxxxxxx" }
variable "aws_region" { default = "xxxxxxxxxxxx" }
 
```

| Name          | Description                                                                                                                  |
|---------------|------------------------------------------------------------------------------------------------------------------------------|
| aws_account   | Id of the AWS account                                                                                                        |
| aws_profile   | The profile that you want to use to deploy the infrastructure. Has to be defined in the AWS CLI (usually ~/.aws/credentials) |
| aws_region    | AWS Region where we will deploy the lambda function and API Gateway                                                          |


Apart from that, you will need to create a bucket in S3 with versioning enabled to store the terraform state file. After creating your bucket, you can put the name in the *./terraform/develop/main.tf*  

```
terraform { // Cannot be injected from variables
  backend "s3" {
    bucket = "proof-of-concept-jmms"
    key    = "terraform-lamda-api/develop/terraform.tfstate"
    region = "eu-west-1"
  }
}

```
It is not possible for now to use interpolations to add the values as a variables. More information at [https://www.terraform.io/docs/configuration/terraform.html#description](https://www.terraform.io/docs/configuration/terraform.html#description)  

Structure of the project
------------------------

| Name                                        | Description                                                        |
|---------------------------------------------|--------------------------------------------------------------------|
| **src**/index.js                            | Lambda function in Node.js that returns a JSON                     |
| **terraform**/                              | Terraform scripts                                                  |
| **terraform/develop**/main.tf               | Main terraform script                                              |
| **terraform/develop**/output.tf             | Output configuration for the main script                           |
| **terraform/develop**/sensitive.tf.template | Template for the sensitive.tf file with sensitive information      |
| **terraform/develop**/variables.tf          | Variables for the terraform script                                 |
| **terraform/modules/api**/                  | API Module                                                         |
| **terraform/modules/api**/main.tf           | Script to generate the API Gateway endpoint                        |
| **terraform/modules/api**/variables.tf      | Variables for the script                                           |
| **terraform/modules/lambda**/               | Lambda function Module                                             |
| **terraform/modules/lambda**/main.tf        | Script to generate the lambda function                             |
| **terraform/modules/lambda**/variables.tf   | Variables for the script                                           |
| **terraform/modules/roles**/                | Roles Module                                                       |
| **terraform/modules/roles**/main.tf         | Script to generate a basic execution role for the lambda function  |
| **terraform/modules/roles**/variables.tf    | Variables for the script                                           |
| build.xml                                   | Ant script to build the zip file                                   |

Running the scripts
-------------------

Ant script to generate a zip file with the lambda function.
```
./ant
```
Run the command to initialize the terraform state
```
./terraform/develop/terraform init
```
Run the command to validate the infrastructures that will be created
```
./terraform/develop/terraform plan
```
Run the command to create all the infrastructure
```
./terraform/develop/terraform apply
```
After that, all the resources have been created. If you go to the API Gateway section inside your AWS account, you can see the *myAPI* created in the list. If you go to stages and choose the *develop* stage, then you can see the public URL to invoke the endpoint. In my case was [https://cg43vketce.execute-api.eu-west-1.amazonaws.com/develop/myApi](https://cg43vketce.execute-api.eu-west-1.amazonaws.com/develop/myApi) and when you hit the link, you can see the JSON from the lambda function
```
  {
    application: {
      name: "Terraform - Proof of concept",
      version: "1.0.0",
      build: "1",
      time: 1504341932121
  }
}
```

Considerations 
--------------
- S3 bucket to store the Terraform state file with versioning enabled to be sure we are able to rollback to a previous versions    
- The connection between Terraform and AWS uses an AWS profile, there are more options to establish this connection. More details in [https://www.terraform.io/docs/providers/aws/index.html](https://www.terraform.io/docs/providers/aws/index.html)  
- The lambda function is using Node.js just to keep the proof of concept easier. 
- The lambda function always will be returning the same JSON with a different timestamp. 
- Creation of modules for the Terraform scripts in order to create reusable code and to keep clean the main terraform script


License
-------

May be freely distributed under the [MIT license](https://github.com/jmmorlesin/node-api/blob/master/LICENSE).

Copyright (c) 2017 Jose M. Morlesín 
variable "zip_application" { default = "../../poc.zip" }

variable "lambda_exec_role_name" { default = "pocDefaultLambdaExecRole"}

variable "lambda_function_name" { default = "pocLambda"}
variable "lambda_function_handler" { default = "index.handler"}
variable "lambda_runtime" { default = "nodejs6.10" }

variable "api_name" { default = "myApi" }
variable "api_stage_name" { default = "develop" }
variable "api_url" { default = "myApi" }
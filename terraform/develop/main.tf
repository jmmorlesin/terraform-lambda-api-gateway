provider "aws" {
    region = "${var.aws_region}"
    profile = "${var.aws_profile}"
}

terraform { // Cannot be injected from variables
  backend "s3" {
    bucket = "proof-of-concept-jmms"
    key    = "terraform-lamda-api/develop/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "roles" {
  source = "../modules/roles"

  lambda_exec_role_name = "${var.lambda_exec_role_name}"
}

module "lambdaFunction" {
  source = "../modules/lambda"

  lambda_function_name = "${var.lambda_function_name}"
  lambda_function_handler = "${var.lambda_function_handler}"
  lambda-exec-role_arn = "${module.roles.default_lambda_exec_role_arn}"
  lambda_runtime = "${var.lambda_runtime}"
  zip_application = "${var.zip_application}"
}

module "apiGateway" {
  source = "../modules/api"

  api_name = "${var.api_name}"
  api_stage_name = "${var.api_stage_name}"
  aws_account = "${var.aws_account}"
  aws_region = "${var.aws_region}"
  default-lambda-exec-role = "${module.roles.default_lambda_exec_role_arn}"
  my_lambda_function_arn = "${module.lambdaFunction.generic_lambda_function_arn}"
  api_url = "${var.api_url}"
}

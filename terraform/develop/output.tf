output "default_lambda_exec_role_arn" {
  value = "${module.roles.default_lambda_exec_role_arn}"
}

output "generic_lambda_function_arn" {
  value = "${module.lambdaFunction.generic_lambda_function_arn}"
}

output "my_API_id" {
  value = "${module.apiGateway.my_API_id}"
}
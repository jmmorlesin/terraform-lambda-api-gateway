resource "aws_lambda_function" "genericLambdaFunction" {
  function_name = "${var.lambda_function_name}"
  handler = "${var.lambda_function_handler}"
  runtime = "${var.lambda_runtime}"
  filename = "${var.zip_application}"
  source_code_hash = "${base64sha256(file(var.zip_application))}"
  role = "${var.lambda-exec-role_arn}"
}

output "generic_lambda_function_arn" {
  value = "${aws_lambda_function.genericLambdaFunction.arn}"
}
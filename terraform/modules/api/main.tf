resource "aws_api_gateway_rest_api" "myAPI" {
  name        = "${var.api_name}"
  description = "This is the My API Gateway"
}

resource "aws_api_gateway_resource" "myResource" {
  rest_api_id = "${aws_api_gateway_rest_api.myAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.myAPI.root_resource_id}"
  path_part   = "${var.api_url}"
}

resource "aws_api_gateway_method" "myMethod" {
  rest_api_id   = "${aws_api_gateway_rest_api.myAPI.id}"
  resource_id   = "${aws_api_gateway_resource.myResource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "myIntegration" {
  rest_api_id = "${aws_api_gateway_rest_api.myAPI.id}"
  resource_id = "${aws_api_gateway_resource.myResource.id}"
  http_method = "${aws_api_gateway_method.myMethod.http_method}"
  integration_http_method = "POST"
  type        = "AWS"
  uri         = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.my_lambda_function_arn}/invocations"
}

resource "aws_api_gateway_method_response" "myMethod200" {
  rest_api_id = "${aws_api_gateway_rest_api.myAPI.id}"
  resource_id = "${aws_api_gateway_resource.myResource.id}"
  http_method = "${aws_api_gateway_method.myMethod.http_method}"
  status_code = "200"
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "true" }
}

resource "aws_api_gateway_integration_response" "myMethodIntegration200" {
  depends_on = ["aws_api_gateway_integration.myIntegration"]

  rest_api_id = "${aws_api_gateway_rest_api.myAPI.id}"
  resource_id = "${aws_api_gateway_resource.myResource.id}"
  http_method = "${aws_api_gateway_method.myMethod.http_method}"
  status_code = "${aws_api_gateway_method_response.myMethod200.status_code}"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.my_lambda_function_arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account}:${aws_api_gateway_rest_api.myAPI.id}/*/*"
}

resource "aws_api_gateway_deployment" "myAPIDeployment" {
  depends_on = ["aws_api_gateway_method.myMethod", "aws_api_gateway_integration.myIntegration"]

  rest_api_id = "${aws_api_gateway_rest_api.myAPI.id}"
  stage_name = "${var.api_stage_name}"
}

output "my_API_id" {
  value = "${aws_api_gateway_rest_api.myAPI.id}"
}
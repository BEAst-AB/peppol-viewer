aws lambda delete-function --function-name LambdaTickstarGalaxyGatewayTransactionHandler

aws lambda create-function --function-name LambdaTickstarGalaxyGatewayTransactionHandler --runtime java21  --handler beast.dpp.lambda.handler.GatewayTransactionHandler --role arn:aws:iam::635144719722:role/lambda-apigateway-role --zip-file fileb://aws-lambda-TickstarGalaxyGatewayTransactionHandler.zip

aws lambda update-function-code --function-name LambdaTickstarGalaxyGatewayTransactionHandler --zip-file fileb://aws-lambda-TickstarGalaxyGatewayTransactionHandler-1.0-SNAPSHOT.zip

aws lambda invoke --function-name LambdaTickstarGalaxyGatewayTransactionHandler --payload file://test/Tickstar_GalaxyGateway_InboundTransaction.json  test\Tickstar_GalaxyGateway_InboundTransaction_output.json --cli-binary-format raw-in-base64-out
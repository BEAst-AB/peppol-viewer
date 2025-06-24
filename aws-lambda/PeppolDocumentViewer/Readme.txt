aws lambda delete-function --function-name LambdaPeppolDocumentViewer

aws lambda create-function --function-name LambdaPeppolDocumentViewer --runtime java21  --handler beast.peppol.viewer.lambda.handler.PeppolDocumentViewer --role arn:aws:iam::635144719722:role/lambda-apigateway-role --zip-file fileb://deploy/aws-lambda-PeppolDocumentViewer-1.0-SNAPSHOT.zip

aws lambda update-function-code --function-name LambdaPeppolDocumentViewer --zip-file fileb://deploy/aws-lambda-PeppolDocumentViewer-1.0-SNAPSHOT.zip

aws lambda invoke --function-name LambdaPeppolDocumentViewer --payload file://test/LambdaPeppolDocumentViewerRequest.json  test\LambdaPeppolDocumentViewerResponse.json --cli-binary-format raw-in-base64-out
## s3-pre-signed-url-get-and-publish-to-sns-topic-lambda-function.md

```json
{
  "Records": [
    {
      "eventVersion": "2.1",
      "eventSource": "aws:s3",
      "awsRegion": "ap-southeast-1",
      "eventTime": "2022-07-31T06:54:20.293Z",
      "eventName": "ObjectCreated:Put",
      "userIdentity": { "principalId": "A3H9EVE2DDNAB9" },
      "requestParameters": { "sourceIPAddress": "49.204.113.169" },
      "responseElements": {
        "x-amz-request-id": "19M5DNJ0952B8HJY",
        "x-amz-id-2": "b93R+PNOtzjViMz5mxq8W1ejFIKcjjRmlBDpvRfHhzxE6NJJm1jOV36cJUkI7fcLNARrPiSsofkQ7xHIR2Q4hSGb6JO9IcBH"
      },
      "s3": {
        "s3SchemaVersion": "1.0",
        "configurationId": "pre-sign-url",
        "bucket": {
          "name": "pre-signed-url-local",
          "ownerIdentity": { "principalId": "A3H9EVE2DDNAB9" },
          "arn": "arn:aws:s3:::pre-signed-url-local"
        },
        "object": {
          "key": "job-one.py",
          "size": 205,
          "eTag": "b5cfdce177d589dd39243adf1cec46e7",
          "sequencer": "0062E6271C43DE0B18"
        }
      }
    }
  ]
}
```

```py
import json
import boto3
from botocore.exceptions import ClientError
import logging


def lambda_handler(event, context):
    s3 = event['Records'][0]['s3']
    bucketDetails = s3['bucket']
    specificBucketObjectDetails = s3['object']
    bucketName = bucketDetails['name']
    uploadFileName = specificBucketObjectDetails['key']
    sourceS3ScriptLocationURL = f's3://{bucketName}/{uploadFileName}'
    splitFileLocation = uploadFileName.split("/")
    originCount = splitFileLocation.__len__() - 1
    exactObjectName = splitFileLocation[originCount]
    s3Client = boto3.client('s3', config=boto3.session.Config(signature_version='s3v4',))
    
    try:
        params = {'Bucket': bucketName, 'Key': exactObjectName}
        response = s3Client.generate_presigned_url('get_object', Params=params, ExpiresIn=600)
        sns_resource = boto3.resource('sns')
        topicARN = "arn:aws:sns:ap-southeast-1:653413855845:pre-signed-url-scanner-topic.fifo"
        topic = sns_resource.Topic(topicARN)
        message = {"presignedUrl": response, "fileName": exactObjectName  }
        topicQueueResponse = topic.publish(
            Message=json.dumps({'default': json.dumps(message)}),
            MessageStructure='json',
            MessageGroupId="presignedUrl"
        )
        
    except Exception as e:
        print(e)
        logging.error(e)
        return "Error"
    return topicQueueResponse
```

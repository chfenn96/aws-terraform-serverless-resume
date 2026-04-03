import json
import boto3
import os

# Initialize DynamoDB
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('TABLE_NAME', 'VisitorCount')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # 1. Update the item in DynamoDB (Atomic Counter)
    response = table.update_item(
        Key={'id': 'visitors'},
        UpdateExpression='ADD #c :inc',
        ExpressionAttributeNames={'#c': 'count'},
        ExpressionAttributeValues={':inc': 1},
        ReturnValues='UPDATED_NEW'
    )
    
    # 2. Get the new count from the response
    new_count = response['Attributes']['count']

    # 3. Return the response with CORS headers
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*', # Required for your website to talk to the API
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'GET'
        },
        'body': json.dumps({'count': int(new_count)})
    }
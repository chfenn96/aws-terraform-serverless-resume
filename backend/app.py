import json
import boto3
import os


def get_table():
    dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
    table_name = os.environ.get("TABLE_NAME", "VisitorCount")
    return dynamodb.Table(table_name)


def lambda_handler(event, context):
    try:
        table = get_table()

        # Atomic update: Increments even if the item doesn't exist yet
        response = table.update_item(
            Key={"id": "visitors"},
            UpdateExpression="ADD #c :inc",
            ExpressionAttributeNames={"#c": "count"},
            ExpressionAttributeValues={":inc": 1},
            ReturnValues="UPDATED_NEW",
        )

        new_count = response["Attributes"]["count"]

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "GET",
            },
            "body": json.dumps({"count": int(new_count)}),
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Internal Server Error"}),
        }
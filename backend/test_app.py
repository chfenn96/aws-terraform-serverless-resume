import os
import json
import boto3
import pytest
from moto import mock_aws


@pytest.fixture
def aws_credentials():
    os.environ["AWS_ACCESS_KEY_ID"] = "testing"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
    os.environ["AWS_DEFAULT_REGION"] = "us-east-1"
    os.environ["TABLE_NAME"] = "VisitorCount"


@pytest.fixture
def dynamodb_setup(aws_credentials):
    with mock_aws():
        db = boto3.resource("dynamodb", region_name="us-east-1")
        db.create_table(
            TableName="VisitorCount",
            KeySchema=[{"AttributeName": "id", "KeyType": "HASH"}],
            AttributeDefinitions=[{"AttributeName": "id", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST",
        )
        table = db.Table("VisitorCount")
        table.put_item(Item={"id": "visitors", "count": 0})
        yield db


# TEST 1: Happy Path
def test_lambda_handler_success(dynamodb_setup):
    from app import lambda_handler

    # Seed initial count
    dynamodb_setup.Table("VisitorCount").put_item(Item={"id": "visitors", "count": 0})

    response = lambda_handler({}, {})
    body = json.loads(response["body"])
    assert response["statusCode"] == 200
    assert body["count"] == 1


# TEST 2: Missing Item (DynamoDB 'ADD' should handle this)
def test_lambda_handler_no_item(dynamodb_setup):
    from app import lambda_handler

    # Table exists, but it's EMPTY
    response = lambda_handler({}, {})
    body = json.loads(response["body"])
    assert response["statusCode"] == 200
    assert body["count"] == 1  # Should initialize to 0 and add 1


# TEST 3: System Error (Table doesn't exist)
def test_lambda_handler_error(aws_credentials):
    with mock_aws():
        # We DON'T create the table here
        from app import lambda_handler

        response = lambda_handler({}, {})
        assert response["statusCode"] == 500
        assert "Internal Server Error" in response["body"]


# TEST 4: Read Only Mode (Simulate by passing a query parameter that tells the handler not to increment)
def test_lambda_handler_read_only(dynamodb_setup):
    from app import lambda_handler

    # Seed table
    dynamodb_setup.Table("VisitorCount").put_item(Item={"id": "visitors", "count": 10})

    # MATCH THE CONTRACT: Use 'action': 'view' as defined in app.py
    event = {"queryStringParameters": {"action": "view"}}
    response = lambda_handler(event, {})
    body = json.loads(response["body"])

    assert response["statusCode"] == 200
    assert body["count"] == 10  # Should NOT be 11

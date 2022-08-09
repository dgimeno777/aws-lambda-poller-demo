
def lambda_handler(event, context):
    print(f"lambda event: {event}")
    return {
        "statusCode": 200
    }

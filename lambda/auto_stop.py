import boto3

ec2 = boto3.client('ec2')
cloudwatch = boto3.client('cloudwatch')

def lambda_handler(event, context):
    response = ec2.describe_instances()
    instances_to_stop = []

    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            state = instance['State']['Name']
            tags = instance.get('Tags', [])

            tag_dict = {tag['Key']: tag['Value'] for tag in tags}

            # ✅ Tag-based filtering
            if tag_dict.get('AutoStop') == 'true':
                if state == 'running':
                    instances_to_stop.append(instance_id)

    # ✅ Stop instances
    if instances_to_stop:
        ec2.stop_instances(InstanceIds=instances_to_stop)
        print(f"Stopped instances: {instances_to_stop}")

        # ✅ Send custom CloudWatch metric
        cloudwatch.put_metric_data(
            Namespace='EC2AutoStop',
            MetricData=[
                {
                    'MetricName': 'InstancesStopped',
                    'Value': len(instances_to_stop),
                    'Unit': 'Count'
                }
            ]
        )
    else:
        print("No instances to stop.")
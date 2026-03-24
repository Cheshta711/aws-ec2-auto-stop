import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    response = ec2.describe_instances()
    instances_to_stop = []

    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            tags = instance.get('Tags', [])

            tag_dict = {tag['Key']: tag['Value'] for tag in tags}

            if tag_dict.get('AutoStop') == 'true' and tag_dict.get('State') == '0':
                if instance['State']['Name'] == 'running':
                    instances_to_stop.append(instance_id)

    if instances_to_stop:
        ec2.stop_instances(InstanceIds=instances_to_stop)
        print(f"Stopped instances: {instances_to_stop}")
    else:
        print("No instances to stop.")

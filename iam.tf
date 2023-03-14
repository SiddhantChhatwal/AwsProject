resource "aws_iam_role" "S3DynamoDBFullAccessRole" {
  name = "S3DynamoDBFullAccessRole"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "S3DynamoDBFullAccessRoleInstanceProfile" {
  name = "S3DynamoDBFullAccessRoleInstanceProfile"
  role = aws_iam_role.S3DynamoDBFullAccessRole.name
}

resource "aws_iam_role_policy_attachment" "DynamoDB-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role = aws_iam_role.S3DynamoDBFullAccessRole.name
}

resource "aws_iam_role_policy_attachment" "S3-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = aws_iam_role.S3DynamoDBFullAccessRole.name
}

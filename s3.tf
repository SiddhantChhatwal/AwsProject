resource "aws_s3_bucket" "employee-directory-app-siddhantchhatwal" {
  bucket = "employee-directory-app-siddhantchhatwal"
}

resource "aws_s3_bucket_policy" "S3FullAccessPolicy" {
  bucket = aws_s3_bucket.employee-directory-app-siddhantchhatwal.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [{
      "Sid": "AllowS3ReadAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::788736453143:role/S3DynamoDBFullAccessRole"
      },
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.employee-directory-app-siddhantchhatwal.arn}",
        "${aws_s3_bucket.employee-directory-app-siddhantchhatwal.arn}/*"
      ]
    }]
  }
  EOF

}

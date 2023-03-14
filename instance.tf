resource "aws_launch_configuration" "app-config" {
  image_id = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.S3DynamoDBFullAccessRoleInstanceProfile.name
  security_groups = [aws_security_group.app-sg.id]
  user_data = <<EOF
  #!/bin/bash -ex
  wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
  unzip FlaskApp.zip
  cd FlaskApp/
  yum -y install python3 mysql
  pip3 install -r requirements.txt
  amazon-linux-extras install epel
  yum -y install stress
  export PHOTOS_BUCKET="${aws_s3_bucket.employee-directory-app-siddhantchhatwal.bucket}"
  export AWS_DEFAULT_REGION=ap-south-1
  export DYNAMO_MODE=on
  FLASK_APP=application.py /usr/local/bin/flask run --host=0.0.0.0 --port=80
  EOF
    
  }

  resource "aws_autoscaling_group" "app-asg" {
    name = "app-asg"
    launch_configuration = aws_launch_configuration.app-config.name
    min_size = 2
    max_size = 4
    desired_capacity = 2
    vpc_zone_identifier = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
    target_group_arns = [aws_lb_target_group.app-target-group.arn]
    health_check_type = "ELB"
    health_check_grace_period = 300
  }

resource "aws_autoscaling_policy" "app-asg-policy" {
  name = "app-asg-policy"
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60  
  }
}

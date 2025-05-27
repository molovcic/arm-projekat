data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "ecs_optimized_amazon_linux_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["591542846629"]
}

resource "aws_launch_template" "arm_launch_template" {
  name_prefix            = "arm_launch_template"
  image_id               = data.aws_ami.ubuntu_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.arm_ec2_access_key.key_name
  vpc_security_group_ids = [aws_security_group.arm_security_group.id]
  user_data = base64encode(templatefile("./templates/user_data.tpl", {
    cluster_name = aws_ecs_cluster.arm_ecs_cluster.name
  }))
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.ebs_encryption_key.arn
      volume_size           = 30
    }
  }
  iam_instance_profile {
    name = data.aws_iam_instance_profile.lab_instance_profile.name
  }
  depends_on = [
    aws_kms_key.ebs_encryption_key
  ]
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    "Name" = "armz19378-PublicServer"
  }
}
resource "aws_autoscaling_group" "arm_autoscaling_group" {
  name_prefix               = "arm_autoscaling_group"
  max_size                  = 2
  min_size                  = 1
  vpc_zone_identifier       = [aws_subnet.arm_subnet_public.id]
  wait_for_capacity_timeout = "2m"
  launch_template {
    id      = aws_launch_template.arm_launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "armz19378-PublicServer"
    propagate_at_launch = true
  }
  depends_on = [
    aws_launch_template.arm_launch_template
  ]
}
resource "aws_instance" "arm_server_private" {
  ami                    = data.aws_ami.ecs_optimized_amazon_linux_ami.id
  iam_instance_profile   = data.aws_iam_instance_profile.lab_instance_profile.name
  instance_type          = "t2.micro"
  vpc_security_group_ids = [resource.aws_security_group.arm_security_group.id]
  subnet_id              = aws_subnet.arm_subnet_private.id
  user_data_base64 = base64encode(templatefile("./templates/user_data.tpl",
    {
      cluster_name = aws_ecs_cluster.arm_ecs_cluster.name
  }))

  root_block_device {
    encrypted  = true
    kms_key_id = resource.aws_kms_key.ebs_encryption_key.arn
  }
  tags = {
    "Name" = "armz19378-PrivateServer"
  }
}

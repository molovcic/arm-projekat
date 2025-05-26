data "aws_caller_identity" "current" {}
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}
data "aws_iam_instance_profile" "lab_instance_profile" {
  name = "LabInstanceProfile"
}


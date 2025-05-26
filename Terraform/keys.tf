resource "aws_key_pair" "arm_ec2_access_key" {
  key_name   = "arm-ec2-access-key"
  public_key = var.ssh_pubkey
}
data "aws_iam_policy_document" "ebs_encryption_kms_key_policy" {
  statement {
    sid = "Allow all to root and terraform user"
    principals {
      type = "AWS"
      identifiers = [
        "${data.aws_caller_identity.current.arn}"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid    = "Allow service-linked role use of the customer managed key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${data.aws_caller_identity.current.arn}",
        "arn:aws:iam::${local.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${data.aws_caller_identity.current.arn}",
        "arn:aws:iam::${local.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
      ]
    }
    actions   = ["kms:CreateGrant"]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = [true]
    }
  }
}
resource "aws_kms_key" "ebs_encryption_key" {
  description = "Encryption Key for EBS volume"
  policy      = data.aws_iam_policy_document.ebs_encryption_kms_key_policy.json
}

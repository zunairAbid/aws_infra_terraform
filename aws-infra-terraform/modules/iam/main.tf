# create an iam user
resource "aws_iam_user" "iam_user" {
  name = "${var.global_variables.project}-${terraform.workspace}-userAccess"
}

# give the iam user programatic access
resource "aws_iam_access_key" "iam_access_key" {
  user = aws_iam_user.iam_user.name
}

# create the inline s3 policy
data "aws_iam_policy_document" "s3_get_put_detele_policy_document" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
      "arn:aws:s3:::${var.s3_bucket_name}"
    ]
  }
}

# create the inline policy ssm parameter store

data "aws_iam_policy_document" "ssm_parameters_policy_document" {
  statement {
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:ssm:${var.iam.ssm_parameter_region}:${var.iam.account_id}:parameter/${var.iam.ssm_parameter_name_prefix}/*"
    ]
  }
}

# create the inline policy secret manager

data "aws_iam_policy_document" "secret_manager_policy_document" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      "arn:aws:secretsmanager:${var.iam.secret_manager_region}:${var.iam.account_id}:secret:${var.iam.secret_manager_name_prefix}/*"
    ]
  }
}

# attach the policy s3 to the user
resource "aws_iam_user_policy" "s3_get_put_detele_policy" {
  name    = "${var.global_variables.project}-${terraform.workspace}-s3AccessPolicy"
  user    = aws_iam_user.iam_user.name
  policy  = data.aws_iam_policy_document.s3_get_put_detele_policy_document.json
}

# attach the policy ssm parameter store to the user
resource "aws_iam_user_policy" "ssm_parameters_policy" {
  name    = "${var.global_variables.project}-${terraform.workspace}-ssm-param-AccessPolicy"
  user    = aws_iam_user.iam_user.name
  policy  = data.aws_iam_policy_document.ssm_parameters_policy_document.json
}

# attach the policy secret manager to the user
resource "aws_iam_user_policy" "secret_manager_policy" {
  name    = "${var.global_variables.project}-${terraform.workspace}-secretManager-accessPolicy"
  user    = aws_iam_user.iam_user.name
  policy  = data.aws_iam_policy_document.secret_manager_policy_document.json
}
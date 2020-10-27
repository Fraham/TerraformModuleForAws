variable "project" {
  type        = string
  description = "Shorthand project name"
}

variable "account_id" {
  type        = string
  description = "The id for the AWS account"
}

variable "role_name" {
  description = "The name of the function having default alarms set"
  type        = list(string)
}

resource "aws_iam_policy" "lambda_access_to_log_groups" {
  name        = "${var.project}-LambdaAccessToLogGroups"
  path        = "/"
  description = "IAM policy for lambda access to log groups"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:ListTagsLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DeleteRetentionPolicy",
        "logs:PutRetentionPolicy",
        "logs:CreateLogGroup",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:${var.account_id}:log-group:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_access_to_log_groups" {
  for_each = toset(var.role_name)

  role       = each.value
  policy_arn = aws_iam_policy.lambda_access_to_log_groups.arn
}

resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  for_each = toset(var.role_name)

  role       = each.value
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

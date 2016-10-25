data "aws_caller_identity" "current" {}

resource "aws_iam_role" "call_bless_lambda_role" {
  name = "call_bless_lambda_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "call_bless_instance_profile" {
  name = "call_bless_instance_profile"
  path = "/"
  roles = [ "${aws_iam_role.call_bless_lambda_role.name}" ]
}

resource "aws_iam_role_policy" "call_bless_lambda_policy" {
  name = "call_bless_lambda_policy"
  role = "${aws_iam_role.call_bless_lambda_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.bless_function}"
            ]
        }
    ]
}
EOF
}


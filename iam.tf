resource "aws_iam_role" "ec2_role" {
  name = "ec2-dynamodb-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "dynamodb_put_policy" {
 name = "dynamodb-users-putitem-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "dynamodb:PutItem"
      ]
      Resource = aws_dynamodb_table.users.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.dynamodb_put_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-dynamodb-profile-${var.environment}"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name = "ec2-cloudwatch-logs-${var.environment}"
  
  description = "Permite que EC2 envie logs para CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/ec2/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

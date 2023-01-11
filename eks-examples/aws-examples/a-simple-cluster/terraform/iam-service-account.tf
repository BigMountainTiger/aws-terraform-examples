resource "aws_iam_role" "service_account" {
  name = "eks-a-simple-cluter-sa-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::$account_id:oidc-provider/$oidc_provider"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "service_account" {
  name        = "eks-a-simple-cluter-sa-policy"
  description = "eks-a-simple-cluter-sa-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
  ] })

}

resource "aws_iam_role_policy_attachment" "ecs_task_s3" {
  role       = aws_iam_role.service_account.name
  policy_arn = aws_iam_policy.service_account.arn
}
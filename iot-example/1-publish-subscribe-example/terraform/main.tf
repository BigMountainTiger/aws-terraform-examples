resource "aws_iot_policy" "iot_all" {
  name = "iot_all_policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "iot:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
  })
}

resource "aws_iot_certificate" "iot_all_cert" {
  certificate_pem = file("../.cert/certificate.pem")
  active          = true
}

resource "aws_iot_policy_attachment" "iot_all_cert_attachment" {
  policy = aws_iot_policy.iot_all.name
  target = aws_iot_certificate.iot_all_cert.arn
}

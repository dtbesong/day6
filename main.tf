resource "aws_iam_role" "ec2_s3_role" {
    name = "ec2_s3_role"
    assume_role_policy = jsonencode(
  {
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
          
        }
      },
    ]
 })
   
}


resource "aws_iam_role_policy" "ec2_s3_role_policy" {
  name   = "ec2_s3_role_policy"
  role   = aws_iam_role.ec2_s3_role.id
  policy = jsonencode(
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "s3getandputObject",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
  })

}


resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_s3_role.name
}

resource "aws_instance" "web" {
  ami  = "ami-09d4a659cdd8677be"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  associate_public_ip_address = true
  key_name = "ireland"

  tags = {
    Name = "webserver"
  }
}













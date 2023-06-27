resource "aws_iam_role" "cluster-role" {
  name = "cluster-role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRole"
            ]
        }
    ]
  }
  EOF
}

resource "aws_iam_policy_attachment" "phantom-eks-management" {
  name = "phantom-eks-management"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles = [ aws_iam_role.cluster-role.id ]
}

resource "aws_eks_cluster" "phantom" {
  name = "phantom"
  vpc_config {
    subnet_ids = [ 
        aws_subnet.private-us-east-1a.id,  
        aws_subnet.private-us-east-1b.id,
        aws_subnet.private-us-east-1c.id
    ]
  }
  role_arn = aws_iam_role.cluster-role.arn
}
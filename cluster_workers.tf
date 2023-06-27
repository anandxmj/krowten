resource "aws_iam_role" "eksworker" {
  name = "eksworker"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
  }
  EOF
}

resource "aws_iam_policy_attachment" "worker-cni" {
  name = "worker-cni"
  roles = [ aws_iam_role.eksworker.id ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy_attachment" "worker-node" {
  name = "worker-node"
  roles = [ aws_iam_role.eksworker.id ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "worker-container-reg-ro" {
  name = "worker-container-reg-ro"
  roles = [ aws_iam_role.eksworker.id ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_security_group" "phantom-worker" {
  vpc_id = aws_vpc.krowten.id
  name = "phantom-worker"
  ingress  {
    description = "Allow SSH"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  egress {
    description = "Allow HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "all"
  }
  tags = {
    Project = "krowten" 
    Name = "phantom-worker"
  }
}

resource "aws_launch_template" "phantom-worker" {
  name = "phantom-worker"
  image_id = "ami-022e1a32d3f742bd8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.phantom-worker.id
  ]
  user_data = filebase64("files/userdata.sh")
  
  tags = {
    Project = "krowten"
  }
}

resource "aws_eks_node_group" "phantom-workers" {
  node_group_name = "phantom-workers"
  node_role_arn = aws_iam_role.eksworker.arn
  launch_template {
    id = aws_launch_template.phantom-worker.id
    version = aws_launch_template.phantom-worker.latest_version
  }
  scaling_config {
    min_size = 1
    max_size = 5
    desired_size = 2
  }
  cluster_name = aws_eks_cluster.phantom.name
  subnet_ids = [ 
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id, 
    aws_subnet.private-us-east-1c.id
  ]
}
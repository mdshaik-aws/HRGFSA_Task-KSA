output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "public_subnets" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "private_subnets" {
  value = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd52b2f"]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "ALBIngressControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("alb-controller-policy.json")  # Download from AWS docs
}


data "aws_iam_policy_document" "alb_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_oidc.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer,"https://","")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_controller_role" {
  name               = "alb-ingress-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}


resource "kubernetes_service_account" "alb_controller_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn
    }
  }
}


resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  values = [
    yamlencode({
      clusterName = aws_eks_cluster.eks_cluster.name
      region      = "us-east-1"
      vpcId       = aws_vpc.eks_vpc.id # <-- Add your VPC ID here
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.alb_controller_sa.metadata[0].name
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.alb_controller_sa
  ]
}


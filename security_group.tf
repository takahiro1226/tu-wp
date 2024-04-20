#sg = security group
# ---------------------------------------------
# Security Group 設定
# ---------------------------------------------

### web層 security group
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "Web layer security group"
  #上記2つはオプションだが、わかりやすいように設定
  vpc_id = aws_vpc.vpc.id
  #ファイルがまたがっていても、同じディレクトリにあれば読み込んでくれる

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    Project = var.project
    Env     = var.environment
  }
}

#httpの受信
resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

#httpsの受信
resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

#AP層tcp3000へ送信
resource "aws_security_group_rule" "web_out_tcp3000" {
  security_group_id        = aws_security_group.web_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.ap_sg.id
}

### AP層 security group
resource "aws_security_group" "ap_sg" {
  name        = "${var.project}-${var.environment}-ap-sg"
  description = "AP layer security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-ap-sg"
    Project = var.project
    Env     = var.environment
  }
}

#AP層tcp3000の受信
resource "aws_security_group_rule" "ap_in_tcp3000" {
  security_group_id        = aws_security_group.ap_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.web_sg.id
}

#S3へ送信
resource "aws_security_group_rule" "ap_out_http" {
  security_group_id = aws_security_group.ap_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

resource "aws_security_group_rule" "ap_out_https" {
  security_group_id = aws_security_group.ap_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
}

#DB層へ送信
resource "aws_security_group_rule" "ap_out_tcp3306" {
  security_group_id        = aws_security_group.ap_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.db_sg.id
}


### 運用・管理(Operation)層 security group
resource "aws_security_group" "op_sg" {
  name        = "${var.project}-${var.environment}-op-sg"
  description = "Operation layer security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-op-sg"
    Project = var.project
    Env     = var.environment
  }
}

#SSHの受信
resource "aws_security_group_rule" "op_in_ssh" {
  security_group_id = aws_security_group.op_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

#AP層tcp3000の送信
resource "aws_security_group_rule" "op_in_tcp3000" {
  security_group_id = aws_security_group.op_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  source_security_group_id = aws_security_group.ap_sg.id
}

# #AP層tcp3000の受信
# resource "aws_security_group_rule" "op_in_tcp3000" {
#   security_group_id = aws_security_group.op_sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 3000
#   to_port           = 3000
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# #http,httpsへ送信のためのセキュリティグループ
# resource "aws_security_group_rule" "op_out_http" {
#   security_group_id = aws_security_group.op_sg.id
#   type              = "egress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "op_out_https" {
#   security_group_id = aws_security_group.op_sg.id
#   type              = "egress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_blocks       = ["0.0.0.0/0"]
# }

### DB層 security group
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "DB layer security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

#sqlの受信
resource "aws_security_group_rule" "db_in_tcp3306" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ap_sg.id
}
# # ---------------------------------------------
# # RDS parameter group
# # ---------------------------------------------

# resource "aws_db_parameter_group" "mysql_parametergroup" {
#   name   = "${var.project}-${var.environment}-mysql-parametergroup"
#   family = "mysql8.0"

#   parameter {
#     name  = "character_set_database"
#     value = "utf8mb4"
#     #DBの文字コード
#   }

#   parameter {
#     name  = "character_set_server"
#     value = "utf8mb4"
#   }

#   #  lifecycle {
#   #     ignore_changes = [tags_all,name_prefix,name,id]
#   #   }
# }

# # ---------------------------------------------
# # RDS option group
# # ---------------------------------------------

# resource "aws_db_option_group" "mysql_optiongroup" {
#   name                 = "${var.project}-${var.environment}-mysql-optiongroup"
#   engine_name          = "mysql"
#   major_engine_version = "8.0"
# }

# # ---------------------------------------------
# # RDS subnet group
# # ---------------------------------------------

# resource "aws_db_subnet_group" "mysql_subnetgroup" {
#   name = "${var.project}-${var.environment}-mysql-subnetgroup"

#   subnet_ids = [
#     aws_subnet.private_subnet_1a.id,
#     aws_subnet.private_subnet_1b.id
#   ]

#   tags = {
#     Name    = "${var.project}-${var.environment}-mysql-subnetgroup"
#     Project = var.project
#     Env     = var.environment
#   }
# }

# # ---------------------------------------------
# # RDS instance
# # ---------------------------------------------
# resource "random_string" "db_password" {
#   length  = 16
#   special = false
# }

# resource "aws_db_instance" "mysql" {
#   engine         = "mysql"
#   engine_version = "8.0"

#   identifier = "${var.project}-${var.environment}-mysql"
#   #RDSのインスタンスリソース名
#   username = "admin"
#   password = random_string.db_password.result
#   #マスターDBのアカウント設定
#   instance_class = "db.t2.micro"

#   allocated_storage     = 20
#   max_allocated_storage = 50
#   storage_type          = "gp2"
#   storage_encrypted     = false
#   #DBを暗号化するKMS鍵か、false

#   multi_az               = false
#   db_subnet_group_name   = aws_db_subnet_group.mysql_subnetgroup.name
#   vpc_security_group_ids = [aws_security_group.db_sg.id]
#   publicly_accessible    = false
#   port                   = 3306

#   db_name = "webapplication"
#   #DB名
#   parameter_group_name = aws_db_parameter_group.mysql_parametergroup.name
#   option_group_name    = aws_db_option_group.mysql_optiongroup.name

#   backup_window              = "04:00-05:00"
#   backup_retention_period    = 7
#   #バックアップを残す数
#   maintenance_window         = "Mon:05:00-Mon:07:00"
#   auto_minor_version_upgrade = false

#   deletion_protection = false
#   #削除するときfalseに変更
#   skip_final_snapshot = true
#   #削除するときtureに変更
#   apply_immediately = true
#   #削除するときtureに変更

#   tags = {
#     Name    = "${var.project}-${var.environment}-mysql-standalone"
#     Project = var.project
#     Env     = var.environment
#   }
# }

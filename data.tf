###管理対象外
###pl = prefixlist
data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.*.s3"
}
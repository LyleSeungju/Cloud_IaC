


# # RDS
# module "rds" {
#   source               = "./modules/rds"
#   rds_name             = var.rds_name
#   allocated_storage    = var.allocated_storage
#   db_name              = var.db_name
#   engine               = var.engine
#   engine_version       = var.engine_version
#   instance_class       = var.instance_class
#   username             = var.username
#   password             = var.password
#   skip_final_snapshot  = var.skip_final_snapshot
#   max_allocated_storage = var.max_allocated_storage
#   security_group_id    = module.sg_private_cloud.security_group_id
#   subnet_ids           = [module.subnet_public_service.subnet_id]
# }


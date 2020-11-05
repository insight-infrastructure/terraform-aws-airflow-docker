#####
# EBS
#####
variable "create_ebs_volume" {
  type    = bool
  default = false
}

variable "device_name" {
  description = "The path of the EBS volume"
  type        = string
  default     = "/dev/xvdf"
}

variable "ebs_volume_size" {
  description = "Size of attached ebs volume"
  type        = number
  default     = 8
}

resource "aws_ebs_volume" "this" {
  count = var.create_ebs_volume && var.create ? 1 : 0

  availability_zone = join("", aws_instance.this.*.availability_zone)
  size              = var.ebs_volume_size
  tags              = merge({ Name = local.name_suffix }, var.tags)
}

resource "aws_volume_attachment" "this" {
  count = var.create_ebs_volume && var.create ? 1 : 0

  device_name  = var.device_name
  volume_id    = join("", aws_ebs_volume.this.*.id)
  instance_id  = join("", aws_instance.this.*.id)
  force_detach = true
}
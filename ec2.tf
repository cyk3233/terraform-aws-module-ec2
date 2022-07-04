resource "aws_network_interface" "this" {
  description     = "NIC eth0 for ${var.instance_name}"
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.this.id]

  tags = merge(var.tags, tomap({ Name = format("%s-nic", var.instance_name) }))
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  root_block_device {
    volume_type = var.volnme_type
    volume_size = var.volume_size

    tags = merge(var.tags, tomap({ Name = format("%s-%s-ebs", var.instance_name, var.volnme_type) }))
  }
}

resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}
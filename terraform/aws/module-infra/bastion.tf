resource "aws_security_group" "bastion" {
  count = var.bastion_count > 0 ? 1 : 0

  name        = "bastion"
  description = "Allow SSH traffic from the internet to bastion"
  vpc_id      = module.infra_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_allowed_networks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name       = "bastion"
  })
}


resource "aws_security_group" "allow_bastion_infra" {
  count = var.bastion_count > 0 ? 1 : 0

  name        = "allow-bastion-infra"
  description = "Allow SSH traffic from the bastion to the infra"
  vpc_id      = module.infra_vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion[0].id]
    self            = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name       = "allow-bastion-infra"
  })
}

resource "aws_eip" "bastion" {
  count = var.bastion_count

  instance = aws_instance.bastion[0].id
  vpc      = true

  tags = merge(local.merged_tags, {
    Name       = "${var.customer}-bastion${count.index}"
  })
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  # public_key = var.keypair_public
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

resource "aws_instance" "bastion" {
  count = var.bastion_count

  ami           = data.aws_ami.debian.id
  instance_type = var.bastion_instance_type
  key_name      = aws_key_pair.bastion.key_name

  vpc_security_group_ids = [aws_security_group.bastion[0].id]

  subnet_id               = element(module.infra_vpc.public_subnets, count.index)
  disable_api_termination = false

  tags = merge(local.merged_tags, {
    Name       = "${var.customer}-bastion${count.index}"
    role       = "bastion"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}
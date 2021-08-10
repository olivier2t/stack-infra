resource "aws_security_group" "bastion" {
  count = var.bastion_count > 0 ? 1 : 0

  name = "${var.customer}-${var.env}-bastion"
  description = "Allow SSH traffic from the internet to bastion"
  vpc_id = module.infra_vpc.vpc_id

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
    Name = "${var.customer}-${var.env}-bastion"
  })
}


resource "aws_security_group" "allow_bastion_infra" {
  count = var.bastion_count > 0 ? 1 : 0

  name = "${var.customer}-${var.env}-allow-bastion-infra"
  description = "Allow SSH traffic from the bastion to the infra"
  vpc_id = module.infra_vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion[0].id]
    self            = false
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.env}-allow-bastion-infra"
  })
}

resource "aws_key_pair" "bastion" {
  key_name = "${var.customer}-${var.env}-bastion-key"
  public_key = var.keypair_public
}

resource "aws_eip" "bastion" {
  count = var.bastion_count

  instance = aws_instance.bastion[count.index].id
  vpc = true

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.env}-bastion-${count.index}"
  })
}

resource "aws_instance" "bastion" {
  count = var.bastion_count

  ami = data.aws_ami.debian.id
  instance_type = var.bastion_instance_type
  key_name = aws_key_pair.bastion.key_name

  vpc_security_group_ids = [aws_security_group.bastion[0].id]

  subnet_id = element(module.infra_vpc.public_subnets, 0)
  disable_api_termination = false

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.env}-bastion-${count.index}"
    role = "bastion"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}
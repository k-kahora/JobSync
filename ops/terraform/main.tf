
provider "hcp" {}
provider "aws" {
  region  = "us-west-2"
  profile = "admin"
}

data "hcp_packer_artifact" "jobsync-prod" {
  bucket_name  = "jobsync-prod"
  channel_name = "latest"
  platform     = "aws"
  region       = "us-west-2"
}

module "vpc" {
  source = "/home/malcolm/Projects/terraform/modules/vpc/"
  # version    = "1.0.0"
  vpc_parameters = {
    my_vpc = {
      cidr_block           = "10.16.0.0/16"
      enable_dns_support   = true
      enable_dns_hostnames = true
      tags = {
        Name        = "main vpc"
        Environment = "test"
      }
    }
  }
  subnet_parameters = {
    web_a = {
      cidr_block = "10.16.0.0/18"
      vpc_name   = "my_vpc"

      availability_zone = "us-west-2c"
      tags = {
        Name = "web-a"
      }
    }
    web_b = {
      cidr_block        = "10.16.64.0/18"
      vpc_name          = "my_vpc"
      availability_zone = "us-west-2b"
      tags = {
        Name = "web-b"
      }
    }
    db_a = {
      cidr_block        = "10.16.128.0/18"
      vpc_name          = "my_vpc"
      availability_zone = "us-west-2c"
      tags = {
        Name = "database-b"
      }
    }
    db_b = {
      cidr_block        = "10.16.192.0/18"
      vpc_name          = "my_vpc"
      availability_zone = "us-west-2b"
      tags = {
        Name = "database-b"
      }
    }

  }
  igw_parameters = {
    main_igw = {
      vpc_name = "my_vpc"
    }
  }
  rt_parameters = {
    public_rt = {
      vpc_name = "my_vpc"
      routes   = [{ cidr_block = "0.0.0.0/0", use_igw = true, gateway_id = "main_igw" }]
    }
  }
  rt_association_parameters = {
    ass_0 = {
      subnet_name = "web_b"
      rt_name     = "public_rt"
    }
    ass_1 = {
      subnet_name = "web_a"
      rt_name     = "public_rt"
    }
  }

}

resource "aws_security_group" "allow_ssh_and_phoenix" {
  name   = "global group"
  vpc_id = module.vpc.vpc_ids.my_vpc
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Phoenix (port 4000)"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules (allow all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_db_subnet_group" "jobsync_db_group" {
  name       = "db-subnet-group"
  subnet_ids = [module.vpc.subnet_ids.db_a, module.vpc.subnet_ids.db_b]
}


resource "aws_security_group" "rds_sg" {
  name        = "rds-postgres-sg"
  description = "Allows incoming traffic only from insances that have the web security group associated with them"
  vpc_id      = module.vpc.vpc_ids.my_vpc
  ingress {
    description     = "Allow MariaDB from EC2 instances"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ssh_and_phoenix.id] # <-- referencing existing EC2 SG here
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_db_instance" "jobsync_db" {
  identifier             = "jobsync"
  db_name                = var.db_database
  instance_class         = "db.t3.micro" # free tier 
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "17.2" # most recent version on rds
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.jobsync_db_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  apply_immediately      = true
  skip_final_snapshot    = true
  storage_encrypted      = false
  publicly_accessible    = false
}



resource "aws_instance" "example" {
  ami                         = data.hcp_packer_artifact.jobsync-prod.external_identifier
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.subnet_ids.web_a
  associate_public_ip_address = true
  key_name                    = "test-west"
  security_groups             = [aws_security_group.allow_ssh_and_phoenix.id]
  user_data = templatefile("./userdata.tftpl", {
    db_host     = aws_db_instance.jobsync_db.address
    db_password = var.db_password
    db_username = var.db_username
    db_database = var.db_database
  })
  tags = {
    Name = "latest-ami-test"
  }
}

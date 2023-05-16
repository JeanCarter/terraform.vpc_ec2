/***********************************
*                vpc               *
***********************************/
resource "aws_vpc" "sample_vpc" {
  cidr_block           = "10.111.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "sam-user-vpc"
  }
}

/***********************************
*              subnet              *
***********************************/
resource "aws_subnet" "sample_public_subnet" {
  vpc_id                  = aws_vpc.sample_vpc.id
  cidr_block              = "10.111.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "sam-user-public"
  }
}

resource "aws_subnet" "sample_private_subnet" {
  vpc_id            = aws_vpc.sample_vpc.id
  cidr_block        = "10.111.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "sam-user-private"
  }
}
/***********************************
*        internet gateway          *
***********************************/
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id

  tags = {
    Name = "sam-user-igw"
  }
}

/***********************************
*          Route table             *
***********************************/
resource "aws_route_table" "sample_public_rt" {
  vpc_id = aws_vpc.sample_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }

  tags = {
    Name = "sam-user-public-rt"
  }
}

resource "aws_route_table_association" "sample_public_assoc" {
  subnet_id      = aws_subnet.sample_public_subnet.id
  route_table_id = aws_route_table.sample_public_rt.id
}

/***********************************
*         security groups          *
***********************************/
resource "aws_security_group" "sample_sg" {
  name        = "sam-user_sg"
  description = "sam-user security group"
  vpc_id      = aws_vpc.sample_vpc.id


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #tcp,udp...etc
    cidr_blocks = ["you computer ip address"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #tcp,udp...etc
    cidr_blocks = ["0.0.0.0/0"]
  }
}


/***********************************
*             key pair             *
***********************************/
#in your terminal, do; ssh-keygen -t ed25519, this will generate a keypair. 
#then replace id_ed25519 with the keypair name> in my case it's snowkey
resource "aws_key_pair" "sample_auth" {
  key_name   = "samplekey"
  public_key = file("~/.ssh/samplekey.pub") 
}


/***********************************
*           ec2 instance           *
***********************************/
resource "aws_instance" "deploy001" {
  ami = "ami-05fa00d4c63e32376"
  #ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sample_sg.id]
  subnet_id              = aws_subnet.sample_public_subnet.id
  user_data              = file("userdata.tpl")
  #count                  = 3

  tags = {
    Name = "deploy001"
  }
}


# /***********************************
# *           Provisioner            *
# ***********************************/
#   provisioner "local-exec" {
#     command = templatefile("${var.host_os}-ssh-config.tpl", {
#       hostname     = self.public_ip,
#       user         = "ubuntu",
#       identityfile = "~/.ssh/samplekey"
#     })
#     interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
#   }
# }


#--main/root--

resource "aws_vpc" "vpc_end_point" {
    cidr_block = var.vpc_block
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    tags = {
        Name = var.vpc_name
    }
}


resource "aws_subnet" "subnet_one" {
    availability_zone = var.region_c
    cidr_block = var.subnet_one_block
    vpc_id = aws_vpc.vpc_end_point.id
    map_public_ip_on_launch = false

    tags = {
        Name = var.subnet_one_name
    }

}

resource "aws_subnet" "subnet_two" {
    availability_zone = var.region_b
    cidr_block = var.subnet_two_block
    vpc_id = aws_vpc.vpc_end_point.id
    map_public_ip_on_launch = false

    tags = {
        Name = var.subnet_two_name
    }

}

resource "aws_route_table" "vpc_end_point_rt" {
    vpc_id = aws_vpc.vpc_end_point.id
    tags = {
        Name = "vpc_end_point_rt"
    }
}

resource "aws_route_table_association" "subnet_rt_association_one" {
    route_table_id = aws_route_table.vpc_end_point_rt.id
    subnet_id = aws_subnet.subnet_one.id
}

resource "aws_route_table_association" "subnet_rt_association_two" {
    route_table_id = aws_route_table.vpc_end_point_rt.id
    subnet_id = aws_subnet.subnet_two.id
}


resource "aws_vpc_endpoint" "gw_endpoint" {
    vpc_endpoint_type = "Gateway"
    vpc_id = aws_vpc.vpc_end_point.id
    service_name = "com.amazonaws.us-east-1.s3"
    route_table_ids = [
        aws_route_table.vpc_end_point_rt.id
    ]
    private_dns_enabled = false

    tags = {
        Name = "s3_gateway_end_point"
    }
}

resource "aws_vpc_endpoint_policy" "gw_endpoint_policy" {
  vpc_endpoint_id = aws_vpc_endpoint.gw_endpoint.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "Access-to-specific-VPCE-only",
        "Principal": "*",
        "Action": "s3:*",
        "Effect": "Deny",
        "Resource": ["${aws_s3_bucket.work_load_bucket.arn}",
                    "${aws_s3_bucket.work_load_bucket.arn}/*"],
        "Condition": {
            "StringNotEquals": {
            "aws:SourceVpce": "${aws_vpc.vpc_end_point.id}"
            }
        }
    }
    ]
  })
}

resource "aws_vpc_endpoint_route_table_association" "gw_endpoint_rt_association" {
  route_table_id  = aws_route_table.vpc_end_point_rt.id
  vpc_endpoint_id = aws_vpc_endpoint.gw_endpoint.id
}


resource "aws_s3_bucket" "work_load_bucket" {
    bucket = var.bucket
}


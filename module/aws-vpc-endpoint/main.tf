resource "aws_vpc_endpoint" "ave" {
  for_each            = var.vpc_endpoints
  ip_address_type     = "ipv4"
  service_name        = lookup(each.value, "service_name")
  vpc_endpoint_type   = "Interface"
  vpc_id              = lookup(each.value, "vpc_id", var.vpc_id)
  tags                = merge({ Name = each.key }, tomap(lookup(each.value, "tags", local.tags)))
  private_dns_enabled = true
  # requester_managed   = false
  route_table_ids = []
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )

  security_group_ids = [aws_security_group.asg[each.key].id]
  subnet_ids         = lookup(each.value, "subnet_ids")
  dns_options {
    dns_record_ip_type = "ipv4"
  }
}



resource "aws_security_group" "asg" {
  for_each    = var.vpc_endpoints
  description = "PRIAVTE_API_SG"
  name        = "GWM_PRIVATAPI_SG"
  tags        = merge({ Name = each.key }, tomap(lookup(each.value, "tags", local.tags)))
  vpc_id      = "vpc-04fc3b6b0abc327a9"
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [
    {
      cidr_blocks      = lookup(each.value, "cidr_blocks")
      description      = "allow the traffic"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
}


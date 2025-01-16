variable "name" {
  type        = string
  description = "name (e.g., 'dp', 'cp')"
}

variable "ram_resource_share_tgw_arn" {
  description = "RAM resource share ARN in the ControlPlane account"
  type        = string
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID in the ControlPlane account"
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs in the DataPlane account"
  type        = list(string)
  default     = ["subnet-1234567890"]
}

variable "vpc_id" {
  description = "VPC ID in the DataPlane account"
  type        = string
  default     = "vpc-1234567890"
}

variable "routing_table_ids" {
  type = list(string)
}

variable "tgw_endpoint_subnet_ids" {
  type = list(string)
}

variable "additional_tags" {
  type        = map(string)
  description = "value for additional tags"
  default     = {}
}
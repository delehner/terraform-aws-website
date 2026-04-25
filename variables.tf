variable "organization" {
  type        = string
  description = "Organization's name."
}

variable "application_name" {
  type        = string
  description = "Application's name."
}

variable "environment" {
  type        = string
  description = "Environment where the resource is running."
}

variable "comment" {
  type        = string
  default     = ""
  description = "Comment for the CloudFront resource."
}

variable "default_root_object" {
  type        = string
  default     = "index.html"
  description = "Default root object for the website."
}

variable "min_ttl" {
  type        = number
  default     = 0
  description = "Min TTL."
}

variable "default_ttl" {
  type        = number
  default     = 3600
  description = "Default TTL."
}

variable "max_ttl" {
  type        = number
  default     = 86400
  description = "Max TTL."
}

variable "restriction_type" {
  type        = string
  default     = "none"
  description = "Type of restriction."
}

variable "locations" {
  type        = list(string)
  default     = []
  description = "Restriction to locations."
}

variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "CloudFront's price class."
}

variable "dns_aliases" {
  type        = list(string)
  description = "DNS aliases."
}

variable "domain" {
  type        = string
  description = "The domain for the hosted zone."
}

variable "application_runtime" {
  type        = string
  default     = "nodejs18.x"
  description = "Application runtime."
}

variable "lambda_timeout" {
  type        = number
  default     = 5
  description = "Lambda timeout."
}

variable "log_retention_in_days" {
  type        = number
  default     = 7
  description = "AWS Cloudwatch log retention in days."
}

variable "concurrent_executions" {
  type        = number
  default     = -1
  description = "Number of Lambda concurrent executions."
}

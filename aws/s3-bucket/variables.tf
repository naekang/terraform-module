variable "bucket_name" {
  type        = string
  description = "Name of s3 bucket"

  validation {
    condition     = length(var.bucket_name) > 0
    error_message = "The name must be at least 1 character long."
  }
}

variable "enable_logging" {
  type        = bool
  description = "Access logging enable"
  default     = false
}

variable "logging_target_bucket" {
  type        = string
  description = "Access logging target bucket"
  default     = null
}

variable "logging_target_bucket_prefix" {
  type        = string
  description = "Access logging target bucket"
  default     = null
}

variable "logging_expected_bucket_owner" {
  type        = string
  description = "Account ID of the expected bucket owner."
  default     = null
}

variable "additional_tags" {
  type        = map(string)
  description = "Value for additional tags"
  default     = {}
}
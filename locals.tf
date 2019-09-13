# This local is used to create a simple array with a single plan object if a plan is specified as an optional variable

locals {
  plan = var.plan == null ? [] : [var.plan]
}
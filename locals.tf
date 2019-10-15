# This local is used to create a simple array with a single plan object if a plan is specified as an optional variable

locals {
  plan            = var.plan == null ? [] : [var.plan]
  boot_diagnostic = var.boot_diagnostic ? ["1"] : []
  unique          = "${substr(sha1("${data.azurerm_resource_group.resourceGroup.id}"), 0, 8)}"
  fixname         = "${replace("${var.name}", "-", "")}"
  fixname2        = "${replace("${var.name}", "_", "")}"
  storageName     = "${lower("${local.fixname2}diag${local.unique}")}"
}

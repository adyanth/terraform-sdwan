resource "azurerm_public_ip" "vbond_1" {
  count               = var.counter
  name                = format("pip1_vbond-%02d", count.index)
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = {
    Name = "${format("vbond-%02d", count.index)}"
  }
}

resource "azurerm_public_ip" "vbond_2" {
  count               = var.counter
  name                = format("pip2_vbond-%02d", count.index)
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = {
    Name = "${format("vbond-%02d", count.index)}"
  }
}

resource "azurerm_network_interface" "vbond_1" {
  count               = var.counter
  name                = format("nic1_vbond-%02d", count.index)
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = format("nic1_vbond-%02d", count.index)
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vbond_1[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "vbond_1_interface_security_group" {
  network_interface_id      = resource.azurerm_network_interface.vbond_1[var.counter - 1].id
  network_security_group_id = var.Vipela_Control_Plane
}

resource "azurerm_network_interface" "vbond_2" {
  count               = var.counter
  name                = format("nic2_vbond-%02d", count.index)
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = format("nic2_vbond-%02d", count.index)
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vbond_2[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "vbond_2_interface_security_group" {
  network_interface_id      = resource.azurerm_network_interface.vbond_2[var.counter - 1].id
  network_security_group_id = var.Vipela_Control_Plane
}

resource "azurerm_virtual_machine" "vbond" {
  count                         = var.counter
  name                          = format("vbond-%02d", count.index)
  location                      = var.region
  resource_group_name           = var.resource_group_name
  vm_size                       = var.viptela_instances_type
  availability_set_id           = var.avsetvbond
  primary_network_interface_id  = azurerm_network_interface.vbond_1[count.index].id
  network_interface_ids         = ["${azurerm_network_interface.vbond_1[count.index].id}", "${azurerm_network_interface.vbond_2[count.index].id}"]
  delete_os_disk_on_termination = true
  storage_os_disk {
    name              = format("vbond-os-disk-%02d", count.index)
    os_type           = "Linux"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    id = var.vbond_image
  }
  os_profile {
    computer_name  = format("vbond-%02d", count.index)
    admin_username = var.username
    admin_password = var.password
    custom_data = templatefile("cloud-init/vbond.user_data", {
      vbond       = resource.azurerm_network_interface.vbond_2[0].private_ip_address,
      siteid      = "1",
      domainid    = "1",
      index       = count.index,
      name        = format("vbond-%02d", count.index),
      org_name    = var.org_name,
      sp_org_name = var.sp_org_name,
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  # boot_diagnostics {
  #   enabled     = true
  #   storage_uri = "https://storageaccountnamefordiag.blob.core.windows.net/"
  # }
  depends_on = [
    azurerm_network_interface.vbond_1,
    azurerm_network_interface.vbond_2
  ]
}

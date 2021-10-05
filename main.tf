# Cloudflare Package & Group

locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  flatten_group = flatten([
    for p in var.waf_package : [
      for g in p.waf_groups : {

        package_name        = p.name
        package_sensitivity = p.sensitivity
        package_action      = p.action_mode

        group_name = g.name
        group_mode = g.mode
      }
    ]
  ])

  # Combines Domains and above Flatten group together 
  # This CAN be put under "flatten_group", however, this is to ensure we maintain consistency throughout our modules where 
  # var.domains is its own separate list 
  grouped = [
    for pair in setproduct(local.flatten_group, var.domains) : {
      package_name        = pair[0].package_name
      package_sensitivity = pair[0].package_sensitivity
      package_action      = pair[0].package_action

      zone_name = pair[1]

      group_name = pair[0].group_name
      group_mode = pair[0].group_mode
    }
  ]
}

data "cloudflare_zones" "zone" {

  # The reason to use "${g.group_name}-${g.zone_name}" is to ensure uniqueness across all objects
  # package,group name is basically always going to be the same, therefore we need to append the domain to ensure uniqueness of the key
  #for_each = { for g in local.grouped : "${g.group_name}-${g.zone_name}" => g }

  # probably best to keep this like this to keep it simple for now
  # that way we only put in the key only no need to do complex uniqueness thing, not necessary here
  for_each = toset(var.domains)

  filter {
    name = each.key
  }
}

data "cloudflare_waf_packages" "package" {

  # Transforms this in to numbered index
  # As of today - packages are all the same ID across zones. So its fine to do it like this
  # There is only one Package offered by CF (OWASP)
  for_each = { for g, v in local.grouped : g => v }
  zone_id  = data.cloudflare_zones.zone[each.value.zone_name].zones[0].id

  filter {
    name = each.value.package_name
  }
}

# Future Notes: This could be written differently cause group_id is all the same in CF (regardless of domain)
data "cloudflare_waf_groups" "group" {

  for_each = { for g in local.grouped : "${g.group_name}-${g.zone_name}" => g }

  zone_id    = data.cloudflare_zones.zone[each.value.zone_name].zones[0].id
  package_id = data.cloudflare_waf_packages.package[0].packages[0].id

  filter {
    name = each.value.group_name
  }
}

resource "cloudflare_waf_package" "package" {

  # Since package should be created PER zone_id - we use "..." to group the keys
  for_each = { for g in local.grouped : "${g.package_name}-${g.zone_name}" => g... }

  zone_id    = data.cloudflare_zones.zone[each.value[0].zone_name].zones[0].id
  package_id = data.cloudflare_waf_packages.package[0].packages[0].id

  sensitivity = each.value[0].package_sensitivity
  action_mode = each.value[0].package_action
}

resource "cloudflare_waf_group" "group" {
  for_each = { for g in local.grouped : "${g.group_name}-${g.zone_name}" => g }

  # Anytime you get an index error - always check to see if you get a typo
  zone_id  = data.cloudflare_zones.zone[each.value.zone_name].zones[0].id
  group_id = data.cloudflare_waf_groups.group["${each.value.group_name}-${each.value.zone_name}"].groups[0].id

  mode = each.value.group_mode

}

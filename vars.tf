variable "domains" {
  type        = list(string)
  description = "Cloudflare Domain to be applied to"
}

variable "waf_package" {
  type = list(object({
    name        = string
    sensitivity = string
    action_mode = string

    waf_groups = list(object({
      mode = string
      name = string
    }))
  }))

}

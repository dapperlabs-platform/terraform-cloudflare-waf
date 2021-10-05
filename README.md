# terraform-cloudflare-waf

###Cloudflare Web Application Firewall

This module creates cloudflare WAF rule packages and groups

###Example
module "waf_group_demo" {

source = "github.com/dapperlabs-platform/terraform-cloudflare-waf?ref=tag"

waf_package = [
{
name = "DEMO ModSecurity Core Rule Set"
sensitivity = "medium"
action_mode = "block"

    waf_groups = [
      {
        "name": "OWASP Bad Robots",
        "mode": "on"
      },
       {
         "name": "OWASP Common Exceptions",
         "mode": "on"
       },
      {
        "name": "OWASP Generic Attacks",
        "mode": "on"
      },
      {
        "name": "OWASP HTTP Policy",
        "mode": "on"
      },
      {
        "name": "OWASP Protocol Anomalies",
        "mode": "on"
      },
      {
        "name": "OWASP Protocol Violations",
        "mode": "on"
      },
      {
        "name": "OWASP Request Limits",
        "mode": "on"
      },
      {
        "name": "OWASP Slr Et Joomla Attacks",
        "mode": "off"
      },
      {
        "name": "OWASP Slr Et Lfi Attacks",
        "mode": "on"
      },
      {
        "name": "OWASP Slr Et PhpBB Attacks",
        "mode": "off"
      },
      {
        "name": "OWASP Slr Et RFI Attacks",
        "mode": "on"
      },
      {
        "name": "OWASP Slr Et SQLi Attacks",
        "mode": "on"
      },
      {
        "name": "OWASP Slr Et WordPress Attacks",
        "mode": "off"
      },
      {
        "name": "OWASP Slr Et XSS Attacks",
        "mode": "on"
      },
      {
        "name": "OWASP SQL Injection Attacks",
        "mode": "on"
      },
      {
        "name": "OWASP Tight Security",
        "mode": "on"
      },
      {
        "name": "OWASP Trojans",
        "mode": "on"
      },
      {
        "name": "OWASP Uri SQL Injection Attacks",
        "mode": "off"
      },
      {
        "name": "OWASP Uri XSS Attacks",
        "mode": "off"
      },
      {
        "name": "OWASP XSS Attacks",
        "mode": "on"
      },
    ]
}
]

domains = [
    "example.com",
    "demo.example.com"
    ]
}

template {
  source = "<absolute_path>/template.ctmpl"
  destination = "/etc/khulnasoft/health.d/cpu.conf"
  command = "systemctl restart khulnasoft "
}
log_level = "debug"
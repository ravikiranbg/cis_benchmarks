# 2.2.5 Ensure LDAP Server is not enabled is not enabled (Scored)
class cis_benchmarks::redhat7::rule::v_2_1_1::rule_2_2_6 {
  exec{ '2.2.6 - Disable LDAP Server (Scored)':
    command => 'systemctl disable slapd',
    path    => '/sbin:/bin',
    onlyif  => 'test [$(systemctl is-enabled slapd) == "enabled"]',
  }

} #EOF

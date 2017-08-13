# 4.2.2 Configure syslog-ng
# (4.2.2.1) - Ensure syslog-ng service is enabled (Scored)
class cis_benchmarks::redhat7::rule::v_2_1_1::rule_4_2_2(
  Array $cis_syslog_ng_entries= lookup("cis_benchmarks::${::cis_benchmarks::cis_version}::cis_syslog_ng_entries",Array,'first',$cis_benchmarks::params::cis_syslog_ng_entries),
  String $cis_syslog_ng_server = lookup('cis_benchmarks::cis_syslog_ng_server', String, 'first', $cis_benchmarks::params::cis_syslog_ng_server),

  ) inherits ::cis_benchmarks::params {
  $file='/etc/syslog-ng/syslog-ng.conf'
  package { '(4.2.2) - Ensure syslog-ng Package is installed':
    ensure => installed,
    name   => 'syslog-ng',
  }
  file {'(4.2.2.3) - Ensure syslog-ng default file permissions configured (Scored)':
    ensure  =>  file,
    name    =>  $file,
    owner   =>  'root',
    group   =>  'root',
    mode    =>  '0640',
    require => Package['(4.2.2) - Ensure syslog-ng Package is installed'],
  }
  service { '(4.2.1.1) - Ensure syslog-ng Service is enabled (Scored)':
    ensure    => running,
    enable    => true,
    name      => 'syslog-ng',
    subscribe => File['(4.2.2.3) - Ensure syslog-ng default file permissions configured (Scored)'],
  }

  $cis_syslog_ng_entries.each |$entry| {
    file_line { "(4.1.3) Ensure auditing for processes that start prior to auditd is enabled (Scored)":
      ensure =>  present,
      path   =>  $file,
      line   =>  $entry,
      notify =>  Service['(4.2.1.1) - Ensure syslog-ng Service is enabled (Scored)'],
    }
  }
  file_line { '(4.2.2.3) - Ensure syslog-ng default file permissions configured (Scored)':
    ensure => present,
    path   => $file,
    line   => 'options { chain_hostnames(off); flush_lines(0); perm(0640); stats_freq(3600);threaded(yes); };',
    notify => Service['(4.2.1.1) - Ensure syslog-ng Service is enabled (Scored)'],
  }
  file_line { ''(4.2.2.4) Ensure syslog-ng is configured to send logs to a remote log host (Not Scored)':
    ensure => present,
    path   => $file,
    line   => "destination logserver { tcp('${cis_syslog_ng_server}' port(514)); }; log { source(src); destination(logserver);",
    notify => Service['(4.2.1.1) - Ensure syslog-ng Service is enabled (Scored)'],
  }
   }
  notify {'4.2.2.5 Ensure remote syslog-ng messages are only accepted on designated log hosts (Not Scored)':
    subscribe => Service['(4.2.1.1) - Ensure syslog-ng Service is enabled (Scored)'],
  }
} #EOF

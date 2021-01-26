class openstack::neutron::linuxbridge_agent::train::buster(
) {
    require ::openstack::serverpackages::train::buster

    package { 'libosinfo-1.0-0':
        ensure => 'present',
    }

    package { 'neutron-linuxbridge-agent':
        ensure => 'present',
    }

    alternatives::select { 'iptables':
        path => '/usr/sbin/iptables-legacy',
    }
    alternatives::select { 'ip6tables':
        path => '/usr/sbin/ip6tables-legacy',
    }
    alternatives::select { 'ebtables':
        path    => '/usr/sbin/ebtables-legacy',
    }
}

# LDAP servers for labs (based on OpenLDAP)

class role::openldap::replica {
    include ::profile::standard
    include ::profile::base::firewall
    include ::profile::prometheus::openldap_exporter

    include ::profile::openldap

    include ::profile::lvs::realserver

    system::role { 'openldap::labs':
        description => 'LDAP read-only replica'
    }
}

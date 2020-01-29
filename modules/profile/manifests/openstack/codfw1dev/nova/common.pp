class profile::openstack::codfw1dev::nova::common(
    $version = hiera('profile::openstack::codfw1dev::version'),
    $region = hiera('profile::openstack::codfw1dev::region'),
    $db_pass = hiera('profile::openstack::codfw1dev::nova::db_pass'),
    $db_host = hiera('profile::openstack::codfw1dev::nova::db_host'),
    $db_name = hiera('profile::openstack::codfw1dev::nova::db_name'),
    $db_user = hiera('profile::openstack::codfw1dev::nova::db_user'),
    $db_name_api = hiera('profile::openstack::codfw1dev::nova::db_name_api'),
    $nova_controller = hiera('profile::openstack::codfw1dev::nova_controller'),
    $nova_controller_standby = hiera('profile::openstack::codfw1dev::nova_controller_standby'),
    $keystone_host = hiera('profile::openstack::codfw1dev::keystone_host'),
    $glance_host = hiera('profile::openstack::codfw1dev::glance_host'),
    $scheduler_pool = hiera('profile::openstack::codfw1dev::nova::scheduler_pool'),
    $ldap_user_pass = hiera('profile::openstack::codfw1dev::ldap_user_pass'),
    $rabbit_pass = hiera('profile::openstack::codfw1dev::nova::rabbit_pass'),
    $metadata_proxy_shared_secret = hiera('profile::openstack::codfw1dev::neutron::metadata_proxy_shared_secret'),
    Stdlib::Port $metadata_listen_port = lookup('profile::openstack::codfw1dev::nova::metadata_listen_port'),
    Stdlib::Port $osapi_compute_listen_port = lookup('profile::openstack::codfw1dev::nova::osapi_compute_listen_port'),
    String       $dhcp_domain               = lookup('profile::openstack::codfw1dev::nova::dhcp_domain',
                                                    {default_value => 'example.com'}),
    ) {

    class {'::profile::openstack::base::nova::common':
        version                      => $version,
        region                       => $region,
        db_pass                      => $db_pass,
        db_host                      => $db_host,
        db_name                      => $db_name,
        db_user                      => $db_user,
        db_name_api                  => $db_name_api,
        nova_controller              => $nova_controller,
        nova_controller_standby      => $nova_controller_standby,
        keystone_host                => $keystone_host,
        glance_host                  => $glance_host,
        scheduler_pool               => $scheduler_pool,
        ldap_user_pass               => $ldap_user_pass,
        rabbit_pass                  => $rabbit_pass,
        metadata_listen_port         => $metadata_listen_port,
        metadata_proxy_shared_secret => $metadata_proxy_shared_secret,
        osapi_compute_listen_port    => $osapi_compute_listen_port,
        dhcp_domain                  => $dhcp_domain,
    }
    contain '::profile::openstack::base::nova::common'
}

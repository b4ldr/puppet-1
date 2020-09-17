class profile::openstack::base::pdns::dns_floating_ip_updater(
    $floating_ip_ptr_zone = lookup('profile::openstack::base::designate::floating_ip_ptr_zone'),
    $floating_ip_ptr_fqdn_matching_regex = lookup('profile::openstack::base::designate::floating_ip_ptr_fqdn_matching_regex'),
    $floating_ip_ptr_fqdn_replacement_pattern = lookup('profile::openstack::base::designate::floating_ip_ptr_fqdn_replacement_pattern'),
    ) {

    class {'::openstack::designate::dns_floating_ip_updater':
        floating_ip_ptr_zone                     => $floating_ip_ptr_zone,
        floating_ip_ptr_fqdn_matching_regex      => $floating_ip_ptr_fqdn_matching_regex,
        floating_ip_ptr_fqdn_replacement_pattern => $floating_ip_ptr_fqdn_replacement_pattern,
    }
    contain '::openstack::designate::dns_floating_ip_updater'
}

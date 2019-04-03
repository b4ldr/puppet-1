class profile::openstack::base::clientpackages(
    String $version = hiera('profile::openstack::base::version'),
) {
    class { "::openstack::commonpackages::${version}": }
    class { "::openstack::clientpackages::${version}::${::lsbdistcodename}": }
}

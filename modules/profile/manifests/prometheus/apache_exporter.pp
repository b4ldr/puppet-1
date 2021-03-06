class profile::prometheus::apache_exporter (
    Array[Stdlib::Host] $prometheus_nodes = lookup('prometheus_nodes'),
) {
    prometheus::apache_exporter { 'default': }
    $prometheus_ferm_nodes = join($prometheus_nodes, ' ')
    $ferm_srange = "(@resolve((${prometheus_ferm_nodes})) @resolve((${prometheus_ferm_nodes}), AAAA))"

    ferm::service { 'prometheus-apache_exporter':
        proto  => 'tcp',
        port   => '9117',
        srange => $ferm_srange,
    }
}

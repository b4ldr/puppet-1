# Uses the prometheus module and generates the specific configuration
# needed for WMF production
#
# filtertags: labs-project-monitoring
class role::prometheus::k8s {
    system::role { 'prometheus::k8s':
        description => 'Prometheus server (k8s)',
    }

    include ::standard
    include ::base::firewall
    include ::profile::prometheus::k8s
}

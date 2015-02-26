# vim: set ts=4 et sw=4:
class role::citoid {
    system::role { 'role::citoid': }

    include ::citoid

    monitoring::service { 'citoid':
        description   => 'citoid',
        check_command => 'check_http_on_port!1970',
    }

    ferm::service { 'citoid':
        proto => 'tcp',
        port  => '1970',
    }
}

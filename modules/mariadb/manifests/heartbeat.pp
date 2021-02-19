# mariadb heartbeat capability
class mariadb::heartbeat (
    $enabled    = false,
    $interval   = 1,
    $shard      = 'unknown',
    $datacenter = 'none',
    $socket     = '/run/mysqld/mysqld.sock',
) {


    # custom modified version of pt-heartbeat that includes an
    # extra column "shard"
    file { '/usr/local/bin/pt-heartbeat-wikimedia':
        owner  => 'root',
        group  => 'root',
        mode   => '0555',
        source => 'puppet:///modules/mariadb/pt-heartbeat-wikimedia',
    }

    $binlog_format = $mariadb::config::binlog_format
    systemd::service { 'pt-heartbeat-wikimedia':
        content        => template('mariadb/pt-heartbeat-wikimedia.service.erb'),
        restart        => true,
        service_params => {
            ensure => $enabled,
        }
    }
}

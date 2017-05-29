# == Class: logstash::output::elasticsearch::scripts
#
# Provision utility scripts for Logstash Elasticsearch output
#
class logstash::output::elasticsearch::scripts {
    #TODO: to remove once cleanup is done
    file { '/usr/local/bin/logstash_delete_index':
        ensure => absent,
    }

    file { '/usr/local/bin/logstash_clear_cache.sh':
        ensure => absent, # T144396 - removing the clear cache mechanism to validate it is not needed anymore
        owner  => 'root',
        group  => 'root',
        mode   => '0555',
        source => 'puppet:///modules/logstash/logstash_clear_cache.sh',
    }
}
# vim:sw=4 ts=4 sts=4 et:

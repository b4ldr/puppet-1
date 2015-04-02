class snapshot::wikidatadumps::common {
    file { '/usr/local/bin/wikidatadumps-shared.sh':
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/snapshot/wikidatadumps-shared.sh',
    }

    file { '/var/log/wikidatadump':
        mode    => '0755',
        ensure  => 'directory',
        owner   => 'datasets',
        group   => 'apache',
    }
}

class snapshot::wikidatadumps::json(
    $enable = true,
    $user   = undef,
) {
    include snapshot::wikidatadumps::common

    if ($enable == true) {
        $ensure = 'present'
    }
    else {
        $ensure = 'absent'
    }

    system::role { 'snapshot::wikidatadumps::json':
        ensure => $ensure,
        description => 'producer of weekly wikidata json dumps'
    }

    file { '/usr/local/bin/dumpwikidatajson.sh':
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/snapshot/dumpwikidatajson.sh',
    }

    cron { 'wikidatajson-dump':
        ensure      => $ensure,
        command     => "/usr/local/bin/dumpwikidatajson.sh",
        user        => $user,
        minute      => '15',
        hour        => '3',
        weekday     => '1',
    }

    # Purge system::role with former class name
    system::role { 'snapshot::wikidatajsondump':
        ensure => 'absent'
    }
}

class snapshot::wikidatadumps::ttl(
    $enable = true,
    $user   = undef,
) {
    include snapshot::wikidatadumps::common

    if ($enable == true) {
        $ensure = 'present'
    }
    else {
        $ensure = 'absent'
    }

    system::role { 'snapshot::wikidatadumps::ttl':
        ensure => $ensure,
        description => 'producer of weekly wikidata ttl dumps'
    }

    file { '/usr/local/bin/dumpwikidatattl.sh':
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/snapshot/dumpwikidatattl.sh',
    }

    cron { 'wikidatattl-dump':
        ensure      => $ensure,
        command     => "/usr/local/bin/dumpwikidatattl.sh",
        user        => $user,
        minute      => '15',
        hour        => '3',
        weekday     => '3',
    }
}

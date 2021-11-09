class profile::mediawiki::maintenance::computer_aided_tagging {
  profile::mediawiki::periodic_job { 'MachineVision_prioritize_uncategorized':
    command  => '/usr/local/bin/mwscript extensions/MachineVision/maintenance/prioritizeFilesWithTemplate.php --wiki=commonswiki --template=Uncategorized --priority=10',
    interval => 'Sun 00:00',
  }
}
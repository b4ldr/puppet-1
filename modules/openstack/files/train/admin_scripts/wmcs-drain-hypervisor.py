#!/usr/bin/python3
"""
 Migrate all VMs off a given hypervisor, one at a time.

 This doesn't take a requested destination; we let the nova
 scheduler decide where to put things.

 Note that if you don't want new VMs flooding back onto the
 hypervisor while draining you will need to adjust its membership
 in host aggregates. This script doesn't automate that so we don't
 lose track of how the hypervisor was assigned beforehand.
"""

import argparse
import os
import time
import logging
import sys

import mwopenstackclients

if sys.version_info[0] >= 3:
    raw_input = input


class NovaInstance(object):
    def __init__(self, osclients, instance_id):
        self.instance_id = instance_id
        self.osclients = osclients
        self.novaclient = self.osclients.novaclient()
        self.refresh_instance()

    def refresh_instance(self):
        self.instance = self.novaclient.servers.get(self.instance_id)
        self.instance_name = self.instance._info["name"]

    def wait_for_status(self, desiredstatus):
        oldstatus = ""

        while self.instance.status != desiredstatus:
            if self.instance.status != oldstatus:
                oldstatus = self.instance.status
                logging.info(
                    "current status is {}; waiting for it to change to {}".format(
                        self.instance.status, desiredstatus
                    )
                )

            time.sleep(2)
            self.refresh_instance()

    def migrate(self):
        logging.warning("Migrating %s (%s)" % (self.instance.name, self.instance.id))
        self.instance.live_migrate()
        self.wait_for_status("MIGRATING")
        self.wait_for_status("ACTIVE")
        logging.info(
            "instance {} ({}) is now on host {} with status {}".format(
                self.instance_id,
                self.instance_name,
                self.instance._info["OS-EXT-SRV-ATTR:host"],
                self.instance.status,
            )
        )


if __name__ == "__main__":
    argparser = argparse.ArgumentParser(
        "wmcs-drain-hypervisor", description="Move all VMs off a given hypervisor"
    )
    argparser.add_argument(
        "--nova-user",
        help="username for nova auth",
        default=os.environ.get("OS_USERNAME", None),
    )
    argparser.add_argument(
        "--nova-pass",
        help="password for nova auth",
        default=os.environ.get("OS_PASSWORD", None),
    )
    argparser.add_argument(
        "--nova-url",
        help="url for nova auth",
        default=os.environ.get("OS_AUTH_URL", None),
    )
    argparser.add_argument("hypervisor", help="name of hypervisor to drain")

    args = argparser.parse_args()

    logging.basicConfig(
        format="%(filename)s: %(levelname)s: %(message)s",
        level=logging.INFO,
        stream=sys.stdout,
    )

    osclients = mwopenstackclients.clients()
    nova = osclients.novaclient()

    all_instances = nova.servers.list(
        search_opts={"host": args.hypervisor, "all_tenants": True}
    )
    logging.warning("%s servers on %s." % (len(all_instances), args.hypervisor))
    for instance in all_instances:
        if instance.name.startswith("canary"):
            logging.warning(
                "Igoring canary instance %s (%s)" % (instance.name, instance.id)
            )
            # Leave the canary behind; it won't do any good anywhere else
            continue
        instanceobj = NovaInstance(osclients, instance.id)
        instanceobj.migrate()

    logging.shutdown()

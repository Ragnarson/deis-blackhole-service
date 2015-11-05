# Blackhole service for Deis

A simple Blackhole implementation for Deis (CoreOS) platform.

The service will ban every ip address that tried to login onto an instance with a wrong password. Except for those that are listed in the WHITELIST variable.

### Deployment

1. Create the `blackhole.service` file:

  ```
    [Unit]
    Description=Turn on automated addition of blackhole routes for sshd attackers

    [Service]
    TimeoutStartSec=0
    ExecStartPre=-/usr/bin/docker kill deis-blackhole
    ExecStartPre=-/usr/bin/docker rm deis-blackhole
    ExecStartPre=/usr/bin/docker pull twobox/deis-blackhole
    ExecStop=/usr/bin/docker kill deis-blackhole
    ExecStart=/bin/sh -c '/usr/bin/docker run --name deis-blackhole --net=host --privileged -e WHITELIST="$(fleetctl list-machines --fields=ip -no-legend)" -v /var/log/journal:/var/log/journal:ro -v /usr/bin/journalctl:/usr/bin/journalctl:ro -v /lib64:/usr/local/lib64:ro twobox/deis-blackhole'
    Restart=always

    [Install]
    WantedBy=multi-user.target

    [X-Fleet]
    Global=true
  ```

  In this example WHITELIST variable points to all instance's ip addresses in a cluster.

2. Submit a service to cluster:

  ```bash
    $ fleetctl submit <path-to-service-file>/blackhole.service
    $ fleetctl start blackhole
  ```

### Special thanks

This script is inspired by @ianblenke's [blackhole cloud-init script](https://github.com/ianblenke/coreos-vagrant-kitchen-sink/blob/master/tested/blackhole.cloud-init) and @siomiz's [blackhole](https://github.com/siomiz/blackhole) container script written in python.

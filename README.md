---
comments: true
date: 2013-10-07 00:01:00
layout: post
slug: zfs-zpool-status-monitor
title: ZFS ZPool Status Monitor
summary: >
 Monitors ZPool errors and, if any are found, will display info on which disks are affecting the ZPool.
image: placeholder-logo.png
githubproject: uptimesoftware/zfs-zpool-status-monitor
category: plugin
tags:
- plugin
- zfs
version_compatibility:
- ZFS ZPool Status Monitor 2.0: [7.1, 7.0, 6.0, 5.5, 5.4, 5.3, 5.2 ]
description: >
  Monitors ZPool errors and, if any are found, will display info on which disks are affecting the ZPool.

supported_monitoring_stations: [7.1, 7.0, 6.0, 5.5, 5.4, 5.3, 5.2 ]
supported_agents: Solaris, Linux, AIX
installation_notes: |
 [Install using the up.time Plugin Manager](https://github.com/uptimesoftware/uptime-plugin-manager)
dependencies: Agent-side script/mod and perl (on remote Solaris systems).
input_variables:
- agent port (9998)
- agent password
- agent remote script
- ZFS pool (pool to monitor)
output_variables:
- will display either an "OK" or "CRITICAL..." with info on the issue
languages_used: [Shell/Batch, PHP, Perl]
---

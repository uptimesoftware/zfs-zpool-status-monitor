# ZFS ZPool Status Monitor

See http://uptimesoftware.github.io for more information.

### Tags 
 plugin   zfs  

### Category

plugin

### Version Compatibility


  
* ZFS ZPool Status Monitor 2.0 - 7.1, 7.0, 6.0, 5.5, 5.4, 5.3, 5.2
  


### Description
Monitors ZPool errors and, if any are found, will display info on which disks are affecting the ZPool.


### Supported Monitoring Stations

7.1, 7.0, 6.0, 5.5, 5.4, 5.3, 5.2

### Supported Agents
Solaris, Linux, AIX

### Installation Notes
<p><a href="https://github.com/uptimesoftware/uptime-plugin-manager">Install using the up.time Plugin Manager</a></p>


### Dependencies
<p>Agent-side script/mod and perl (on remote Solaris systems).</p>


### Input Variables

* agent port (9998)

* agent password

* agent remote script

* ZFS pool (pool to monitor)


### Output Variables


* will display either an "OK" or "CRITICAL..." with info on the issue


### Languages Used

* Shell/Batch

* PHP

* Perl


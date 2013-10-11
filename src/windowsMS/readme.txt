-----------------------
ZFS Status Monitor
-----------------------

This monitor will trigger a "zpool status <POOLNAME>" command on a remote Solaris system and parse the output, displaying any errors found or an OK message.


Agent Configuration
-----------------------

Since this plugin requires an agent component you will need to do the following on each Solaris system where you want this monitor to run.

1. Extract the agent perl file from the zip (MonitorZFSStatus-agent.zip) and place it in the directory "/opt/uptime-agent/scripts/"

2. Make sure the "zfs_status_agent.pl" is owned by the "nobody" user and is executable

3. Create/edit the following agent password file:
"/opt/uptime-agent/bin/.uptmpasswd"

4. Copy/paste the following line into the password file:
password   /opt/uptime-agent/scripts/zfs_status_agent.pl

You can change the "password" to whatever you like.

That should be it!
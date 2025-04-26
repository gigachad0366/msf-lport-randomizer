### msf lport randomizer plugin
---

why randomize lport ?

- metasploit framework payloads use the port 4444 by default. with time, network monitoring systems started to flag that port as suspicous because its being used by attackers a lot to communicate with the compromised host through a reverse shell. This plugin will help making the connection more stealthy by setting a random listening port, which decreases the chances of systems getting alerted by IDS.

how to install ?

- place the plugin file under plugins folder in metasploit-framework. location of msf root path may vary depending on your distro.

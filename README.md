# Smart PDU

## Overview

Script providing watchdog logic to a Tasmota32 based PDU (Power Distribution Unit). Script monitors connectivity 
to each device behind each of the available Schuko sockets

## Setup

### Rules

Set the following rule to let timers execute regardless of NTP:

```
Rule1 ON Power1#Boot do Time 1669593600 ENDON

Rule1 ON
```

### Berry

Upload the two files to the Tasmota FS:

 * autoexec.be
 * smart_pdu.be

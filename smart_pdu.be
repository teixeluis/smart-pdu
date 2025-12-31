# Watchdog probing loop in seconds:
LOOP_PERIOD = 20
MIN_SCORE = 0
MAX_SCORE = 10

RESTART_DELAY = 40000


devices = [{'ip': '192.168.1.1', 'name': 'router', 'relay': 2, 'score': 10}, {'ip': '192.168.100.1', 'name': 'starlink', 'relay': 3, 'score': 10}, {'ip': '192.168.3.1', 'name': 'vpn-node', 'relay': 4, 'score': 10}, {'ip': '192.168.1.64', 'name': 'hassio', 'relay': 5, 'score': 10}, {'ip': '192.168.1.232', 'name': 'nos-lte', 'relay': 6, 'score': 10}]


def rule_ping(device, outcome)
    # Add the logic to deal with the ping having suceeded or failed

    if outcome == 0
        print("rule_ping: ping for device " + device['name'] + " failed. Decreasing score.")
        if device['score'] > MIN_SCORE
            device['score'] -= 1
        end
    else
        if device['score'] < MAX_SCORE
            device['score'] += 1
        end
    end
end

def init_wdt_instances()
    for device: devices
        # Add rules for the ping results:

        tasmota.add_rule("Ping#" + device['ip'] + "#Success", def (outcome) rule_ping(device, outcome) end)
    end
end

def check_instances()
    for device: devices
        # Check if the score for this device is already poor:
        if device['score'] <= MIN_SCORE
            print("check_instances: score for device " + device['name'] + " is below minimum (score = " + str(device['score']) + "). Will need to take action.")

            # 1. Set score back to maximum to avoid looping:
            device['score'] = MAX_SCORE

            # 2. Restart action:
            tasmota.set_timer(0, /-> tasmota.cmd("Power" + str(device['relay']) + " 1"))
            tasmota.set_timer(RESTART_DELAY, /-> tasmota.cmd("Power" + str(device['relay']) + " 0"))
        end

        # Initiate ping for the devices:
        tasmota.cmd("Ping " + device['ip'])
    end
end


def main()
    init_wdt_instances()
    tasmota.add_cron("*/" + str(LOOP_PERIOD) + " * * * * *", /-> check_instances(), "check_instances")
end

main()

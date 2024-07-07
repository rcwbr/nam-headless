# Project log

## Pi setup

- Download Raspberry Pi imager per [instructions](https://www.raspberrypi.com/software/)
- Download [Raspberry Pi OS Lite](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-32-bit)
- Extract image, select in imager
- Use OS customization
  - Configure wireless LAN
  - General > Set username and password
  - Services > Enable SSH, Use password authentication

Boot Pi
Log in, enable WiFi: `sudo ifconfig wlan0 up`
Connect to network: `nmcli device wifi connetn 'On your left' password [password]`
Get ip address: `ip addr`

Configure static IP:
From router config:
- Advanced > LAN Setup > Address Reservation > Add
- Set to 192.168.1.17

Connect via ssh: `ssh 192.168.1.17`
Configure named SSH connection: `echo 'Host 192.168.1.17' >> ~/.ssh/config`
Configure ssh key access:
  - `echo 'Host AmpPi' >> ~/.ssh/config`
  - `echo '  Hostname 192.168.1.17' >> ~/.ssh/config`
  - `echo '' >> ~/.ssh/config`
  - `ssh-copy-id AmpPi`

Set up Jack:
- `sudo apt-get update && sudo apt-get --no-install-recommends install jackd1`
  - Enable realtime process priority
- `sudo apt-get --no-install-recommends install jack-tools`
- `sudo apt-get install qjackctl`
- `sudo apt-get install jack2`
- `sudo apt-get install qjackctl`
<!-- - `sudo apt-get install python3-jack-client` -->
- Test audio output: `speaker-test -t sine -c 2`
- List USB devices for input: `lsusb`
```
Bus 001 Device 004: ID 0582:012b Roland Corp. DUO-CAPTURE
```
- `nano ~/test-jack-plumbing`

Start jack daemon:

`jackd --realtime-priority 70 --port-max 16 --timeout 2000 -d alsa --shorts --rate 44100 --outchannels 2`

```
jack_connect jack-play-6702:out_1 system:playback_1
jack_connect jack-play-6702:out_2 system:playback_2
```

With specified hardware devices
```
jackd --realtime-priority 70 --port-max 16 --timeout 2000 -d alsa --shorts --rate 44100 --outchannels 2 --capture hw:CARD=DUOCAPTURE,DEV=0 --playback hw:CARD=Headphones,DEV=0
```

```
jack_connect system:capture_1 system:playback_1
jack_connect system:capture_2 system:playback_2
```

`sudo apt-get install jalv`

`sudo apt-get install lilv-utils`

Build NAM lv2 plugin
`sudo apt-get install git build-essential cmake`
```
git clone --recurse-submodules -j4 https://github.com/mikeoliphant/neural-amp-modeler-lv2
cd neural-amp-modeler-lv2/build
cmake .. -DCMAKE_BUILD_TYPE="Release"
make -j4
```

TODO:
- Separate OS image partition from data partition

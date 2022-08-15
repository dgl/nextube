# Nextube

Nextube is a Kickstarter project to make a Nixie tube style clock.

There are some promises from Rotrics to release proper development tools, but
these are some notes on how the API works until that is here; for general
community information see the [Facebook
group](https://www.facebook.com/groups/197056519103446)

## Hardware

The device is ESP32 based. Around 8MB of flash? (df via API reports 7MB, which
includes a bunch of the clock faces shipped in the app bundle, firmware is
1.4MB)

## HTTP API

[Notes](http.md).

## Serial API

Presents a USB Serial API. Based on the software appears to do more than HTTP
(different config/update process?), but I haven't yet looked into it in detail.

## Scripts

These are some very rough scripts that use the HTTP API.

* [number-print.sh](number-print.sh)

Run this in a directory of Nextube formatted numbers (0.jpg, 1.jpg, ...,
blank.jpg) and it will update the first gallery to be the given up to 6 digit
number. This is writing to the flash, so don't do it too often, and note it
annoyingly needs to reset the device. (Which on my hardware can result in an
audible noise, even if volume is turned off.)

* Night mode

There isn't yet a builtin way to alter the brightness or turn off at night. You
can do something like this and arrange for it to be run from crontab or
systemd.

Save a copy of your config (do this once):

```
nextube=your-device
curl http://$nextube'/api/file/download?path=/config.json' > config.json
```

Alter the LCD brightness in the config, e.g. run this part in the evening:
```
jq '.lcd_brightness = 1' config.json | curl -F file=@- http://$nextube'/api/file/upload?path=/config.json'
sleep 1
curl -d '' http://$nextube/api/reset
```

1 is very low brightness, 0 turns off the LCD entirely.

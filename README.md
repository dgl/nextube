# Nextube

Nextube is a [Kickstarter](https://www.kickstarter.com/projects/rotrics/nextube-a-retro-nixie-clock-inspired-modern-display) and [Indiegogo](https://www.indiegogo.com/projects/nextube-retro-nixie-clock-inspired-modern-display) project to make a Nixie tube style clock.

There are some promises from Rotrics (the people behind the hardware) to release proper development tools, but
these are some notes on how the API works until that is here; for general
community information see the [Facebook
group](https://www.facebook.com/groups/197056519103446). In particular there's a great "Community User Guide" available there in the Files section that is _far far better_ than what you will find on the Rotrics site.

*The below are some unofficial notes. Using any of this can probably void your
warranty, or at least make it difficult to support you, if you don't understand
it, it's probably not worth trying any of this yet, sorry.*

## Hardware

The device is ESP32-WROVER-E based. Likely to be the 8MB of flash variant (df via API reports 7MB, which includes a bunch of the clock faces shipped in the app bundle (~5.1MB), firmware is 1.4MB)

## Web config UI

When the device is on your network, assuming you know the IP address (which you may have got from your router, a network scan, or from the web UI when you first connected and set it up) - it should be accessible via plain HTTP (not HTTPS)

`http://[IP]/cfg`

Note that you'll need to add `/cfg` on the end of the URL - if you try just `http://[IP]` you will get a plain text message in the browser window stating: `Not found: /` (it looks like they haven't set up a redirect or landing page for the root). Similarly, once you are in the web config page, if you click on HOME in the top left, it will try to take you back to '/', which will still not be found.

You can use the web config UI to reconfigure the wifi, upload a new firmware image, or restart the device remotely.

## YouTube subscriber counter app

[Notes](youtube.md)

## HTTP API

[Notes](http.md).

## Serial API

Presents a USB Serial API. Based on the desktop app software appears to do more than HTTP
(different config/update process?); the app has some files that are part of an
ESP32 SDK, so it is possible it is doing a full flash of the device -- maybe
this is the way they will offer a real SDK?

If you alter the clock faces bundled within in the app (e.g. on a Mac,
`/Applications/Rotrics Nextube.app/Contents/Resources/static/data`, see the
community FAQ for more details) you can make the app update them over USB, this
will only work over USB. Beware: If you make images which are more complex or
less compressed than the provided clock faces you can very easily run the
device out of disk space (see notes on HTTP API `df` endpoint for a way to
check).

## Scripts

These are some very rough scripts that use the HTTP API.

* [number-print.sh](number-print.sh)

Run this in a directory of Nextube formatted numbers (0.jpg, 1.jpg, ...,
blank.jpg) and it will update the first gallery to be the given up to 6 digit
number. This is writing to the flash, so don't do it too often, and note it
annoyingly needs to reset the device. (Which on my hardware can result in an
audible noise, even if volume is turned off.)

### "Night mode"

There isn't yet a builtin way to alter the brightness or turn off at night. You
can do something like this and arrange for it to be run from crontab or
systemd.

Save a copy of your config (do this once):

```shell
nextube=your-device
curl http://$nextube'/api/file/download?path=/config.json' > config.json
```

Alter the LCD brightness in the config, e.g. run this part in the evening:

```shell
jq '.lcd_brightness = 1' config.json | curl -F file=@- http://$nextube'/api/file/upload?path=/config.json'
sleep 1
curl -d '' http://$nextube/api/reset
```

1 is very low brightness, 0 turns off the LCD entirely.

You can also switch off the backlight by changing the value of `backlight_onoff` from "ON" to "OFF" (and vice versa) using the same method.

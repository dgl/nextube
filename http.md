# HTTP API

Various endpoints under `/api/`. If you send the wrong method (e.g. GET when
POST is expected) you get a 404.

It appears that if you make multiple concurrent HTTP requests, the device
resets itself.

Get a list of the endpoints is in the firmware:

```
strings firmware.bin | grep /api/
```

## Endpoints

The examples below use curl, you can recreate them by setting
`nextube=device-ip` in your (Unix) shell.

### Information

* POST /api/ping

```
curl -d '' http://$nextube/api/ping
{"status": "OK", "msg": "I am Nextube."}
```

* GET /api/firmwareVersion

```
curl http://$nextube/api/firmwareVersion
{"status": "OK", "version": "v1.2.1"}
```

* GET /api/hardwareVersion

```
curl http://$nextube/api/hardwareVersion
{"status": "OK", "version": "v1.32.0"}
```

### File management

File management is used to access the config (`/config.json`) as well as
uploading images for the gallery (`/images/album/...`).

* POST /api/file/upload?path=...

Upload new config file:

```
curl -F file=@config.json http://$nextube'/api/file/upload?path=/config.json'
```

* GET /api/file/download?path=...

Download config file:

```
curl http://$nextube'/api/file/download?path=/config.json'
```

* DELETE /api/file/delete?path=...

Delete a path:
```
curl -X DELETE http://$nextube'/api/file/delete?path=/images/album/01.jpg'
```

* GET /api/file/ls?path=/images/album/

Path must end with /. Response for `/` or `/images/` is very slow, as above if
you get impatient and try something else, the device will probably reset.

```
curl http://$nextube'/api/file/ls?dir=/images/'
{"status":"OK","data":[{"file":"/images/album/01.jpg","size":8214},{"file":"/images/album/02.jpg","size":8214},{"file":"/images/album/03.jpg","size":8214},{"file":"/images/album/04.jpg","size":8214},{"file":"/images/album/05.jpg","size":8048},{"file":"/images/album/06.jpg","size":8333},{"file":"/images/system/matrix/a.jpg","size":5299},{"file":"/images/system/matrix/i.jpg","size":3140},{"file":"/images/system/matrix/m.jpg","size":6108},{"file":"/images/system/matrix/r.jpg","size":6169},{"file":"/images/system/matrix/t.jpg","size":3979},{"file":"/images/system/matrix/x.jpg","size":5687},{"file":"/images/system/setting/E.jpg","size":2005},{"file":"/images/system/setting/O.jpg","size":2725},{"file":"/images/system/setting/R.jpg","size":2852},{"file":"/images/system/setting/album.jpg","size":4239},{"file":"/images/system/setting/blank.jpg","size":1288},{"file":"/images/system/setting/countdown.jpg","size":3514},{"file":"/images/system/waiting/0.jpg","size":3644},{"file":"/images/system/waiting/1.jpg","size":3759},{"file":"/images/system/waiting/2.jpg","size":3937},{"file":"/images/system/waiting/3.jpg","size":4022},{"file":"/images/system/waiting/4.jpg","size":4056},{"file":"/images/system/waiting/5.jpg","size":3905},{"file":"/images/system/waiting/6.jpg","size":3854},{"file":"/images/system/waiting/7.jpg","size":3695},{"file":null},{}]}
```

```
curl http://$nextube'/api/file/ls?dir=/'
{"status":"OK","data":[{"file":"/audio/Unwritten.mp3","size":720797},{"file":"/audio/bell.wav","size":180044},{"file":"/audio/ringtones_zip.mp3","size":44439},{"file":"/audio/timer.wav","size":180044},{"file":"/audio/tremolo.wav","size":9646},{"file":"/audio/tremolo1.wav","size":9646},{"file":"/audio/tremolo2.wav","size":3246},{"file":"/audio/tremolo3.wav","size":3246},{"file":"/audio/tremolo4.wav","size":3246},{"file":"/config.json","size":1402},{"file":"/images/album/01.jpg","size":8214},{"file":"/images/album/02.jpg","size":8214},{"file":"/images/album/03.jpg","size":8214},{"file":"/images/album/04.jpg","size":8214},{"file":"/images/album/05.jpg","size":8048},{"file":"/images/album/06.jpg","size":8333},{"file":"/images/system/matrix/a.jpg","size":5299},{"file":"/images/system/matrix/i.jpg","size":3140},{"file":"/images/system/matrix/m.jpg","size":6108},{"file":"/images/system/matrix/r.jpg","size":6169},{"file":"/images/system/matrix/t.jpg","size":3979},{"file":"/images/system/matrix/x.jpg","size":5687},{"file":"/images/system/setting/E.jpg","size":2005},{"file":"/images/system/setting/O.jpg","size":2725},{"file":"/images/system/setting/R.jpg","size":2852},{"file":"/images/system/setting/album.jpg","size":4239},{"file":"/images/system/setting/blank.jpg","size":1288},{"file":"/images/system/setting/countdown.jpg"}]}
```

(Note does not include clock faces uploaded via the app -- it looks like there's a limit on the number of files returned, doing e.g. `/images/themes/Custom01` will show you the files in that location.)

* GET /api/file/df

Free disk space:

```
curl http://$nextube'/api/file/df'
```

### Reset

* POST /api/reset

Reboots the device, need to do this after changing the config.

```
curl -d '' http://$nextube/api/reset
```

### [Unknown / to research below]

* POST /api/button

Presumably presses the buttons? From app looks like it would be something like `{"btn:"???"}`.

* POST /api/settings

* /api/update_firmware


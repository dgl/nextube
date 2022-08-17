One of the included "apps" for the Nextube is a YouTube subscriber counter, which can be configured via the desktop app.

Unfortunately: I couldn't get it to work, out of the box.

I *did* eventually get it to work by following the steps below:

- figured out the YouTube API it is using, via digging into the firmware. It is this:

`https://www.googleapis.com/youtube/v3/channels?part=statistics&id=CHANNELIDkey=APIKEY>`

- downloaded the `config.json` file from my Nextube, and found that it contains a `youtube_key` value. Tested this, and it has exceeded a call quota limit.
- created a new project on Google dev console and grabbed a key with access to the YouTube API (this is locked down to only having access to the YouTube Data API)
- the desktop app wants a "Channel ID". This is *not* the name / URL for the channel, but an internal ID. I got mine from the URL of my logged-in YouTube channel dashboard.
- replaced the API key in `config.json`, uploaded, reset, switched over to the YouTube display, waited a few moments, and it now shows subs.

I used curl commands to do the upload and reset:

```shell
curl -F file=@nextube-config-new.json 'http://[IP-addr]/api/file/upload?path=/config.json' && curl -d '' 'http://[IP-addr]/api/reset'
```

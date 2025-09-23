---
title: Squeezebox (Lyrion Music Server)
description: Instructions on how to integrate Squeezebox players and a Lyrion Music Server (LMS) into Home Assistant.
ha_category:
  - Media player
  - Update
ha_release: pre 0.7
ha_iot_class: Local Polling
ha_domain: squeezebox
ha_codeowners:
  - '@rajlaud'
  - '@pssc'
  - '@peteS-UK'
ha_config_flow: true
ha_dhcp: true
ha_platforms:
  - binary_sensor
  - button
  - media_player
  - sensor
  - switch
  - update
ha_integration_type: integration
---

The Squeezebox integration allows you to control music players from the [Lyrion Music Server](https://lyrion.org/) (LMS) ecosystem. Lyrion Music Server was formerly known as [Logitech Media Server](https://en.wikipedia.org/wiki/Squeezebox_%28network_music_player%29).

This integration connects to an existing <abbr title="Lyrion Music Server">LMS</abbr> server and provides both media players and sensors for monitoring server status.

The Squeezebox music player ecosystem, which can be controlled through this integration, includes [hardware audio players](https://lms-community.github.io/players-and-controllers/hardware-comparison/) from Logitech, including [Squeezebox 3rd Generation](https://lyrion.org/players-and-controllers/squeezebox-classic/), [Squeezebox Boom](https://lyrion.org/players-and-controllers/squeezebox-boom/), [Squeezebox Receiver](https://lyrion.org/players-and-controllers/squeezebox-receiver/), [Transporter](https://lyrion.org/players-and-controllers/transporter/), [Squeezebox2](https://lyrion.org/players-and-controllers/squeezebox2/), [Squeezebox](https://lyrion.org/players-and-controllers/squeezebox1/) and [SLIMP3](https://lyrion.org/players-and-controllers/SLIMP3/), and many software emulators like [Squeezelite](https://sourceforge.net/projects/lmsclients/files/squeezelite/), [SqueezeSlave](https://sourceforge.net/projects/lmsclients/files/squeezeslave/), [SoftSqueeze](https://sourceforge.net/projects/lmsclients/files/softsqueeze/) and [SqueezePlay](https://sourceforge.net/projects/lmsclients/files/squeezeplay/).

## Supported devices

The integration supports any Squeezebox compatible [hardware or software players](https://lyrion.org/players-and-controllers/) and both Lyrion Music Servers and Logitech Media Servers.

## Prerequisites

1. One or more Squeezebox compatible [hardware or software players](https://lyrion.org/players-and-controllers/).
2. One or more [Lyrion Music Servers or Logitech Media Servers (LMS)](https://lyrion.org/getting-started) with the Squeezebox players connected to these servers.

{% include integrations/config_flow.md %}

{% note %}
A single configuration entry for the integration adds all Squeezebox devices connected to one LMS to Home Assistant.
{% endnote %}

When the LMS cannot be discovered, it can be manually configured.

{% configuration_basic %}
Host:
  description: "The host name or IP address (e.g., \"192.168.1.2\") of your LMS."
Port:
  description: "The integration uses the web interface of the Lyrion Music Server (LMS) to send commands. The default port of the web interface is 9000. It is the same port that you use to access the LMS through your web browser."
Username:
  description: "If you have selected \"Password Protection\" in your LMS Advanced Security, enter your Username here."
Password:
  description: "If you have selected \"Password Protection\" in your LMS Advanced Security, enter your Password here."
Connect over HTTPS:
  description: "The integration now supports Lyrion Music Servers behind an HTTPS reverse proxy. Please note that Lyrion Music Server natively only supports HTTP traffic. Unless you have configured a reverse proxy, do not select the \"Connect over HTTPS\" option. If you have configured a reverse proxy, remember to update the port number."
{% endconfiguration_basic %}


The Logitech Transporter which have two digital inputs can be activated using a script. The following example turns on the Transporter and activates the toslink input interface:

```yaml
# Turn on Transporter and activate toslink interface
transporter_toslink:
  sequence:
    - action: homeassistant.turn_on
      target:
        entity_id: media_player.transporter
    - action: media_player.play_media
      target:
        entity_id: media_player.transporter
      data:
        media_content_id: 'source:toslink'
        media_content_type: 'music'
```

{% include integrations/option_flow.md %}

{% configuration_basic %}  
Browse limit:  
 description: Maximum number of items to include when browsing media or in a playlist.
Volume step:  
 description: Amount to adjust the volume when turning volume up or down.  
{% endconfiguration_basic %}

## Announce

The Squeezebox media player entity supports the "announce" parameter in the `media_player.play_media` action. When media is played with announce:true, the current state of the media player is saved, the media is then played, and when playing is finished, the original state is restored. For example, if the media player is on and playing a track, once the announcement is finished, the track will resume playing at the same point it was paused by the announcement. If the media player was off, it will be turned off again after playing the announcement.

### Extra Keys

The following extra keys are available to modify the announcement

| Data attribute     | Optional | Description                                                                                                                                                              |
| ------------------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `announce_volume`  | yes      | Specifies the volume at which the announcement should play. The value must be between 0 and 1, where 0.1 represents 10% of the player's volume, 0.2 represents 20%, etc. |
| `announce_timeout` | yes      | Specify the maximum length of the announcement in seconds after which the original media will be resumed.                                                                |

These extra keys are optional. If announce_volume is unspecified, the announcement will play at the current volume of the player. If announce_timeout is unspecified, the announcement will play until completion.

### Examples

Playing a local file as an announcement:

```yaml
action: media_player.play_media
target:
  entity_id: media_player.squeezebox
data:
  media_content_type: music
  media_content_id: media-source://media_source/local/doorbell.mp3
  announce: true
```

Playing a local file as an announcement with volume of 20 and timeout of 60 seconds:

```yaml
action: media_player.play_media
target:
  entity_id: media_player.squeezebox
data:
  media_content_type: music
  media_content_id: media-source://media_source/local/doorbell.mp3
  announce: true
  extra:
    announce_volume: 0.2
    announce_timeout: 60
```

### Announcements and Text to Speech (TTS)

When using the "Text-to-speech (TTS): Speak" action, Home Assistant automatically sets the announce parameter as true, and the announcement features, such as pausing current playback, will be used.

However, the "Text-to-speech (TTS): Speak" action doesn't support the extra keys described above. If you wish to use announce_volume and/or announce_timeout with TTS, you need to use media-source://tts/(tts_provider) to construct media_content_id as shown below.

#### Example

Play announcement using Text-to-speech (TTS) action

```yaml
action: tts.speak
data:
  media_player_entity_id: media_player.squeezebox
  message: There's someone at the door
  cache: false
target:
  entity_id: tts.google_translate_en_co_uk
```

Play announcement using TTS media-source with announce_volume and announce_timeout

```yaml
action: media_player.play_media
target:
  entity_id: media_player.squeezebox
data:
  media_content_type: music
  media_content_id: media-source://tts/tts.google_translate_en_co_uk?message="There's someone at the door"
  announce: true
  extra:
    announce_volume: 0.2
    announce_timeout: 60
```

## Supported functionality

### Switches

- **Alarm**: Enables a scheduled alarm to sound. Alarms must also be enabled on the associated player for the alarm to sound, using the Alarms Enabled switch or directly on the Lyrion Music Server for that player.
- **Alarms Enabled**: Enables a player to sound alarms. Disabling will prevent all alarms from sounding on that player, regardless of whether the individual alarm is enabled

### Binary sensors

The integration provides the following entities.

#### Binary sensors

- **Needs restart**
  - **Description**: Server Service needs to be restarted (typically, this is needed to apply updates).

- **Library rescan**
  - **Description**: The music library is currently being scanned by LMS (depending on the type of scan, some content may be unavailable).

#### Buttons

- **Preset 1 ... Preset 6**
  - **Description**: Play media stored in Preset 1 to Preset 6 on Squeezebox.

- **Brightness up, Brightness down**
  - **Description**: Adjust the brightness on Logitech Squeezebox players
  - **Available on**: Logitech hardware players with built-in screen, such as Radio and Boom.
  
- **Bass up, Bass down**
  - **Description**: Adjust the bass on Logitech Squeezebox players, such as Radio and Boom.
  - **Available on**: Logitech hardware players such as Radio, Duet and Boom.

- **Treble up, Treble down**
  - **Description**: Adjust the treble on Logitech Squeezebox players, such as Radio and Boom.
  - **Available on**: Logitech hardware players such as Radio, Duet, and Boom.

#### Sensors

- **Last scan**
  - **Description**: Date of the last library scan.

- **Player count**
  - **Description**: Number of players on the service.

- **Player count off service**
  - **Description**: Number of players not on this service.

- **Total albums**
  - **Description**: Total number of albums currently available on the service.

- **Total artists**
  - **Description**: Total number of artists currently available on the service.

- **Total duration**
  - **Description**: Duration of all tracks in service (HHHH:MM:SS).

- **Total genres**
  - **Description**: Total number of genres used in current service.

- **Total songs**
  - **Description**: Total number of music files currently in service.

### Updates

This integration will notify you when updates are available on the LMS for the LMS version or for plugins installed on the LMS

  - **Lyrion Music Server**: Update of the server software is available.
  - **Updated plugins**: Plugin updates are available.  The list of updates can be viewed by selecting the "Read release announcement" link.  On the LMS, an option is available on the Manage Plugins settings page to "Update plugins automatically".  If this option is selected, plugins will be downloaded automatically by the LMS and then installed on the next restart of the LMS.  For some installation types of LMS, the LMS can be restarted by selecting the **Update** button. Allow enough time for the LMS to restart as it will become briefly unavailable.

### Actions

The integration provides the following actions.

#### Action `call_method`

Call a custom Squeezebox JSON-RPC API.

See documentation for this interface on `http://HOST:PORT/html/docs/cli-api.html?player=` where HOST and PORT are the host name and port for your Lyrion Music Server.

| Data attribute | Optional | Description                                                                                           |
| -------------- | -------- | ----------------------------------------------------------------------------------------------------- |
| `entity_id`    | no       | Name(s) of the Squeezebox entities where to run the API method.                                       |
| `command`      | no       | Command to pass to Lyrion Music Server (p0 in the CLI documentation).                                 |
| `parameters`   | yes      | Array of additional parameters to pass to Lyrion Music Server (p1, ..., pN in the CLI documentation). |

This action can be used to integrate any Squeezebox action to an automation.

It can also be used to target a Squeezebox from IFTTT (or Dialogflow, Alexa...).

For example, to play an album from your collection, create an IFTTT applet like this:

- Trigger: Google Assistant, with sentence: `I want to listen to album $`
- Action: JSON post query with such JSON body:
  `{ "entity_id": "media_player.squeezebox_radio", "command": "playlist", "parameters": ["loadtracks", "album.titlesearch={{TextField}}"] }`

This can work with title search and basically any thing. The same wouldn't have worked by calling directly Squeezebox server as IFTTT cannot escape the text field.

When specifying additional parameters in the Visual Editor, each parameter must be preceded by a hyphen and a space to correctly populate the array:

For example, to create an automation to mute playback, use the command `mixer` and the parameter `muting`:

| Row | Parameter | Description            |
| --- | --------- | ---------------------- |
| 1   | - muting  | Toggle muting on / off |

resulting in the YAML:

```yaml
# Toggle the muting state of the specified player
action: squeezebox.call_method
metadata: {}
data:
  command: mixer
  parameters:
    - muting
```

Where a parameter is an increment or decrement, it is necessary to place the value in double quotes.

For example, to increase the playback volume, use the command `mixer` and the parameters `volume` and the amount to increment:

| Row | Parameter | Description                   |
| --- | --------- | ----------------------------- |
| 1   | - volume  | Parameter to change           |
| 2   | - "+5"    | Increment volume by 5 percent |

resulting in the YAML:

```yaml
# Increment the playback volume of the specified player by five percent
action: squeezebox.call_method
metadata: {}
data:
  command: mixer
  parameters:
    - volume
    - '+5'
```

#### Action `call_query`

Call a custom Squeezebox JSON-RPC API. The result of the query will be stored in the 'query_result' attribute of the player.

See documentation for this interface on `http://HOST:PORT/html/docs/cli-api.html?player=` where HOST and PORT are the host name and port for your Lyrion Music Server.

| Data attribute | Optional | Description                                                                                           |
| -------------- | -------- | ----------------------------------------------------------------------------------------------------- |
| `entity_id`    | no       | Name(s) of the Squeezebox entities where to run the API method.                                       |
| `command`      | no       | Command to pass to Lyrion Music Server (p0 in the CLI documentation).                                 |
| `parameters`   | yes      | Array of additional parameters to pass to Lyrion Music Server (p1, ..., pN in the CLI documentation). |

This action can be used to integrate a Squeezebox query into an automation. For example, in a Python script, you can get a list of albums available by an artist like this:
`hass.services.call("squeezebox", "call_query", { "entity_id": "media_player.kitchen", "command": "albums", "parameters": ["0", "20", "search:beatles", "tags:al"] })`
To work with the results:
`result = hass.states.get("media_player.kitchen").attributes['query_result']`

## Data updates

The integration uses {% term polling %} to receive updates from the Lyrion Music Server (LMS). It uses the web interface of the LMS to send commands. The default port of the web interface is 9000. It is the same port that you use to access the LMS through your web browser.

## Known limitations

The LMS API, which is used by this integration, does not currently provide the ability to override or control fade-in & crossfade settings. This means that if you have enabled **Play or Resume fade-in duration** within the player's audio settings, this fade-in will be applied to any announcement played.  This could potentially lead to the start of an announcement being missed as it fades in.  You should, therefore, consider a short **Play or Resume fade-in duration** or preferably disabling this feature if you make use of announcements.

## Removing the integration

This integration follows standard integration removal. No extra steps are required.

{% include integrations/remove_device_service.md %}

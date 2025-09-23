---
title: LG ThinQ
description: Setup for LG ThinQ Integration.
ha_category:
  - Hub
ha_release: '2024.11'
ha_iot_class: Cloud Push
ha_code_owners:
  - '@LG-ThinQ-Integration'
ha_config_flow: true
ha_domain: lg_thinq
ha_platforms:
  - binary_sensor
  - climate
  - event
  - fan
  - number
  - select
  - sensor
  - switch
  - vacuum
  - water_heater
ha_integration_type: integration
ha_codeowners:
  - '@LG-ThinQ-Integration'
ha_dhcp: true
---

The **LG ThinQ** integration allows you to connect LG ThinQ devices to Home Assistant. The features of this integration include:

- Control LG appliances as Home Assistant entities through the LG ThinQ Connect API.

## Prerequisites

- This feature works via LG ThinQ cloud. Therefore, an internet connection is required.
- A [personal access token](https://connect-pat.lgthinq.com) to use the LG ThinQ Connect API.

### Personal Access Token (PAT)

1. Access the **[personal access token](https://connect-pat.lgthinq.com)** page (requires an LG ThinQ account).
2. Select **ADD NEW TOKEN**.
3. Enter a new token name and select the following authorized scopes:
    - **Permission to view all devices**
    - **Permission to view all device statuses**
    - **All device control rights**
    - **All device event subscription rights**
    - **All device push notification permissions**
4. Select **CREATE TOKEN**.
5. Once all the steps are completed, you will see that a **PAT** has been generated.

{% include integrations/config_flow.md %}

1. Enter the information to use LG ThinQ Connect API:
   - The **Token Value** obtained through the PAT issuance process. (Required)
   - The entry name.
2. Choose the region (country).

## Supported Devices

### Appliance

Support LG Appliances as follows:

- Air Conditioner
- Air Purifier
- Air Purifier Fan
- Ceiling Fan
- Cooktop
- Dehumidifier
- Dishwasher
- Dryer
- Home Brew
- Hood
- Humidifier
- Kimchi Refrigerator
- Microwave Oven
- Oven
- Plant Cultivator
- Refrigerator
- Robot Cleaner
- Stick Cleaner
- Styler
- System Boiler
- Washcombo Main
- Washcombo Mini
- Washer
- Washtower
- Washtower Dryer
- Washtower Washer
- Water Heater
- Water Purifier
- Wine Cellar
- Ventilator

## Platforms

LG ThinQ represents devices as a set of properties. And these are mapped to entities in Home Assistant.

A list of all Entity Platforms provided by LG ThinQ Integration:

- [Binary sensor](#binary-sensor)
- [Button](#button)
- [Climate](#climate)
- [Event](#event)
- [Fan](#fan)
- [Number](#number)
- [Select](#select)
- [Sensor](#sensor)
- [Switch](#switch)
- [Vacuum](#vacuum)

### Binary sensor

A read-only property which has only two states that can be toggled is represented as a binary sensor platform.

| Device | Property |
| ------ | -------- |
| Cooktop | Remote start |
| Dish Washer | Chime sound<br>Clean indicator light<br>Door<br>Machine clean reminder<br>Remote start<br>Rinse refill needed | 
| Hood | Power |
| Oven | Remote start |
| Refrigerator | Door<br>Eco friendly<br>Power saving mode<br>Sabbath |
| Kimchi Refrigerator | Fresh air filter |
| Dryer<br>Styler<br>Washer<br>Washcombo Main<br>Washcombo Mini<br>Washtower<br>Washtower Dryer<br>Washtower Washer | Remote start |
| Water Heater | Power |
| Wine Cellar | Sabbath |

### Button

A writable property which has only two states that can be toggled is represented as a binary sensor platform.

| Device |Property |Action |
| ------ |-------- | ------ |
| Dish Washer | Operation | Start / Pause |
| Dryer<br>Styler<br>Washer<br>Washcombo Main<br>Washcombo Mini<br>Washtower<br>Washtower Dryer<br>Washtower Washer | Operation | Start / Pause |

### Climate

The properties for controlling both the temperature and wind strength of the appliance are represented as a climate platform.

| Device | Property |
| ------ | -------- |
| Air Conditioner | Current temperature<br>Fan mode<br>Swing mode<br>Swing horizontal mode<br>HVAC mode<br>Preset mode<br>Temperature<br>Temperature cool<br>Temperature heat<br>Unit |
| System Boiler | Current temperature<br>HVAC mode<br>Temperature<br>Temperature cool<br>Temperature heat<br>Unit |

### Event

A notification message pushed from the server is represented as an event platform. The **Notification codes** shows the full support range, and you can check the range of your device through the developer tools.

| Device | Property | Notification codes |
| ------ | -------- | ---------- |
| Air Conditioner | Notification | water_is_full |
| Air Purifier| Notification | lack_of_water, time_to_clean_filter, pollution_is_high, time_to_change_filter |
| Air Purifier Fan | Notification | time_to_change_filter |
| Dehumidifier | Notification | water_is_full |
| Dish Washer | Error<br>Notification | cleaning_is_complete, error_during_cleaning, water_leak_has_occurred, rinse_is_not_enough, salt_refill_is_needed |
| Humidifier | Notification | time_to_change_filter, lack_of_water |
| Kimchi Refrigerator | Notification | door_is_open |
| Microwave Oven | Notification | none |
| Oven | Notification | preheating_is_complete, cooking_is_complete, time_to_clean, error_has_occurred |
| Refrigerator | Notification | time_to_change_filter, time_to_change_water_filter, frozen_is_complete, door_is_open |
| Robot Cleaner | Error<br>Notification | - |
| Stick Cleaner | Notification | charging_is_complete, time_to_clean_filter |
| Washer<br>Dryer<br>Washcombo Main<br>Washcombo Mini<br>Washtower<br>Washtower Dryer<br>Washtower Washer | Error<br>Notification | washing_is_complete, error_during_washing, drying_is_complete, drying_failed |
| Styler | Error<br>Notification | styling_is_complete, error_has_occurred |
| Wine Cellar | Notification | door_is_open |

### Fan

The properties for controlling the wind strength of the appliance are represented as a fan platform.

| Device | Property |
| ------ | -------- |
| Ceiling Fan | Power<br>Speed |

### Number

A read-write property which has a numeric value is represented as a number platform.

| Device | Property |
| ------ | -------- |
| Air Conditioner | Schedule turn-off<br>Schedule turn-on<br>Sleep timer |
| Air Purifier Fan | Sleep timer<br>Wind temperature |
| Hood | Fan<br>Light |
| Humidifier | Sleep timer<br>Target humidity |
| Microwave Oven | Fan<br>Light |
| Oven | Temperature |
| Refrigerator | Temperature |
| Dryer<br>Styler<br>Washer<br>Washcombo Main<br>Washcombo Mini<br>Washtower<br>Washtower Dryer<br>Washtower Washer | Delayed start/end |
| Water Heater | Temperature |
| Wine Cellar | Light<br>Temperature |
| Ventilator | Sleep timer |

### Select

A writable property which has a list of selectable values is represented as a select platform.

| Device |Property |
| ------ |-------- |
| Air Conditioner | Air purify<br>Air quality sensor |
| Air Purifier| Operating mode<br>Speed |
| Air Purifier Fan | Display brightness<br>Operating mode<br>Rotation<br>Speed |
| Dehumidifier | Speed<br>Operation |
| Dish Washer | Operation |
| Humidifier | Display brightness<br>Drying mode<br>Operating mode<br>Speed |
| Oven | Cook mode<br>Operation |
| Refrigerator | Fresh air filter |
| Dryer<br>Styler<br>Washer<br>Washcombo Main<br>Washcombo Mini<br>Washtower<br>Washtower Dryer<br>Washtower Washer | Operation |
| Water Heater | Operating mode |
| Wine Cellar | Light<br>Operating mode |
| Ventilator | Speed<br>Operating mode |

### Switch

A read-write property which has only two states that can be toggled is represented as a switch platform.

| Device | Property |
| ------ | -------- |
| Air Conditioner | Power<br>Lighting<br>Energy saving<br>Air clean |
| Air Purifier | Power |
| Air Purifier Fan | Heating<br>Power<br>UVnano |
| Dehumidifier | Power |
| Dish Washer | Power |
| Dryer<br>Styler<br>Washer<br>Washcombo Main<br>Washcombo Mini<br>Washtower<br>Washtower Dryer<br>Washtower Washer | Power |
| Humidifier | Auto mode<br>Heating<br>Mood light<br>Power<br>Sleep mode |
| Refrigerator | Express mode<br>Express cool<br>Quick freeze |
| System Boiler | Power<br>Hot water |
| Wine Cellar | Ventilation |
| Ventilator | Power |

### Vacuum

The properties for controlling the clean operations of the appliance are represented as a vacuum platform.

| Device | Property |
| ------ | -------- |
| Robot Cleaner | Battery<br>Current status<br>Operation |

### Water heater

The properties for controlling the operating mode and temperature are represented as a water_heater platform.

| Device | Property |
| ------ | -------- |
| Water heater | Mode<br>Current temperature<br>Temperature |

### Sensor

A read-only property which has states is represented as a sensor platform.

| Device | Property |
| ------ | -------- |
| Air Conditioner | Filter remaining<br>Humidity<br>Odor<br>Overall air quality<br>PM1<br>PM10<br>PM2.5<br>Schedule turn-off<br>Schedule turn-on<br>Sleep timer |
| Air Purifier| Humidity<br>Odor<br>Operating mode<br>Overall air quality<br>Personal mode<br>PM1<br>PM10<br>PM2.5<br>Filter remaining<br>Schedule turn-off<br>Schedule turn-on |
| Air Purifier Fan | Humidity<br>Odor<br>Overall air quality<br>PM1<br>PM10<br>PM2.5<br>Sleep timer<br>Temperature<br>Schedule turn-off<br>Schedule turn-on |
| Cooktop | Current status<br>Power level<br>Remaining time |
| Dehumidifier | Humidity<br>Operating mode |
| Dish Washer | Current cycle<br>Current status<br>Rinse aid dispenser level<br>Softening level<br>Delayed start<br>Remaining time<br>Total time |
| Home Brew| Brewing duration<br>Brewing period<br>Current status<br>First flavor<br>Second flavor<br>Homebrew recipe<br>First hop<br>Second hop<br>Recipe progress<br>Wort<br>Yeast |
| Humidifier | Humidity<br>Overall air quality<br>PM1<br>PM10<br>PM2.5<br>Schedule turn-off<br>Schedule turn-on<br>Sleep timer<br>Temperature |
| Kimchi Refrigerator | Fresh air filter<br>Temperature |
| Microwave Oven | Current status |
| Oven | Current status<br>Temperature |
| Plant Cultivator | Current status<br>Day growth temperature<br>Lighting duration<br>Lighting intensity<br>Lights on time<br>Mode<br>Night growth temperature<br>Temperature<br>Wind speed |
| Refrigerator | Fresh air filter<br>Water filter used |
| Robot Cleaner | Current status<br>Operating mode<br>Running time |
| Stick Cleaner | Battery<br>Current status<br>Operating mode |
| System Boiler | Indoor temperature<br>Inlet temperature<br>Outlet temperature |
| Water Purifier | High-temp sterilization<br>Type<br>UVnano|
| Dryer<br>Styler<br>Washer<br>Washcombo Main<br>Washcombo Mini<br>Washtower<br>Washtower Dryer<br>Washtower Washer | Current status<br>Delayed start/end<br>Remaining time<br>Total time<br>Cycles |
| Ventilator | Carbon dioxide<br>PM1<br>PM10<br>PM2.5<br>Sleep timer<br>Temperature<br>Schedule turn-off<br>Schedule turn-on |

## Automation example

### Notification, error event

> - Guide: [Automating on event](https://www.home-assistant.io/integrations/event/#automating-on-a-button-press)
> - Important: guide's step 3, 4
> - You can select the state change you want to act as trigger in step 4

{% raw %}

```yaml
alias: lack of water example
description: Toggle switch when air purifier's lack_of_water
triggers:
  - trigger: state
    entity_id:
      - event.purifier_notification
actions:
  - condition: state
    entity_id: event.purifier_notification
    attribute: event_type
    state: lack_of_water
  - type: toggle
    device_id: xxxxxxxx
    entity_id: xxxxxxxx
    domain: switch
```

{% endraw %}

## Troubleshooting

### Setup

#### Aborted: The token is not valid

This error occurs when the Personal Access Token (PAT) is invalid or entered incorrectly. Please visit the [Personal Access Token Page](https://connect-pat.lgthinq.com) page to check if your token is valid.

#### Aborted: The country is not supported

Check your PAT's valid country in the **Choose the region / Country** section.

#### Error: The number of API calls has been exceeded

This error occurs when there's an abnormal number of API calls made using the PAT.
The LG ThinQ integration will work properly after some time.

## Debugging / Issue report
The LG ThinQ integration will show additional information by enabling log configuration.
1. [Enable debug logging](/docs/configuration/troubleshooting/#enabling-debug-logging).
   - If you change **Enable** to **Disable**, the log will be saved to the download folder.
2. When reporting an issue:
   - Provide screenshots of your device configuration (including device name, type, and entities).
   - Include the debug logs.
   - Describe the expected behavior and what's not working.

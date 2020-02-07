# Chamberlain API requests

The following requests were formulated from: https://github.com/nsnyder/myq-api/tree/implement-update-for-v5

## Requests

### Login

**Request**
```
curl -v -X POST -H 'Content-Type: application/json' -H 'MyQApplicationId: JVM/G9Nwih5BwKgNCjLxiFUQxQijAebyyg8QUHr7JOrP+tuPb8iHfRHKwTmDzHOu' -d '{"username":"...","password":"..."}' 'https://api.myqdevice.com/api/v5/Login'
```

**Response Headers**
```
< HTTP/1.1 200 OK
< Cache-Control: no-cache
< Pragma: no-cache
< Content-Type: application/json; charset=utf-8
< Expires: -1
< MyQ-UserFeatures: vgdo_sensor_alert,enable_v52_event_history_api_final_145,enable_v52_alert_notification_api_final_145,enable_lock_firmware_upgrade_final,enable_mu_release_gdpr,enable_multi_partner_display,amazon_key_advertisement,enable_bhub_lock_pairing_phase_2_final,enable_dealer,enable_final_deactivation_notice,enable_initial_deactivation_notice,enable_v5_partnerlist,enable_p30x_phase_1_final,camera_enable_add_camera_link,enable_v5,migrated_account,aquifer
< MyQ-CorrelationId: 7f9756b7-187b-4b8b-8c0c-1d3cba45dd03
< Request-Context: appId=cid-v1:f384a48e-af08-4025-a4f0-df6df49ee4f4
< Date: Sat, 28 Dec 2019 08:13:07 GMT
< Content-Length: 56
< X-Frame-Options: Deny
< Set-Cookie: TS01dfdd0d=010ae57b5fc6a675d0173f06504a0ce4c89d985934c99747feb660056615c76c9b72a1ea0aa3144baa2998d337837a51f4b9eaad90; Path=/; Domain=.api.myqdevice.com
< Set-Cookie: TS01dfdd0d030=013c6dcea216a4ce997c0cce8f6f78dae54cc276ad634683aeeede1deafb6a302add228d91d6f3d4754cc8e6c23c5788735e78c4e5; Path=/; Domain=.api.myqdevice.com
<
* Connection #0 to host api.myqdevice.com left intact
```

**Response**
```
{"SecurityToken":"2e451d2c-f62a-4b91-b979-90d5b86804a8"}
```



### Account Info

**Request**
```
curl -v -X GET -H 'Content-Type: application/json' -H 'SecurityToken: ...' -H 'MyQApplicationId: JVM/G9Nwih5BwKgNCjLxiFUQxQijAebyyg8QUHr7JOrP+tuPb8iHfRHKwTmDzHOu' 'https://api.myqdevice.com/api/v5/My?expand=account'
```

**Response Headers**
```
< HTTP/1.1 200 OK
< Cache-Control: no-cache
< Pragma: no-cache
< Content-Type: application/json; charset=utf-8
< Expires: -1
< MyQ-CorrelationId: 291b05be-2de4-4583-b652-42327cb38ed8
< Request-Context: appId=cid-v1:f384a48e-af08-4025-a4f0-df6df49ee4f4
< Date: Sat, 28 Dec 2019 09:14:58 GMT
< Content-Length: 1808
< Set-Cookie: TS01dfdd0d=010ae57b5f69c1528a70f03153a3347b5df215fa706f39e9535b35d3d9a0de1d73d278791bf18b1f315f7bda7f82a4a57117ba89b5; Path=/; Domain=.api.myqdevice.com
<
* Connection #0 to host api.myqdevice.com left intact
```

**Response**
```
{
  "Users": {
    "href": "http:\/\/api.myqdevice.com\/api\/v5\/My\/Users"
  },
  "Admin": false,
  "Account": {
    "href": "http:\/\/api.myqdevice.com\/api\/v5\/Accounts\/6d3c77dc-22a4-4dff-802b-78453035b775",
    "Id": "6d3c77dc-22a4-4dff-802b-78453035b775",
    "Name": "Alan's Account",
    "Email": "alandacosta@gmail.com",
    "Address": {
      "AddressLine1": "",
      "AddressLine2": "",
      "City": "",
      "State": "",
      "PostalCode": "92037",
      "Country": {
        "Code": "USA",
        "IsEEACountry": false,
        "href": "http:\/\/api.myqdevice.com\/api\/v5\/Countries\/USA"
      }
    },
    "Phone": "",
    "ContactName": "Alan Da Costa",
    "DirectoryCodeLength": 0,
    "UserAllowance": 4,
    "TimeZone": "America\/Los_Angeles",
    "Devices": {
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/Accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/Devices"
    },
    "Users": {
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/Accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/Users"
    },
    "AccessGroups": {
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/Accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/AccessGroups"
    },
    "Roles": {
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/Accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/Roles"
    },
    "AccessSchedules": {
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/Accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/AccessSchedules"
    },
    "Zones": {
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/Accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/Zones"
    }
  },
  "AnalyticsId": "9f384787-dd66-4505-ad73-639a8eb160e8",
  "UserId": "6d3c77dc-22a4-4dff-802b-78453035b775",
  "UserName": "alandacosta@gmail.com",
  "Email": "alandacosta@gmail.com",
  "FirstName": "Alan",
  "LastName": "Da Costa",
  "CultureCode": "en",
  "Address": {
    "AddressLine1": "",
    "AddressLine2": "",
    "City": "",
    "PostalCode": "92037",
    "Country": {
      "Code": "USA",
      "IsEEACountry": false,
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/Countries\/USA"
    }
  },
  "TimeZone": {
    "Id": "America\/Los_Angeles",
    "Name": "America\/Los_Angeles"
  },
  "MailingListOptIn": false,
  "RequestAccountLinkInfo": false,
  "Phone": "",
  "DiagnosticDataOptIn": true
}
```



### Device List

**Request**
```
curl -v -X GET -H 'Content-Type: application/json' -H 'SecurityToken: ...' -H 'MyQApplicationId: JVM/G9Nwih5BwKgNCjLxiFUQxQijAebyyg8QUHr7JOrP+tuPb8iHfRHKwTmDzHOu' 'https://api.myqdevice.com/api/v5/Accounts/<account_info_user_id>/Devices'
```

**Response Headers**
```
< HTTP/1.1 200 OK
< Cache-Control: no-cache
< Pragma: no-cache
< Content-Type: application/json; charset=utf-8
< Expires: -1
< MyQ-CorrelationId: a5a9c6f8-4db7-49a1-97a7-1540ca0c12c3
< Request-Context: appId=cid-v1:f384a48e-af08-4025-a4f0-df6df49ee4f4
< Date: Sat, 28 Dec 2019 09:25:35 GMT
< Content-Length: 2118
< Set-Cookie: TS01dfdd0d=0190e2f72d10244e78bfa1d065f4a6ee052b66291812efcddd432f5103bbc729dc6d1c7de12832020a6b72ac9a6dff4d64f5c5e7bc; Path=/; Domain=.api.myqdevice.com
<
* Connection #0 to host api.myqdevice.com left intact
```

**Response**
```
{
  "href": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices",
  "count": 2,
  "items": [
    {
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices\/GW0E0005F3AE",
      "serial_number": "GW0E0005F3AE",
      "device_family": "gateway",
      "device_platform": "myq",
      "device_type": "wifigdogateway",
      "name": "Courchevel 40",
      "created_date": "2018-07-09T02:13:18.7",
      "state": {
        "firmware_version": "3.5",
        "homekit_capable": false,
        "homekit_enabled": false,
        "learn": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices\/GW0E0005F3AE\/learn",
        "learn_mode": false,
        "updated_date": "2019-12-28T09:24:26.417416Z",
        "physical_devices": [
          "CG08600F5352"
        ],
        "pending_bootload_abandoned": false,
        "online": true,
        "last_status": "2019-12-28T09:24:26.417416Z"
      }
    },
    {
      "href": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices\/CG08600F5352",
      "serial_number": "CG08600F5352",
      "device_family": "garagedoor",
      "device_platform": "myq",
      "device_type": "wifigaragedooropener",
      "name": "Garage Door Opener",
      "parent_device": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices\/GW0E0005F3AE",
      "parent_device_id": "GW0E0005F3AE",
      "created_date": "2018-07-09T02:13:18.7",
      "state": {
        "gdo_lock_connected": false,
        "attached_work_light_error_present": false,
        "door_state": "closed",
        "open": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices\/CG08600F5352\/open",
        "close": "http:\/\/api.myqdevice.com\/api\/v5\/accounts\/6d3c77dc-22a4-4dff-802b-78453035b775\/devices\/CG08600F5352\/close",
        "last_update": "2019-12-28T07:57:44.6029407Z",
        "passthrough_interval": "00:00:00",
        "door_ajar_interval": "00:00:00",
        "invalid_credential_window": "00:00:00",
        "invalid_shutout_period": "00:00:00",
        "is_unattended_open_allowed": true,
        "is_unattended_close_allowed": true,
        "aux_relay_delay": "00:00:00",
        "use_aux_relay": false,
        "aux_relay_behavior": "None",
        "rex_fires_door": false,
        "command_channel_report_status": false,
        "control_from_browser": false,
        "report_forced": false,
        "report_ajar": false,
        "max_invalid_attempts": 0,
        "online": true,
        "last_status": "2019-12-28T09:24:26.417416Z"
      }
    }
  ]
}
```




## Errors

### Expired SecurityToken request

Any request which sends a SecurityToken value. The SecurityToken doesn't last long. Maybe 10 minutes?

**Response Headers**
```
< HTTP/1.1 401 Unauthorized
< Cache-Control: no-cache
< Pragma: no-cache
< Content-Type: application/json; charset=utf-8
< Expires: -1
< MyQ-CorrelationId: aa40d042-28b5-4cd9-834c-298bca19309f
< Request-Context: appId=cid-v1:f384a48e-af08-4025-a4f0-df6df49ee4f4
< Date: Sat, 28 Dec 2019 09:12:07 GMT
< Content-Length: 91
< Set-Cookie: TS01dfdd0d=0190e2f72dce190a5581a2c5558617a4850c0b70019a499cb6836e3cf51e7dd96b7222bbb7604e4d90360884e8d67368dd5fe79916; Path=/; Domain=.api.myqdevice.com
<
* Connection #0 to host api.myqdevice.com left intact
```

**Response**
```
{"code":"401.101","message":"Unauthorized","description":"The Security Token has expired."}
```



### Device Action

**Request**
```
curl -v -X PUT -H 'Content-Type: application/json' -H 'SecurityToken: a327a4f1-2773-4557-b3fe-26f8b9c8814a' -H 'MyQApplicationId: JVM/G9Nwih5BwKgNCjLxiFUQxQijAebyyg8QUHr7JOrP+tuPb8iHfRHKwTmDzHOu' -d '{ "action_type": "open" }' 'https://api.myqdevice.com/api/v5/Accounts/6d3c77dc-22a4-4dff-802b-78453035b775/devices/CG08600F5352/actions'
```
where action_type is "open" or "close"
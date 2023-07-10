#!/bin/sh
export V2RAY_LOCATION_ASSET=${V2RAY_GEO_CONFIG}
export V2RAY_LOCATION_CONFIG=${V2RAY_LOCATION_CONFIG}

/usr/bin/v2ray run -c /etc/v2ray/config.json

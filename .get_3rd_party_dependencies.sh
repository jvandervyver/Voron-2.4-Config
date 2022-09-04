#!/usr/bin/env bash

KLIPPER_CONFIG_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ls "${KLIPPER_CONFIG_PATH}"  1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
  echo 'Unable to determine klipper config path'
  exit 1
fi

ls "${KLIPPER_CONFIG_PATH}/3rd-party" 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
  echo 'Creating missing "3rd-party" directory'
  mkdir "${KLIPPER_CONFIG_PATH}/3rd-party"
fi

TEMP_FILE=`mktemp`
if [ $? -ne 0 ]; then
  echo 'Error creating temporary file'
  exit 1
fi
trap '{ rm -f -- "$TEMP_FILE"; }' SIGINT SIGTERM EXIT

wget 'https://github.com/jlas1/Klicky-Probe/blob/main/Klipper_macros/Klipper_macros.zip?raw=true' -O "${TEMP_FILE}"
if [ $? -ne 0 ]; then
  echo 'Could not download latest klipper config'
  exit 1
fi

unzip -d "${KLIPPER_CONFIG_PATH}/3rd-party/Klicky-Probe.new" "${TEMP_FILE}"
if [ $? -ne 0 ]; then
  echo 'Failed to extract Klicky-Probe config'
  rm -rf "${KLIPPER_CONFIG_PATH}/3rd-party/Klicky-Probe.new" 1>/dev/null 2>/dev/null
  exit 1
else
  rm -rf "${KLIPPER_CONFIG_PATH}/3rd-party/Klicky-Probe" 1>/dev/null 2>/dev/null
  mv "${KLIPPER_CONFIG_PATH}/3rd-party/Klicky-Probe.new" "${KLIPPER_CONFIG_PATH}/3rd-party/Klicky-Probe"
fi

ls "${KLIPPER_CONFIG_PATH}/3rd-party/Frix-x" 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
  echo 'Creating missing "Frix-x" directory'
  mkdir "${KLIPPER_CONFIG_PATH}/3rd-party/Frix-x"
fi

rm -f "$TEMP_FILE"
wget 'https://raw.githubusercontent.com/Frix-x/klipper-voron-V2/main/macros/probing/bed_mesh.cfg' -O "${TEMP_FILE}"
if [ $? -ne 0 ]; then
  echo 'Download of Frix-x bed_mesh.cfg failed'
  exit 1
else
  mv "${TEMP_FILE}" "${KLIPPER_CONFIG_PATH}/3rd-party/Frix-x/bed_mesh.cfg"
fi

ls "${KLIPPER_CONFIG_PATH}/3rd-party/revnull" 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
  echo 'Creating missing "revnull" directory'
  mkdir "${KLIPPER_CONFIG_PATH}/3rd-party/revnull"
fi

wget 'https://raw.githubusercontent.com/VoronDesign/VoronUsers/master/firmware_configurations/klipper/revnull/btt_octopus_pins/btt_octopus_pin_aliases.cfg' -O "${TEMP_FILE}"
if [ $? -ne 0 ]; then
  echo 'Download of revnull btt_octopus_pin_aliases.cfg failed'
  exit 1
else 
  mv "${TEMP_FILE}" "${KLIPPER_CONFIG_PATH}/3rd-party/revnull/btt_octopus_pin_aliases.cfg"
fi


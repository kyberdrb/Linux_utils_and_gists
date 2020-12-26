#!/bin/sh

TOUCHPAD_ID=$(xinput list | grep -i touchpad | sed 's/\s\+/_/g' | cut -d'=' -f2 | cut -d'_' -f1)
echo ${TOUCHPAD_ID}

TOUCHPAD_NATURAL_SCROLLING_PROPERTY_ID=$(xinput list-props ${TOUCHPAD_ID} | grep -i "natural scrolling" | grep -v -i "Default" | tr -d ':space:' | cut -d'(' -f2 | cut -d')' -f1)
echo ${TOUCHPAD_NATURAL_SCROLLING_PROPERTY_ID} 

xinput set-prop ${TOUCHPAD_ID} ${TOUCHPAD_NATURAL_SCROLLING_PROPERTY_ID} 1

TOUCHPAD_NATURAL_SCROLLING_PROPERTY_CURRENT_STATUS=$(xinput list-props ${TOUCHPAD_ID} | grep ${TOUCHPAD_NATURAL_SCROLLING_PROPERTY_ID} | tr -d '[:space:]' | cut -d':' -f2)
echo ${TOUCHPAD_NATURAL_SCROLLING_PROPERTY_CURRENT_STATUS}

xinput list-props ${TOUCHPAD_ID} | grep ${TOUCHPAD_NATURAL_SCROLLING_PROPERTY_ID}


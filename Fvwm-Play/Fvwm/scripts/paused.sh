#!/bin/bash

shot=$(scrot 'My_FVWM_%a-%d%b%y_%H.%M.png')
action=$(convert -resize '600x400')


$shot | $action Print.png | feh
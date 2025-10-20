#!/bin/bash

set -e

rm -f $HOME/hlserver/tf2/tf/addons/sourcemod/plugins/nextmap.smx \
	  $HOME/hlserver/tf2/tf/addons/sourcemod/plugins/funcommands.smx \
	  $HOME/hlserver/tf2/tf/addons/sourcemod/plugins/funvotes.smx

rm -rf $HOME/hlserver/tf2/tf/cfg/*
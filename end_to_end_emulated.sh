#!/bin/bash

# start fixflo_emulator.pl (morbo fixflo_emulator.pl) then run this

FIXFLO_DEBUG=1 \
	FIXFLO_ENDTOEND=1 \
	FIXFLO_API_KEY=FixfloAPIKey \
	FIXFLO_URL='http://127.0.0.1:3000' \
	prove -v -Ilib t/002_end_to_end.t

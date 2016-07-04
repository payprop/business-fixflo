#!/bin/bash

# start emulator
morbo fixflo_emulator.pl -l 'http://*:3000' &
sleep 2;

FIXFLO_DEBUG=1 \
	FIXFLO_ENDTOEND=1 \
	FIXFLO_API_KEY=FixfloAPIKey \
	FIXFLO_URL='http://127.0.0.1:3000' \
	FIXFLO_3RD_PARTY_USERNAME=foo@bar.ch \
	FIXFLO_3RD_PARTY_PASSWORD=baz \
	FIXFLO_3RD_PARTY_URL='http://127.0.0.1:3000' \
	prove -v -Ilib t/002_end_to_end.t

# stop emulator
pkill -lf fixflo_emulator.pl;

#!/bin/bash
do cotd.conf.pl;
do cotd-scripts.pl;
# This is the script to select a coupon every day and write it to a file.
# This should be a cronjob run every day.
'
Copyright (c) 2016, Tucker R. Twomey
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Tucker R. Twomey BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
';
chdir $sounds;
$rand = int(rand($numSounds));
format PAD =
@0#####
$rand
.
open(TMP, '+>', undef) or crap("Can't open tempfile: $! !!");
write TMP PAD;
$soundBasename = *TMP;
close(TMP);
$soundfile = `sh -c \'ls | grep $soundBasename\'`;
if($soundfile ~= /.txt/i)
{
  open(TTS, '|espeak -w /tmp/currentSound.wav') or
  crap("Can't call eSpeak!: $!");
  $text = `cat $soundfile`; # Stupid Unportable Hack to read file.
  print TTS $text;
  close(TTS);
  unlink("$sounds/currentSound.ogg");
  system("sox /tmp/currentSound.wav $sounds/currentSound.ogg");
} else #######
{
  unlink("$sounds/currentSound.ogg");
  system("cp $soundfile $sounds/currentSound.ogg"); # Yet Another Stupid Unportable Hack (^)
}
if($reportsounds)
{
  log-m("Daily sound is now: " . $soundfile);
}

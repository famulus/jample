jample
======

Jample lets a muscian rapidly discover and improvise samples from huge harddrives of music.


Jample slices every mp3 on your hardrive in advance, so you can instantly shuffle across huge music libraries searching for dopeness by ear. Samples always load on a beat or note. Once you find a dope sample, you can freeze it and continue to shuffly the remaining pads.







## INSTALL Rails Server for MAC

1) Install Xcode

2) Install homebrew using instructions here: http://brew.sh/

In terminal run the following commands:

2) `brew tap mongodb/brew`

3) `brew install mongodb-community`

4) `ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents`

5) `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist`

6) `cd ~/Documents/`

7) `git clone git@github.com:famulus/jample.git`

8) `cd jample/jample`

9) `sudo gem install bundler`

10) `bundle install`

11) `brew install aubio --with-python`

12) `brew install ffmpeg`

13) `brew install MP3SPLT`

14) `brew install youtube-dl`

15) `rake import_tracks`

16) `rake init`

17) `rails server`

18) download and install pure data extended: https://puredata.info/downloads/pd-extended

TODO: fix hardcoded paths in jample.pd

19) open pure data and setup midi and audio settings

20) Is you midi hardware showing up in pure data?

21) Are you able to hear sound coming from pure data?

22) JAMPLE!


## React Client

In a new terminal run the following commands from the jample folder:

1) `cd jample_react`

2) `npm start`

3) open a brower window, visit http://localhost:3001/

4) JAMPLE!




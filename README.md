jample
======

Jample lets a musician rapidly discover and improvise samples from huge hard-drives of music.


Jample slices every mp3 on your hard-drive in advance, so you can instantly shuffle across huge music libraries searching for dopeness by ear. Samples always load on a beat or note. Once you find a dope sample, you can freeze it and continue to shuffle the remaining pads.







## INSTALL Rails Server for MAC

1) Install Xcode

2) Install homebrew using instructions here: http://brew.sh/

In terminal run the following commands:

2) `brew install postgresql`


5) `brew services start postgresql`

6) `cd ~/Documents/`

7) `git clone git@github.com:famulus/jample.git`

8) `cd jample/jample`

9) `sudo gem install bundler`

10) `bundle install`

11) `brew install aubio`

12) `brew install ffmpeg`

13) `brew install MP3SPLT`

14) `brew install youtube-dl`

15) `rake init`

16) `rake import_tracks`

17) `rails server`


## React Client

In a new terminal run the following commands from the jample folder:

1) `cd jample_react`

2) `npm start`

3) open a brower window, visit http://localhost:3001/

4) JAMPLE!

## Max for Live

1) Setup Max for live plugin in Ableton





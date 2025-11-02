PATCH_DIRECTORY = Rails.root.join('public', 'patch').to_s

MUSIC_DIR = ENV["MUSIC_DIR"] # the music directory from inside the container.
HOST_MUSIC_DIR = ENV["HOST_MUSIC_DIR"] # the same music directory from the mac user.

YOUTUBE_SOURCE_TRACKS = ENV["HOST_MUSIC_DIR"]

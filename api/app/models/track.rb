class Track  < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :mp3_search, against: :mp3_tag


  scope :omit_empty_onsets, -> { 
    where("onset_times != '{}' ").
    # where(track_missing: false)
    where("onset_count > ?", 20).
    where("onset_count IS NOT NULL")

  }
# Track.omit_empty_onsets
  def self.import_tracks
    track_list_string = ''
    # track_list_string = `mdfind -name \.mp3`
    # track_list_string = `find ~/  -name *.mp3`
    # if system("mount|grep /BIG_GUY").present?
    if true
      track_list_string += `find #{SOURCE_TRACKS}  -name *.mp3`
    else
      raise "Main song harddrive missing"
    end
    # debugger
    track_list__wav_string = ''# `find ~/  -name *.wav`
    tracks_array = track_list_string.split("\n")
    tracks_array =  tracks_array + track_list__wav_string.split("\n")

    database_tracks  = Track.pluck :path_and_file

    new_tracks = ( tracks_array - database_tracks )

    # puts tracks_array
    puts "#{tracks_array.size} tracks to check"
    # remove Track records when there is no underlying file
    # missing_files = Track.nin(path_and_file: tracks_array)
    # missing_files.each  do |missing_file|
    #   missing_file.track_missing = true
    #   missing_file.save
    #   puts "Deleted #{missing_file}"
    # end

    new_tracks.each do |track_path|
      begin
        next if track_path.include?('pure_data/tmp/patch') # don't ingest the temporary files
        pn = Pathname.new(track_path)
        unless pn.exist?
          debugger
        end
        file_contents_hash = Digest::MD5.file(track_path).hexdigest # hash the file contents, like a fingerprint

        # debugger
        track = Track.where(file_contents_hash: file_contents_hash).first_or_initialize
        if track.new_record?
          puts "track_path:#{track_path.to_s}"
          track.path_and_file = track_path
          track.save
          track.mp3_data
          track.detect_onset
          # track.detect_beat
          track.save

        else
          # debugger
          puts "re-attaching:#{track_path}"
          track.path_and_file = track_path
          track.track_missing = false
        end
        track.save
      rescue => e
        # debugger
        puts "ERROR re-attaching:#{track.track_name}"
      end
    end
  end





  def self.import_track(file)
    file_contents_hash = Digest::MD5.file(file).hexdigest
    track = Track.where(file_contents_hash: file_contents_hash).first_or_initialize
    puts  "\n\n"
    puts  track.id
    puts  "\n\n"
    escaped_file = Shellwords.escape(file)
    new_file = escaped_file.gsub('wav', 'mp3')
    convert_command = "ffmpeg -y -i #{escaped_file} #{new_file}"
    `#{convert_command}`
    track.path_and_file = new_file
    track.detect_onset
    track.mp3_data
    track.save
    return track
  end




  def number_of_slices
    self.onset_count
  end


  def detect_onset
    if onset_times.blank?
      aubiocut_command = "aubioonset -i \"#{( self.path_and_file )}\""
      puts   "aubiocut_command: #{aubiocut_command}"
      onsets = `#{aubiocut_command}`
      puts "counted #{onsets.size}"
      self.onset_times = onsets.split("\n")
      self.onset_count = onset_times.size
      self.save
    end
  end

  def detect_beat
    if self.onset_times_beat_mode.blank?
      aubiocut_command = "aubio beat -i \"#{( self.path_and_file )}\""
      puts   "aubiocut_command: #{aubiocut_command}"
      puts beats = `#{aubiocut_command}`
      self.onset_times_beat_mode = beats.split("\n")
      self.onset_count_beat_mode = self.onset_times_beat_mode.size
      self.save
    end
  end


  def track_name
    path_and_file.split('/').last
  end

  def escaped_path_and_file
    Shellwords.escape(path_and_file)
  end

  def native_path_name
    return  Shellwords.escape(path_and_file.gsub(SOURCE_TRACKS,SOURCE_TRACKS_NATIVE))
    
  end

  def track_name_pretty
    track_name.gsub('_', ' ')
  end

  def mp3_data
      mp3_data = Mp3Info.open(self.path_and_file)
      self.mp3_data_string = mp3_data.to_s
      mp3_tag = ActiveSupport::HashWithIndifferentAccess.new(mp3_data.tag)
      self.mp3_tag = mp3_tag
      self.title = mp3_tag[:title]
      self.artist = mp3_tag[:artist]
      self.album = mp3_tag[:album]
      self.year = mp3_tag[:year]
      self.genre_s = mp3_tag[:genre_s]
      self.tracknum = mp3_tag[:tracknum]

      self.save
      return mp3_data
  end


end

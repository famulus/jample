include TimeHelpers


class Track
  include Mongoid::Document
  include Mongoid::Timestamps::Created


  field :path_and_file, type: String
  field :file_contents_hash, type: String
  field :onset_times, type: Array
  field :onset_count, type: Integer
  field :track_missing, type: Boolean, default: false
  field :mp3_data_string, type: String



  def self.import_tracks
    # track_list_string = `mdfind -name \.mp3`
    track_list_string = `find ~/  -name *.mp3`
    if system("mount|grep /BIG_GUY")
      track_list_string += `find /Volumes/BIG_GUY/dc_tunez/  -name *.mp3`
    end
    track_list__wav_string = ''# `find ~/  -name *.wav`
    tracks_array = track_list_string.split("\n")
    tracks_array =  tracks_array + track_list__wav_string.split("\n")
    # puts tracks_array
    puts "#{tracks_array.size} tracks to check"

    # remove Track records when there is no underlying file
    missing_files = Track.nin(path_and_file: tracks_array)
    missing_files.each  do |missing_file|
      missing_file.track_missing = true
      missing_file.save
      puts "Deleted #{missing_file}"
    end

    tracks_array.each do |track_path|
      begin
        next if track_path.include?('pure_data/tmp/patch') # don't ingest the temporary files
        file_contents_hash = Digest::MD5.file(track_path).hexdigest # hash the file contents, like a fingerprint
        track = Track.where(file_contents_hash: file_contents_hash).first_or_initialize
        if track.new_record?
          puts "track_path:#{track_path.to_s}"
          track.path_and_file = track_path
          track.mp3_data
          track.detect_onset
          track.save
        end
      rescue
      end
    end
  end


  def number_of_slices
    self.onset_count
  end


  def detect_onset
    if onset_times.blank?
      aubiocut_command = "aubiocut -i \"#{self.path_and_file}\""
      puts onsets = `#{aubiocut_command}`
      self.onset_times = onsets.split("\n")
      self.onset_count = onset_times.size
      self.save
    end
  end


  def track_name
    path_and_file.split('/').last
  end

  def track_name_pretty
    track_name.gsub('_', ' ')
  end

  def mp3_data
    begin
      mp3_data = Mp3Info.open(self.path_and_file)   
      self.mp3_data_string = mp3_data.to_s
      self.save
    rescue 
    end
    return mp3_data
  end


end

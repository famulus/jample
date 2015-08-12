include TimeHelpers


class Track
  include Mongoid::Document
  include Mongoid::Timestamps::Created


  field :path_and_file, type: String
  field :file_contents_hash, type: String
  field :onset_times, type: Array
  field :onset_count, type: Integer



  def self.import_tracks
    # track_list_string = `mdfind -name \.mp3`
    track_list_string = `find ~/  -name *.mp3`
    track_list__wav_string = ''# `find ~/  -name *.wav`
    puts "OKOK"
    tracks_array = track_list_string.split("\n")
    tracks_array =  tracks_array + track_list__wav_string.split("\n")
    puts tracks_array
    puts tracks_array.size

    # return
    # remove Track records when there is no underlying file
    missing_files = Track.nin(path_and_file: tracks_array)
    missing_files.each  do |missing_file|
      missing_file.destroy
    end

    tracks_array.each do |track_path|
      puts "track_path:#{track_path}"
      track_path
      file_contents_hash = Digest::MD5.file(track_path).hexdigest
      track = Track.find_or_create_by(file_contents_hash: file_contents_hash)
      track.path_and_file = track_path
      track.save
      track.detect_onset
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
    Mp3Info.open(self.path_and_file)
    
  end


end

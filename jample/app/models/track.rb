include TimeHelpers


class Track
  include Mongoid::Document


  field :path_and_file, type: String
  field :file_contents_hash, type: String
  field :onset_times, type: Array
  field :onset_count, type: Integer

  has_many :samples


  def self.import_tracks
    # track_list_string = `mdfind -name \.mp3`
  	track_list_string = `find ~/  -name *.mp3`
  	puts "OKOK"
  	# puts track_list
  	tracks_array = track_list_string.split("\n")
  	puts tracks_array.size
    missing_files = Track.nin(path_and_file: tracks_array)
    missing_files.each  do |missing_file|
      missing_file.destroy
    end

  	tracks_array.each do |track_path|
  		 track_path
  		file_contents_hash = Digest::MD5.file(track_path).hexdigest
  		track = Track.find_or_create_by(file_contents_hash: file_contents_hash)
  		track.path_and_file = track_path
  		track.save
  		track.detect_onset
      # track.cut_nth_slice(1) rescue nil
  	end
  end

  def slice_track_at_every_onset_fixed_length(length_in_slice_count)
    puts number_of_slices
    return if number_of_slices.blank?
    number_of_slices.times do |index|
      padded_stop_index = [(index + length_in_slice_count),number_of_slices].min # don't go out of bounds
      sample = Sample.create(
        start_onset_index: index, 
        stop_onset_index: padded_stop_index 
      )
      self.samples << sample

    end
    self.save
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





def self.midi_test

  input = UniMIDI::Input.first
  output = UniMIDI::Output.open(:first)

  @cursor = 0
  input.open do |input|
    $stdout.puts "send some MIDI to your input now..."

    # ids = Track.where(path_and_file: /raw_songs/i ).pluck(:id)
    ids = Track.all.pluck(:id)
    working_set = Sample.in(:track_id => ids)
    puts working_set.inspect

    loop do
      m = input.gets
      $stdout.puts(m)

      if m.first[:data] == [144, 97, 127]
        puts "LEFT"
        @cursor = @cursor - 1

        working_set.page(@cursor).each_with_index do |sample,index|
          sample.cut_sample(index)
        end
        # output.open do |output|
        #   output.puts(144, 82, 127) # note on message
        # end




      end

      if m.first[:data] == [144, 96, 127]
        puts "RIGHT"
        @cursor = @cursor + 1
        working_set.page(@cursor).each_with_index do |sample,index|
          sample.cut_sample(index)
        end
      end

      if m.first[:data] == [144, 95, 127]
        puts "DOWN"
        @cursor = random_page = (0.. (working_set.count/16).to_i).to_a.sample
        working_set.page(random_page).each_with_index do |sample,index|
          sample.cut_sample(index)
        end
      end

    end
  end

  
end

end

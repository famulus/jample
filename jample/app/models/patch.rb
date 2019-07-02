  include TimeHelpers

  #ONSET_MODE = :beat
  ONSET_MODE =  :onset

  NUDGE_MILLISEC =  8

  class Patch
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    field :patch_index, type: Integer
    field :track_id, type: String
    field :patch_set_id, type: String
    field :start_onset_index, type: Integer
    field :stop_onset_index, type: Integer
    field :start_onset_time, type: String
    field :stop_onset_time, type: String
    field :voiced_count, type: Integer
    field :volume, type: Float
    field :frozen, type: String, default: false

    belongs_to :track, index: true
    belongs_to :patch_set, index: true

    index({ track_id: 1,patch_set_id: 1, start_onset_index: 1, stop_onset_index: 1 }, { unique: false, drop_dups: false })
    # time = Benchmark.measure do
    # end ; puts "\n\n\n BENCHMARK \n\n\n#{time}\n\n\n BENCHMARK \n\n\n"



    def as_json(options)
      super(options.merge({methods: [:start_onset_time,:stop_onset_time]}))
    end




    def randomize_patch(subset_of_track_ids)

      return if self.is_frozen?
      
      duration_in_slices = 12
      
      while  # if the track has too few samples, randomly pick another track, until a suitable track is found
        track_id = subset_of_track_ids.shuffle.first
        self.track = Track.find(track_id.to_s)
        break if (self.onset_mode.size > (duration_in_slices + 1))
      end
      track_onset_array = self.onset_mode
      max_start_index = track_onset_array.size - duration_in_slices # figure out the max starting index that won't go out of bounds
      self.start_onset_index = rand(0...max_start_index) # pick a random starting index
      self.stop_onset_index = [(self.start_onset_index + duration_in_slices), (track_onset_array.size - 1)].min
      self.refresh_onset_times()
      self.save
      self.cut_sample(self.patch_index)
    end


    def duration
      duration = sec_dot_milli_to_milli(stop_onset_time) - sec_dot_milli_to_milli(start_onset_time) 
      return duration
    end

    def onset_mode
      case ONSET_MODE
      when :beat
        return self.track.onset_times_beat_mode
      when :onset
        return self.track.onset_times
      end
      
    end


    def refresh_onset_times
      self.start_onset_time = self.onset_mode[self.start_onset_index]
      self.stop_onset_time = self.onset_mode[self.stop_onset_index]
      self.save
    end

    def grow_patch_by_one_on_the_end
        self.stop_onset_index += 1
        self.save
        self.refresh_onset_times()
        self.cut_sample(self.patch_index)
    end
   
    def shrink_patch_by_one_on_the_end
        self.stop_onset_index -= 1
        self.save
        self.refresh_onset_times()
        self.cut_sample(self.patch_index)
    end

    def shift_sample_forward_one_slice
        self.start_onset_index += 1
        self.stop_onset_index += 1
        self.save
        self.refresh_onset_times()
        self.cut_sample(self.patch_index)
    end 

    def shift_sample_backward_one_slice
        self.start_onset_index -= 1
        self.stop_onset_index -= 1
        self.save
        self.refresh_onset_times()
        self.cut_sample(self.patch_index)
    end 
    def nudge_sample_start_forward_milliseconds
        self.start_onset_time = (self.start_onset_time.to_d + (NUDGE_MILLISEC / 1000.0).round(4))
        self.save
        self.cut_sample(self.patch_index)
    end 
    def nudge_sample_start_backward_milliseconds
        self.start_onset_time = (self.start_onset_time.to_d - (NUDGE_MILLISEC / 1000.0).round(4))
        self.save
        self.cut_sample(self.patch_index)
    end 

    def copy_patch(desired_patch)
      desired_patch_object = Patch.where(patch_index: (desired_patch -1) ).first
      self.track = desired_patch_object.track
      self.start_onset_index = desired_patch_object.start_onset_index
      self.start_onset_index = desired_patch_object.start_onset_index
      self.stop_onset_index = desired_patch_object.stop_onset_index
      self.save
      self.cut_sample(self.patch_index)
    end

    def cut_sample(pad)
      valid_sample?
      pad_name = "pad_#{pad}"
      puts "OKOK"
      puts self.patch_index
      puts "OKOK"
      # Thread.new do 
         "-------------------------SPLIT-------------------------------\n\n\n"
         mp3split_command = "mp3splt -d #{PATCH_DIRECTORY} -o #{pad_name} #{self.track.escaped_path_and_file} #{convert_time_format(self.start_onset_time)} #{convert_time_format(self.stop_onset_time)}"
         puts mp3split_command
         convert_format_command = "ffmpeg -y -i #{File.join(PATCH_DIRECTORY, pad_name+'.mp3')}  -ac 2 #{File.join(PATCH_DIRECTORY, pad_name+'.wav')}"
        `#{mp3split_command}`
        `#{convert_format_command}`
      # end
    end



    def is_frozen?
      self.frozen == "true" || false
    end


    def valid_sample?
      begin
       raise "invalid patch: #{self.to_s}, missing track" unless self.track.present? 
       raise "invalid patch: #{self.to_s}, missing track.onset_times" unless self.onset_mode.present?
       raise "invalid patch: #{self.to_s}, missing start_onset_index" unless self.start_onset_index.present? 
       raise "invalid patch: #{self.to_s}, missing stop_onset_index" unless self.stop_onset_index.present?
       raise "invalid patch: #{self.to_s}, missing stop_onset_time" unless self.stop_onset_time.present?
       raise "invalid patch: #{self.to_s}, missing start_onset_time" unless self.start_onset_time.present?
     rescue Exception => e
      debugger
      raise e
     end
     return true
    end




  end

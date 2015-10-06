  include TimeHelpers
  include Settings


  class Patch
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    field :patch_index, type: Integer
    field :track_id, type: String
    field :patch_set_id, type: String

    field :start_onset_index, type: Integer
    field :stop_onset_index, type: Integer

    field :voiced_count, type: Integer
    
    field :volume, type: Float


    belongs_to :track
    belongs_to :patch_set

    index({ track_id: 1,patch_set_id: 1, start_onset_index: 1, stop_onset_index: 1 }, { unique: true, drop_dups: true })




    def randomize_patch
      subset_of_track_ids = CurrentPatch.get_current_filter_set
      track_id = subset_of_track_ids.shuffle.first
      self.track = Track.find(track_id.to_s)
    	duration_in_slices = 10
    	track_onset_array = self.track.onset_times
      self.randomize_patch if (track_onset_array.size <= (duration_in_slices+1))
    	usable_onset_times = track_onset_array[0..(track_onset_array.size - duration_in_slices)]
    	self.start_onset_index =self.track.onset_times.index( usable_onset_times.shuffle.first)
    	self.stop_onset_index = [(self.start_onset_index + duration_in_slices), (self.track.onset_times.size - 1)].min
    	self.save
  		self.cut_sample(self.patch_index)
    	
    end

    def start_onset_time
      self.valid_sample?
      start_onset_time = self.track.onset_times[self.start_onset_index]
    end

    def stop_onset_time
      self.valid_sample?
      begin
        raise "stop_onset_time out of range" if self.stop_onset_index >= self.track.onset_times.size
      rescue
        # debugger
      end
        self.track.onset_times[self.stop_onset_index]
    end

    def duration
      valid_sample?
      duration = sec_dot_milli_to_milli(stop_onset_time) - sec_dot_milli_to_milli(start_onset_time) 
      return duration
    end




    def grow_patch_by_one_on_the_end
    		self.stop_onset_index += 1
    		self.save
    		self.cut_sample(self.patch_index)
    end
   
    def shrink_patch_by_one_on_the_end
    		self.stop_onset_index -= 1
    		self.save
    		self.cut_sample(self.patch_index)
    end

    def shift_sample_forward_one_slice
    		self.start_onset_index += 1
    		self.stop_onset_index += 1
    		self.save
    		self.cut_sample(self.patch_index)
    		
  	end	

    def shift_sample_backward_one_slice
    		self.start_onset_index -= 1
    		self.stop_onset_index -= 1
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
      # Thread.new do 
        puts "-------------------------SPLIT-------------------------------\n\n\n"
        puts mp3split_command = "mp3splt -d #{PATCH_DIRECTORY} -o #{pad_name} \"#{self.track.path_and_file}\" #{convert_time_format(self.start_onset_time)} #{convert_time_format(self.stop_onset_time)}"
        `#{mp3split_command}`
        puts "-------------------------TO WAV-------------------------------\n\n\n"
        puts convert_format_command = "ffmpeg -y -i #{File.join(PATCH_DIRECTORY, pad_name+'.mp3')}  -ac 2 #{File.join(PATCH_DIRECTORY, pad_name+'.wav')}"
        `#{convert_format_command}`
      # end



    end






    def valid_sample?
      puts "OKOK #{self.to_a}"
       raise "invalid patch: #{self.to_s}, missing start_onset_index" unless self.start_onset_index.present? 
       raise "invalid patch: #{self.to_s}, missing track" unless self.track.present? 
       raise "invalid patch: #{self.to_s}, missing track.onset_times" unless self.track.onset_times.present?
       raise "invalid patch: #{self.to_s}, missing start_onset_index" unless self.start_onset_index.present?
       raise "invalid patch: #{self.to_s}, missing stop_onset_index" unless self.stop_onset_index.present?


       return true
    end




  end

class Voice  
  DURATION_IN_SLICES = 12
  include TimeHelpers

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :max_for_live_voice_id, type: String
  field :current_audition_id, type: String
  field :previous_audition_id, type: String
  field :next_audition_id, type: String

  has_many :auditions, {:dependent => :destroy}
  belongs_to :current_audition, {:class_name => "Audition"}
  has_one :previous_audition, {:class_name => "Audition"}
  has_one :next_audition, {:class_name => "Audition"}



  field :track_id, type: Integer
  field :start_onset_index, type: Integer
  field :stop_onset_index, type: Integer
  field :start_onset_time, type: String
  field :stop_onset_time, type: String
  field :voiced_count, type: Integer


  def randomize_voice(subset_of_track_ids)
    track_id = subset_of_track_ids.shuffle.first

    # remember for undo
    self.current_audition = current_audition  = self.auditions.create({
      voice_id: self.id,
      track_id: track_id,
    })


    track = Track.find(track_id.to_s)
    track_onset_array = track.onset_times
    track_path = track.escaped_path_and_file
    max_start_index = track_onset_array.size - DURATION_IN_SLICES # figure out the max starting index that won't go out of bounds
    current_audition.start_onset_index = rand(0...max_start_index) # pick a random starting index
    # debugger if (current_audition.start_onset_index == nil)
    current_audition.stop_onset_index = [(current_audition.start_onset_index + DURATION_IN_SLICES), (track_onset_array.size - 1)].min

    current_audition.start_onset_time = track.onset_times[current_audition.start_onset_index]
    current_audition.stop_onset_time = track.onset_times[current_audition.stop_onset_index]
    # debugger if current_audition.stop_onset_time.to_i < 1
    current_audition.save
    self.save 
    response = self.return_voice_hash()
    ap response
    return response
  end


  # def get_slice
  #   current_audition = self.current_audition
  #   response = self.return_voice_hash()
  #   ap response
  #   return response

  # end

  def back_one_audition
    current_audition = self.auditions.where(:created_at.lt => (self.current_audition.created_at)).order(created_at: :desc).first
    if current_audition.present?
      self.current_audition = current_audition
      self.save
      response = self.return_voice_hash()
      ap response
      return response

    end
    
  end


  def forward_one_audition
    current_audition = self.auditions.where(:created_at.gt => (self.current_audition.created_at)).order(created_at: :asc).first
    if current_audition.present?
      self.current_audition = current_audition
      self.save
      response = self.return_voice_hash()
      ap response
      return response
    end
    
  end


  def return_voice_hash
    current_audition = self.current_audition
    response = {
      track_id: current_audition.track.id.to_s,
      track_path: current_audition.track.escaped_path_and_file,
      title: current_audition.track.title || "NA",
      artist: current_audition.track.artist || "NA",
      album: current_audition.track.album || "NA",
      year: current_audition.track.year || "NA",
      start_onset_index: current_audition.start_onset_index,
      stop_onset_index: current_audition.stop_onset_index,
      start: sec_dot_milli_to_milli(current_audition.start_onset_time), 
      duration: (self.duration ) ,

    }.merge(self.sample_modification_links())

    
  end


  def to_json
    # debugger #if self.duration < 0
    return self.return_voice_hash
  end



  def duration
    duration = (sec_dot_milli_to_milli(self.current_audition.stop_onset_time) - sec_dot_milli_to_milli(self.current_audition.start_onset_time) ).round(5)
    return duration
  end


  def sample_modification_links
    current_audition = self.current_audition

    shift_slice_forward_one_index = {
      start_onset_index: current_audition.start_onset_index+1,
      stop_onset_index: current_audition.stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{current_audition.track_id}/#{current_audition.start_onset_index+1}/#{current_audition.stop_onset_index+1}",
    }

    shift_slice_backward_one_index = {
      start_onset_index: current_audition.start_onset_index-1,
      stop_onset_index: current_audition.stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{current_audition.track_id}/#{current_audition.start_onset_index-1}/#{current_audition.stop_onset_index-1}",
    }

    grow_by_one_index = {
      start_onset_index: current_audition.start_onset_index,
      stop_onset_index: current_audition.stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{current_audition.track_id}/#{current_audition.start_onset_index}/#{current_audition.stop_onset_index+1}",
    }

    shrink_by_one_index = {
      start_onset_index: current_audition.start_onset_index,
      stop_onset_index: current_audition.stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{current_audition.track_id}/#{current_audition.start_onset_index}/#{current_audition.stop_onset_index-1}",
    }

    return_hash = {        
      shift_slice_forward_one_index: shift_slice_forward_one_index,
      shift_slice_backward_one_index: shift_slice_backward_one_index,
      grow_by_one_index: grow_by_one_index,
      shrink_by_one_index: shrink_by_one_index,
   } 
  end




end
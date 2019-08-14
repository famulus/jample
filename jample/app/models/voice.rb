class Voice  
  include TimeHelpers

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :max_for_live_voice_id, type: String
  field :current_audition_id, type: String
  field :previous_audition_id, type: String
  field :next_audition_id, type: String

  has_many :auditions, {:dependent => :destroy}
  has_one :current_audition, {:class_name => "Audition"}
  has_one :previous_audition, {:class_name => "Audition"}
  has_one :next_audition, {:class_name => "Audition"}


  def randomize_voice(subset_of_track_ids)



    duration_in_slices = 12
    track_id = subset_of_track_ids.shuffle.first


    # remember for undo
    current_audition  = self.auditions.create({
      voice_id: self.id,
      track_id: track_id,
    })

    self.current_audition = current_audition

    track = Track.find(track_id.to_s)
    track_onset_array = track.onset_times
    track_path = track.escaped_path_and_file
    track_onset_array = track.onset_times
    max_start_index = track_onset_array.size - duration_in_slices # figure out the max starting index that won't go out of bounds
    current_audition.start_onset_index = rand(0...max_start_index) # pick a random starting index
    debugger if (current_audition.start_onset_index == nil)
    current_audition.stop_onset_index = [(current_audition.start_onset_index + duration_in_slices), (track_onset_array.size - 1)].min

    current_audition.start_onset_time = track.onset_times[current_audition.start_onset_index]
    current_audition.stop_onset_time = track.onset_times[current_audition.stop_onset_index]
    debugger if current_audition.stop_onset_time.to_i < 1
    duration = (sec_dot_milli_to_milli(current_audition.stop_onset_time) - sec_dot_milli_to_milli(current_audition.start_onset_time) ).round(5)


    shift_slice_forward_one_index = {
      start_onset_index: current_audition.start_onset_index+1,
      stop_onset_index: current_audition.stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{track_id}/#{current_audition.start_onset_index+1}/#{current_audition.stop_onset_index+1}",
    }

    shift_slice_backward_one_index = {
      start_onset_index: current_audition.start_onset_index-1,
      stop_onset_index: current_audition.stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{track_id}/#{current_audition.start_onset_index-1}/#{current_audition.stop_onset_index-1}",

    }
    grow_by_one_index = {
      start_onset_index: current_audition.start_onset_index,
      stop_onset_index: current_audition.stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{track_id}/#{current_audition.start_onset_index}/#{current_audition.stop_onset_index+1}",
    }

    shrink_by_one_index = {
      start_onset_index: current_audition.start_onset_index,
      stop_onset_index: current_audition.stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{track_id}/#{current_audition.start_onset_index}/#{current_audition.stop_onset_index-1}",

    }

    self.save 


    # debugger #if self.duration < 0
    response = {
      track_id: current_audition.track.id.to_s,
      track_path: track_path,
      title: current_audition.track.title || "NA",
      artist: current_audition.track.artist || "NA",
      album: current_audition.track.album || "NA",
      year: current_audition.track.year || "NA",
      start_onset_index: current_audition.start_onset_index,
      stop_onset_index: current_audition.stop_onset_index,
      start: sec_dot_milli_to_milli(current_audition.start_onset_time), 
      duration: (duration ) ,
      shift_slice_forward_one_index: shift_slice_forward_one_index,
      shift_slice_backward_one_index: shift_slice_backward_one_index,
      grow_by_one_index: grow_by_one_index,
      shrink_by_one_index: shrink_by_one_index,

    }

    ap response
    return response
  end







  def to_json

    if self.stop_onset_time.present?
    duration = (sec_dot_milli_to_milli(self.stop_onset_time) - sec_dot_milli_to_milli(self.start_onset_time) ).round(5)
    end

    shift_slice_forward_one_index = {
      start_onset_index: start_onset_index+1,
      stop_onset_index: stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index+1}/#{stop_onset_index+1}",
    }

    shift_slice_backward_one_index = {
      start_onset_index: start_onset_index-1,
      stop_onset_index: stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index-1}/#{stop_onset_index-1}",

    }
    grow_by_one_index = {
      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index+1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index}/#{stop_onset_index+1}",
    }

    shrink_by_one_index = {
      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index-1,
      url: "get http://localhost:3000/get_slice/#{self.max_for_live_voice_id}/#{self.track_id}/#{start_onset_index}/#{stop_onset_index-1}",

    }


    # debugger #if self.duration < 0
    return {
      track_id: self.track.id.to_s,
      track_path: self.track.escaped_path_and_file,
      title: self.track.title,
      artist: self.track.artist,
      album: self.track.album,
      year: self.track.year,

      start_onset_index: start_onset_index,
      stop_onset_index: stop_onset_index,
      start: sec_dot_milli_to_milli(self.start_onset_time), 
      duration: (duration ) ,
      shift_slice_forward_one_index: shift_slice_forward_one_index,
      shift_slice_backward_one_index: shift_slice_backward_one_index,
      grow_by_one_index: grow_by_one_index,
      shrink_by_one_index: shrink_by_one_index,

    }
  end


end
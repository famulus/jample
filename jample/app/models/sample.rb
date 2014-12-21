include TimeHelpers


class Sample
  include Mongoid::Document


  field :track_id, type: String
  field :start_onset_index, type: Integer
  field :stop_onset_index, type: Integer
  field :duration, type: Float

  belongs_to :track


  # what makes a sample unique? 


  def start_onset_time
    return nil unless self.start_onset_index.present? && self.track.present? && self.track.onset_times.present?
    start_onset_time = self.track.onset_times[self.start_onset_index]
  end

  def stop_onset_time
    return nil unless self.stop_onset_index.present? && self.track.present? && self.track.onset_times.present?
    stop_onset_time = self.track.onset_times[self.stop_onset_index]
  end




end

class DurationIndex
  include TimeHelpers

  field :track_id, type: String
  field :start_onset_index, type: Integer
  field :stop_onset_index, type: Integer
  field :duration, type: Float
  index ({duration: 1})

  belongs_to :track


  def self.populate
    tracks = Track.all
    tracks.each do |track|
      track.onset_times.each_with_index do |onset,index|
        duration = track.onset_times[index+1].to_f - onset.to_f
        next if (duration < 0)
        begin
          DurationIndex.create({track_id: track.id, start_onset_index: index,duration: duration })
        rescue Exception => e
          next            
        end
      end
    end
  end



end
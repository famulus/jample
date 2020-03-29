class JampleController < ApplicationController


  def index
    self.props_hash
  end



  def props_hash
    @current_patch = CurrentPatch.get_current_patch
    @patch_set = CurrentPatch.get_current_patch_set
    @current_filter = CurrentPatch.last.subset_search_string
    @named_patch_sets = PatchSet.where(:patch_set_label.ne => "", :patch_set_label.exists => true).reverse
    @current_filter_size = CurrentPatch.get_current_filter_set.size
    @recent_filters = FilterHistory.all.desc('_id').limit(20).uniq{|s|s.filter_value}[(0...4)]
    # byebug

    @props_hash = {
      current_patch: @current_patch,
      patch_set: @patch_set.as_json({include:
        {patches: {include:
          {track: {methods: [:track_name_pretty ], :except => [:onset_times,:mp3_data_string]}}, methods: [:start_onset_time,:stop_onset_time]}},
        methods: [:next_patch_set,:previous_patch_set]
      }),
      track_set: @patch_set.patches.map{|p|p.track.as_json(:except => [:onset_times,:mp3_data_string],methods: [:track_name_pretty])},
      mp3_set: @patch_set.patches.map{|p|p.track.mp3_data.tag rescue {}},
      current_filter: @current_filter,
      named_patch_sets: @named_patch_sets,
      current_filter_size: @current_filter_size,
      recent_filters: @recent_filters
    }
  end



  def randomize_voice
    voice = Voice.find_or_create_by({max_for_live_voice_id: params[:id]})
    subset_of_track_ids = CurrentPatch.get_current_filter_set
    voice_specifier = voice.randomize_voice(subset_of_track_ids)
    render(json: voice_specifier)
  end




  def voice
    voice = Voice.find_or_create_by({max_for_live_voice_id: params[:id]})
    current_audition = voice.current_audition
    if(current_audition.blank? || current_audition.start_onset_index.blank?)
      render(json: {})
      return
    end
    render(json: voice.to_json)
  end




  def mp3tag
    track_id = params[:track_id]
    if track_id.present?
      track = Track.find(track_id.to_s)
    end
    # Is this being used?
    slice_id = params[:slice_id]
    Mp3Info.open("/Volumes/BIG_GUY/jample_slices/slice_#{slice_id}.wav") do |mp3|
      puts mp3.tag.title
      puts mp3.tag.artist
      puts mp3.tag.album
      puts mp3.tag.tracknum
      mp3.tag.title = "track title"
      mp3.tag.artist = "artist name"
    end
  end



  def get_slice
    voice = Voice.find_or_create_by({max_for_live_voice_id: params[:voice]})
    current_audition = voice.current_audition
    track_id = params[:track_id]

    if track_id.present?
      track = Track.find(track_id.to_s)
      current_audition.start_onset_index = params[:start_onset_index].to_i
      current_audition.stop_onset_index = params[:stop_onset_index].to_i
      track_onset_array = track.onset_times
      current_audition.start_onset_time = track_onset_array[current_audition.start_onset_index]
      current_audition.stop_onset_time = track_onset_array[current_audition.stop_onset_index]

      current_audition.save
      voice.save
    end
    response = voice.return_voice_hash
    ap response
    render(json: response)
  end


  def youtube_dl
    youtube_id = params[:youtube_id]
    file = "#{YOUTUBE_SOURCE_TRACKS}/video_#{youtube_id}.wav"
    yt_video_info = YoutubeDL.download(
      youtube_id ,
      {output: file,
       "extract-audio" => true,
       "audio-quality" => 0,
       "audio-format" => "wav",
     # xattrs: true,
    })
    puts "\n\n"
    puts "PAST DOWNLOAD"
    puts "\n\n"
    track = Track.import_track(file)
    track.title = yt_video_info.information[:track] || yt_video_info.information[:title]
    track.artist = yt_video_info.information[:artist] || yt_video_info.information[:description]
    track.album = yt_video_info.information[:album]
    track.youtube_url = yt_video_info.information[:webpage_url]
    track.youtube_data = yt_video_info.information
    track.save
    cp = CurrentPatch.last
    cp.subset_search_string = track.id
    cp.subset_search_string = '' if params[:filter_text]=="*"
    # byebug
    cp.save
    FilterHistory.create({filter_value: cp.subset_search_string })
    puts "filter set to: #{cp.subset_search_string}"
    @current_filter = CurrentPatch.last.subset_search_string
    @current_filter_size = CurrentPatch.get_current_filter_set.size
    render(json: {})
  end


  def recycle
    track_path = params[:track_path]
    # file = "#{YOUTUBE_SOURCE_TRACKS}/video_#{youtube_id}.wav"
    track_path = '/Volumes/BIG_GUY/recycled/keyCode.aif'
    track = Track.import_track(track_path)
    track.title = 'recycled04'
    track.artist = 'facesvases'
    # track.album = yt_video_info.information[:album]
    # track.youtube_url = yt_video_info.information[:webpage_url]
    # track.youtube_data = yt_video_info.information
    track.save
    cp = CurrentPatch.last
    cp.subset_search_string = track.id
    cp.subset_search_string = '' if params[:filter_text]=="*"
    # byebug
    cp.save
    FilterHistory.create({filter_value: cp.subset_search_string })
    puts "filter set to: #{cp.subset_search_string}"
    @current_filter = CurrentPatch.last.subset_search_string
    @current_filter_size = CurrentPatch.get_current_filter_set.size
    render(json: {})
  end


  def back_one_audition
    voice = Voice.find_or_create_by({max_for_live_voice_id: params[:voice]})
    response = voice.back_one_audition()
    render(json: response)
  end


  def forward_one_audition
    voice = Voice.find_or_create_by({max_for_live_voice_id: params[:voice]})
    response = voice.forward_one_audition()
    render(json: response)
  end

  # orders tracks by "most recent", limit 15
  def get_recent_tracks
    tracks = Track.order(created_at: :desc).limit(15)
    # debugger
    render(json: tracks)
  end


  def set_filter
    cp = CurrentPatch.last
    cp.subset_search_string = params[:filter_text]
    cp.subset_search_string = '' if params[:filter_text]=="*"
    # byebug
    cp.save
    # FilterHistory.create({filter_value: cp.subset_search_string })

    puts "filter set to: #{cp.subset_search_string}"
    @current_filter = CurrentPatch.last.subset_search_string
    @current_filter_size = CurrentPatch.get_current_filter_set.size
    # byebug
    @filter_set_tracks = CurrentPatch.get_current_filter_set[0..15].map{|track_id| Track.find(track_id)}
    render(json: {current_filter: @current_filter, current_filter_size: @current_filter_size, filter_set_tracks: @filter_set_tracks})
  end


end

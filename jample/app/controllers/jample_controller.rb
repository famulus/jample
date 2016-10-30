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
    # debugger

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

  def track_alias
    self.track.as_json
  end

  def reset
    cp = CurrentPatch.last
    cp.patch_set_id = PatchSet.last.id
    cp.subset_search_string = ''
    cp.save
    CurrentPatch.set_current_patch(0)
    render(json: self.props_hash)
  end

  def init_16_patches
    PatchSet.init_16_patches()
    render(json: self.props_hash)
  end

  def init_16_patches_as_sequence
    PatchSet.init_16_patches_as_sequence()
    render(json: self.props_hash)
  end

  def init_16_patches_as_duration_sequence
    PatchSet.init_16_patches_as_duration_sequence()
    render(json: self.props_hash)
  end

  def expand_single_patch_to_sequence
    PatchSet.expand_single_patch_to_sequence()
    render(json: self.props_hash)
  end

  def set_current_patch
    patch_index = params[:id].to_i  # this converts the midi number to the pad index number
    CurrentPatch.set_current_patch(patch_index)
    puts "new index: #{patch_index}"
    render(json: {})
  end
  
  def set_current_patch_set
    patch_set = PatchSet.find(params[:patch_id])
    CurrentPatch.set_current_patch_set(patch_set)
    PatchSet.cut_current_patch_set
    PatchSet.reload_pure_data()
    render(json: self.props_hash)
  end

  def duplicate_patch_set
    cp = CurrentPatch.get_current_patch_set
    cp.duplicate_patch_set
    render(json: self.props_hash)
  end

  def randomize_current_patch
    cp = CurrentPatch.get_current_patch
    cp.randomize_patch
    PatchSet.reload_pure_data()
    puts "randomize_patch: #{cp.patch_index}"
    render(json: self.props_hash)
  end

  def freeze_patch
    patch = Patch.find(params[:id])
    patch.frozen = params[:checkbox_status] 
    patch.save
    render(json: self.props_hash)
  end

  def shuffle_unfrozen
    PatchSet.shuffle_unfrozen  
    PatchSet.reload_pure_data()
    render(json: self.props_hash)
  end

  def set_filter
    cp = CurrentPatch.last
    cp.subset_search_string = params[:filter_text]
    cp.subset_search_string = '' if params[:filter_text]=="*"
    # debugger
    cp.save
    FilterHistory.create({filter_value: cp.subset_search_string })

    puts "filter set to: #{cp.subset_search_string}"
    @current_filter = CurrentPatch.last.subset_search_string
    @current_filter_size = CurrentPatch.get_current_filter_set.size

    render(json: {current_filter: @current_filter, current_filter_size: @current_filter_size})
  end

  def set_current_patch_set_name
    cps = CurrentPatch.get_current_patch_set
    cps.patch_set_label = params[:current_patch_set_name]
    cps.save
    render(json: self.props_hash)
  end

  def shrink_patch_by_one_on_the_end
    CurrentPatch.get_current_patch.shrink_patch_by_one_on_the_end
    PatchSet.reload_pure_data()
    render(json: self.props_hash)
  end

  def grow_patch_by_one_on_the_end
    CurrentPatch.get_current_patch.grow_patch_by_one_on_the_end
    PatchSet.reload_pure_data()
    render(json: {})
  end


  def shift_sample_backward_one_slice
    CurrentPatch.get_current_patch.shift_sample_backward_one_slice
    PatchSet.reload_pure_data()
    render(json: self.props_hash)
  end

  def shift_sample_forward_one_slice
    CurrentPatch.get_current_patch.shift_sample_forward_one_slice
    PatchSet.reload_pure_data()
    render(json: self.props_hash)
  end

  def set_volume
    cp =CurrentPatch.get_current_patch
    cp.volume = params[:volume].to_f / 127
    cp.save
    render nothing:true
  end

  def all_patchsets
    @all_patch_sets = PatchSet.all.order_by(:created_at => 'desc').group_by{|p|p.created_at.to_date}
  end

  def all_tracks
    @all_tracks = Track.all
  end

end

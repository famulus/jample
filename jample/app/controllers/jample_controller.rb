class JampleController < ApplicationController

	def index
		@current_patch = CurrentPatch.get_current_patch
		@patch_set = CurrentPatch.get_current_patch_set
		@current_filter = CurrentPatch.last.subset_search_string
		@named_patch_sets = PatchSet.where(:patch_set_label.ne => "", :patch_set_label.exists => true).reverse

    @subset_of_tracks = CurrentPatch.get_current_filter_set

	end



	def init_16_patches
		PatchSet.init_16_patches()
		redirect_to '/'
	end

	def init_16_patches_as_sequence
		PatchSet.init_16_patches_as_sequence()
		redirect_to '/'
	end

	def set_current_patch
		patch_index = params[:id].to_i - 35 # this converts the midi number to the pad index number
		CurrentPatch.set_current_patch(patch_index)
		puts "new index: #{patch_index}"
		redirect_to '/'
	end
	
	def set_current_patch_set
		patch_set = PatchSet.find(params[:id])
		CurrentPatch.set_current_patch_set(patch_set)
		PatchSet.cut_current_patch_set
		redirect_to '/'
	end


	def randomize_current_patch
		cp = CurrentPatch.get_current_patch
		cp.randomize_patch
		PatchSet.reload_pure_data()
		puts "randomize_patch: #{cp.patch_index}"
		redirect_to '/'
	end


	def set_filter
		cp = CurrentPatch.last
		cp.subset_search_string = params[:filter_text]
		cp.subset_search_string = '' if params[:filter_text]=="*"

		cp.save
		puts "filter set to: #{cp.subset_search_string}"
		redirect_to '/'
	end

	def set_current_patch_set_name
		cps = CurrentPatch.get_current_patch_set
		cps.patch_set_label = params[:current_patch_set_name]
		cps.save
		redirect_to '/'

	end

	def shrink_patch_by_one_on_the_end
		CurrentPatch.get_current_patch.shrink_patch_by_one_on_the_end
		
		redirect_to '/'
	end

	def grow_patch_by_one_on_the_end
		CurrentPatch.get_current_patch.grow_patch_by_one_on_the_end
		redirect_to '/'
	end


	def shift_sample_backward_one_slice
		CurrentPatch.get_current_patch.shift_sample_backward_one_slice
		redirect_to '/'
	end

	def shift_sample_forward_one_slice
		CurrentPatch.get_current_patch.shift_sample_forward_one_slice
		redirect_to '/'
	end

	def set_volume
		cp =CurrentPatch.get_current_patch
		cp.volume = params[:volume].to_f / 127
		cp.save
		render nothing:true
	end


end

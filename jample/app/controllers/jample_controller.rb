class JampleController < ApplicationController
	def index
	end


	def set_current_patch
		patch_index = params[:id].to_i - 35
		CurrentPatch.set_current_patch(patch_index)
		puts "new index: #{patch_index}"
		render nothing:true
	end
	def randomize_current_patch
		cp = CurrentPatch.get_current_patch
		cp.randomize_patch
		puts "randomize_patch: #{cp.patch_index}"
		render nothing:true
	end
	def set_filter
		cp = CurrentPatch.last
		cp.subset_search_string = params[:filter_text]
		cp.subset_search_string = '' if params[:filter_text]=="*"

		cp.save
		puts "filter set to: #{cp.subset_search_string}"
		render nothing:true
	end

	def shrink_patch_by_one_on_the_end
		CurrentPatch.get_current_patch.shrink_patch_by_one_on_the_end
		render nothing:true
	end

	def grow_patch_by_one_on_the_end
		CurrentPatch.get_current_patch.grow_patch_by_one_on_the_end
		render nothing:true
	end
	def shift_sample_backward_one_slice
		CurrentPatch.get_current_patch.shift_sample_backward_one_slice
		render nothing:true
	end

	def shift_sample_forward_one_slice
		CurrentPatch.get_current_patch.shift_sample_forward_one_slice
		render nothing:true
	end

	def set_volume
		cp =CurrentPatch.get_current_patch
		cp.volume = params[:volume].to_f / 127
		cp.save
		render nothing:true
	end


end

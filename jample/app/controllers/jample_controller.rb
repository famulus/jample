class JampleController < ApplicationController

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
		cp.save
		puts "filter set to: #{cp.subset_search_string}"
		render nothing:true
	end
end

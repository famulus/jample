class JampleController < ApplicationController

	def set_current_patch
		patch_index = params[:id].to_i - 35
		CurrentPatch.set_current_patch(patch_index)
		puts "new index: #{patch_index}"
		render nothing:true
	end
end

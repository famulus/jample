class JampleController < ApplicationController

	def set_current_patch
		CurrentPatch.set_current_patch(params[:id])

		render nothing:true
	end
end

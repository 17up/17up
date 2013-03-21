class CoursesController < ApplicationController
	before_filter :authenticate_member!

  	def sync
		unless !params[:_id].blank? and @course = Course.find(params[:_id])
			@course = current_member.courses.new
		end
		@course.title = params[:title]
		@course.tags = params[:tags].split(",")
		@course.content = params[:content]
		# 标记课程状态为审核中
		@course.status = 2
		if @course.save!
			render_json 0,"save success"
		else
			render_json -1,"fail"
		end
	end

	def draft
		@course = Course.find(params[:_id])
		@course.status = 3
		@course.save
		render_json 0,"saved as draft"
	end

end

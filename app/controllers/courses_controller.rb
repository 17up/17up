class CoursesController < ApplicationController
	before_filter :authenticate_member!

	# 課程商店
	def index
		@courses = Course.all.as_json
		render_json 0,"ok",@courses
	end

	# 登記學習
	def checkin
		if @course = Course.find(params[:_id])
			current_member.course = @course
			current_member.save
			render_json 0,"ok"
		else
			render_json -1,"no course"
		end
	end

  	def update
		unless !params[:_id].blank? and find_member_course
			@course = current_member.courses.new
		end
		@course.title = params[:title]
		@course.tags = params[:tags].split(",")
		@course.content = params[:content]
		@course.status = 3
		if @course.save!
			HardWorker::PrepareWordJob.perform_async(@course._id)
			render_json 0,"save success",@course.as_json
		else
			render_json -1,"fail"
		end
	end

	def ready
		if find_member_course
			# 标记课程状态为审核中
			@course.update_attribute(:status,2)
			render_json 0,"wait for open"
		else
			render_json -1,"no course"
		end
	end

	def open
		if current_member.admin?
			if @course = Course.ready.find(params[:_id])
				@course.update_attribute(:status,1)
				render_json 0,"open"
			else
				render_json -1,"no course"
			end
		end		
	end

	def destroy
		if find_member_course
			@course.destroy
			render_json 0,"destroy"
		else
			render_json -1,"no course"
		end
	end

	private
	def find_member_course
		@course = current_member.courses.find(params[:_id])
	end
end

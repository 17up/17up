module Eva
	class Base
		def initialize(member)
			@member = member
		end
	end

	class Course < Base
		def list
			# 推荐课程，在已发布课程中做推荐筛选
			recommands = ::Course.open.limit(10)
			# 正在学习的课程，学完并通过考核的课程不显示
			checked = @member.checked_courses
			list = (checked + recommands).uniq
			result = []
			list.each_with_index do |c,i|
				result << c.as_json.merge!(:has_checkin => (i < checked.length))
			end
			result
		end

	end

	class Quote < Base
		def single
			@quote = ::Quote.tag_by("love").first
			@quote.as_short_json
		end
		
	end
end
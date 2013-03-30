module Eva
	class Base
		def initialize(member)
			@member = member
		end
	end

	class Course < Base
		def list
			recommands = ::Course.limit(10)
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
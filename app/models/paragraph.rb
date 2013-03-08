class Paragraph < Text

  	field :happen_at, type: Time

  	embedded_in :course
end

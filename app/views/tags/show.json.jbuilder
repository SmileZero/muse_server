if @result[:status] == "ok"
	json.extract! @result, :status,:tag
else
	json.extract! @result, :status,:msg
end
#json.extract! @tag, :id, :name, :created_at, :updated_at

if @result[:status] == "ok"
	json.extract! @result, :status,:music
else
	json.extract! @result, :status,:msg
end

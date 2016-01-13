if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.evaluations do
    json.scratched @scratched_array
    json.evaluations @evaluations_array
  end
end

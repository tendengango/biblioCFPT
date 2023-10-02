json.extract! student, :id, :matricule, :email, :name, :password, :classname, :created_at, :updated_at
json.url student_url(student, format: :json)

class HomeController < ApplicationController
  def index
      if !current_student.nil?
          sign_out :student
      end
      if !current_admin.nil?
          sign_out :admin
      end
    #    if !current_admin_guest.nil?
    #       sign_out :admin_guest
    #    end
      if !current_librarian.nil?
          sign_out :librarian
      end

      # if !current_student_guest.nil?
      #     sign_out :student_guest
      # end
  end
end

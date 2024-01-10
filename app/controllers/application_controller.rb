class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :matricule, :classname, :email])
  end 
 
end

# class ApplicationController < ActionController::Base
#   protect_from_forgery
#   #before_action :authenticate_admin!
#   helper_method :current_admin
#   # helper_method :current_librarian
#   # helper_method :current_student

#   def current_admin
#     super || guest_admin
#   end

#   # def current_librarian
#   #   super || guest_librarian
#   # end

#   # def current_student
#   #   super || guest_student
#   # end

#   private

#   def guest_admin
#     Admin.find(session[:guest_admin_id].nil? ? session[:guest_admin_id] = create_guest_admin.id : session[:guest_admin_id])
#   end

#   def create_guest_admin
#     admin = Admin.new { |admin| admin.guest = true }
#     admin.email = "guest_#{Time.now.to_i}#{rand(99)}@example.com"
#     admin.save(:validate => false)
#     admin
#   end
# end

# class ApplicationController < ActionController::Base

#   protect_from_forgery

#   # if user is logged in, return current_user, else return guest_user
#   def current_or_guest_admin
#     if current_admin
#       if session[:guest_admin_id] && session[:guest_admin_id] != current_admin.id
#         logging_in
#         # reload guest_user to prevent caching problems before destruction
#         guest_admin(with_retry = false).try(:reload).try(:destroy)
#         session[:guest_admin_id] = nil
#       end
#       current_admin
#     else
#       guest_admin
#     end
#   end

#   # find guest_user object associated with the current session,
#   # creating one as needed
#   def guest_admin(with_retry = true)
#     # Cache the value the first time it's gotten.
#     @cached_guest_admin ||= Admin.find(session[:guest_admin_id] ||= create_guest_admin.id)

#   rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
#      session[:guest_admin_id] = nil
#      guest_admin if with_retry
#   end

#   private

#   # called (once) when the user logs in, insert any code your application needs
#   # to hand off from guest_user to current_user.
#   def logging_in
#     # For example:
#     # guest_comments = guest_user.comments.all
#     # guest_comments.each do |comment|
#       # comment.user_id = current_user.id
#       # comment.save!
#     # end
#   end

#   def create_guest_admin
#     a = Admin.new(name: "guest", email: "guest_#{Time.now.to_i}#{rand(100)}@example.com")
#     a.save!(validate: false)
#     session[:guest_admin_id] = a.id
#     a
#   end

# end


class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_presence_of :name, :email, unless: :guest?, allow_blank: true
  #validates_uniqueness_of :name, allow_blank: true
  #validates :name, presence: true, unless: :guest?, allow_blank: true
  validates_uniqueness_of :email, confirmation: { case_sensitive: false }, allow_blank: true
  validates_format_of :email, uniqueness: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, allow_blank: true
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, allow_blank: true
  def email_required? 
    false 
  end 
 
  def email_changed? 
    false 
  end 

  def password_required? 
    false 
  end 

  # def create_guest_admin
  #     a = Admin.new(name: "guest", email: "guest_#{Time.now.to_i}#{rand(100)}@example.com")
  #     a.save!(validate: false)
  #     session[:guest_admin_id] = a.id
  #     a
  # end

  # def is_guest_admin?
  # # Someone is logged in AND (we have a guest id AND that id matches the current user)
  #   current_admin && (session[:guest_admin_id] && session[:guest_admin_id] == current_admin.id)
  # end

  def self.new_guest
    new { |a| a.guest = true }
  end

  def username
    guest ? "Guest":name
  end

end

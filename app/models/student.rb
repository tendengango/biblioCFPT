class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         validates_presence_of :name, :email, unless: :guest?, allow_blank: true
 # validates :name, presence: true, unless: :guest?, allow_blank: true
  #validates :email, presence: true, unless: :guest?, allow_blank: true
  validates :matricule, presence: true, unless: :guest?, allow_blank: true
  validates :classname, presence: true, unless: :guest?, allow_blank: true
  validates_uniqueness_of :email, confirmation: { case_sensitive: false }, allow_blank: true
  validates_format_of :email, uniqueness: true, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, allow_blank: true
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, allow_blank: true
  has_many :checkout, dependent: :delete_all

  def email_required? 
    false 
  end 
 
  def email_changed? 
    false 
  end 

  def password_required? 
    false 
  end 

  def self.new_guest
     new { |s| s.guest = true }
  end
end

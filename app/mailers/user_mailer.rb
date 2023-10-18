class UserMailer < ApplicationMailer
   default from: 'admin@admin.com'
  def checkout_email(user,book)
      @user = user
      @book = book
      mail(to: @user.email, subject: 'Your Library Notifications')
  end

#   def complete_sign_up
#       @name = params[:name]
#       mail(to: params[:to], subject: "登録完了")
#   end

  def returnbook_email(user,book)
    @user = user
    @book = book
    mail(to: @user.email, subject: 'Your Library Notifications')
  end 
end

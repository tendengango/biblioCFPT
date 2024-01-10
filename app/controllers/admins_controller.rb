class AdminsController < ApplicationController
  #skip_before_action :verify_authenticity_token, only: [:show] 
  before_action :set_admin, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!
  #protect_from_forgery
  
  #helper_method :current_or_guest_admin
  # GET /admins or /admins.json
  def index
    @admins = Admin.all
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  def current_or_guest_admin
    if current_admin
      if session[:guest_admin_id] && session[:guest_admin_id] != current_admin.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_admin(with_retry = false).try(:reload).try(:destroy)
        session[:guest_admin_id] = nil
      end
      current_admin
    else
      guest_admin
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_admin(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_admin ||= Admin.find(session[:guest_admin_id] ||= create_guest_admin.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_admin_id] = nil
     guest_admin if with_retry
  end

  # POST /admins or /admins.json
  def create
    @admin = Admin.new(admin_params)? Admin.new(admin_params) : Admin.new_guest

    respond_to do |format|
      if @admin.save
        session[:admin_id] = @admin.id
       #sign_in :admin, @admin, bypass: true
        format.html { redirect_to admin_url(@admin), notice: "Administrateur créé avec succes." }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to admin_url(@admin), notice: "Admin mis à jour avec succes." }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to admins_url, notice: "Admin supprimé avec succes." }
      format.json { head :no_content }
    end
  end

  def show_librarians
    @librarians = Librarian.all
  end

  def show_students
    @students = Student.all
  end

  def show_books
    @books = Book.all
  end

  def current_admin
    super || guest_admin
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    def guest_admin
      Admin.find(session[:guest_admin_id].nil? ? session[:guest_admin_id] = create_guest_admin.id : session[:guest_admin_id])
    end

    def create_guest_admin
      a = Admin.new(name: "guest", email: "guest_#{Time.now.to_i}#{rand(100)}@example.com")
      a.save!(validate: false)
      session[:guest_admin_id] = a.id
      a
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.require(:admin).permit(:name, :email, :password)
    end
end

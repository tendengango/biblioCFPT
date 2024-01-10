class LibrariansController < ApplicationController
  before_action :set_librarian, only: %i[ show edit update destroy ]
  #before_action :authenticate_librarian!

  # GET /librarians or /librarians.json
  def index
    if admin_signed_in?
       sign_out :librarian
       redirect_to admins_path
	  elsif student_signed_in?
       sign_out :librarian
       redirect_to students_path, notice: 'Action not allowed.'
    else
       @lib = Librarian.find_by(:email => current_librarian.email)
       if @lib.approved != 'Yes' 
       redirect_to root_path, notice: 'Demandez d\'abord à un administrateur d\'approuver votre compte.'
       #redirect_to restricted_path
       else
          @librarians = Librarian.all 
        end
    end
  end

    def current_or_guest_librarian
    if current_librarian
      if session[:guest_librarian_id] && session[:guest_librarian_id] != current_librarian.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_librarian(with_retry = false).try(:reload).try(:destroy)
        session[:guest_librarian_id] = nil
      end
      current_librarian
    else
      guest_librarian
    end
  end

  def restricted
  if student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    end
  end

  def home_page
  if student_signed_in?
      sign_out :librarian
      redirect_to students_path, notice: 'Action not allowed.'
    end

  end

  # GET /librarians/1 or /librarians/1.json
  def show
  end

  # GET /librarians/new
  def new
    @librarian = Librarian.new
  end

  # GET /librarians/1/edit
  def edit
  end

  # POST /librarians or /librarians.json
  def create
    @librarian = Librarian.new(librarian_params)

    respond_to do |format|
      if @librarian.save
        format.html { redirect_to librarian_url(@librarian), notice: "Librarian was successfully created." }
        format.json { render :show, status: :created, location: @librarian }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @librarian.errors, status: :unprocessable_entity }
      end
    end
  end

  # creating one as needed
  def guest_librarian(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_librarian ||= Librarian.find(session[:guest_librarian_id] ||= create_guest_librarian.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_librarian_id] = nil
     guest_librarian if with_retry
  end

  # PATCH/PUT /librarians/1 or /librarians/1.json
  def update
    respond_to do |format|
      if @librarian.update(librarian_params)
        format.html { redirect_to librarian_url(@librarian), notice: "Librarian was successfully updated." }
        format.json { render :show, status: :ok, location: @librarian }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @librarian.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /librarians/1 or /librarians/1.json
  def destroy
    @librarian.destroy

    respond_to do |format|
      format.html { redirect_to librarians_url, notice: "Librarian was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_librarian
      @librarian = Librarian.find(params[:id])
    end
    def create_guest_librarian
      l = Librarian.new(name: "guest", email: "guest_#{Time.now.to_i}#{rand(100)}@example.com")
      l.save!(validate: false)
      session[:guest_librarian_id] = l.id
      l
    end
    # Only allow a list of trusted parameters through.
    def librarian_params
      params.require(:librarian).permit(:name, :email, :password, :approved)
    end
end

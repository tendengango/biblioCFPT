class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]
  #before_action :authenticate_student!
  # GET /students or /students.json
  def index
    if admin_signed_in?
      sign_out :student
      redirect_to admins_path
    end
	if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action non autorisée.'
    end

    @students = Student.all
  end

  # GET /students/1 or /students/1.json
  def show
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action non autorisée.'
    end
  end

  # GET /students/new
  def new
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action non autorisée.'
    else
    @student = Student.new
  end
  end

  # GET /students/1/edit
  def edit
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action non autorisée.'
    end
  end

    def current_or_guest_student
    if current_student
      if session[:guest_student_id] && session[:guest_student_id] != current_student.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_student(with_retry = false).try(:reload).try(:destroy)
        session[:guest_student_id] = nil
      end
      current_student
    else
      guest_student
    end
  end

  def guest_student(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_student ||= Student.find(session[:guest_student_id] ||= create_guest_student.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_student_id] = nil
     guest_student if with_retry
  end

  # POST /students or /students.json
  def create
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action non autorisée.'
    else
    #@student = Student.new(student_params)
    @student = Student.new(student_params)? Student.new(student_params) : Student.new_guest
    respond_to do |format|
      if @student.save
        session[:student_id] = @student.id
        UserMailer.with(to: @student.email, name: @student.name).complete_sign_up.deliver_later
        format.html { redirect_to student_url(@student), notice: "L'étudiant a été créé avec succès." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
     if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action non autorisée.'
    else
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "L'étudiant a été mis à jour avec succès." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action non autorisée.'
    else
    @student.destroy
    if current_admin.nil?
      respond_to do |format|
        format.html { redirect_to students_url, notice: "L'Etudiant a été détruit avec succès." }
        format.json { head :no_content }
      end
    else
			respond_to do |format|
			  format.html { redirect_to show_students_url, notice: 'L\'Etudiant a été supprimé avec succès.' }
			  format.json { head :no_content }
		  end
    end
  end
  end

  def checkoutdisplay
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    def create_guest_student
      s = Student.new(name: "guest", email: "guest_#{Time.now.to_i}#{rand(100)}@example.com")
      s.save!(validate: false)
      session[:guest_student_id] = s.id
      s
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:matricule, :email, :name, :password, :classname)
    end
    def book_params
      params.require(:book).permit(:isbn, :title, :authors, :language, :published_date, :edition, :cover, :subject, :summary, :quantity, :portrait)
    end
end


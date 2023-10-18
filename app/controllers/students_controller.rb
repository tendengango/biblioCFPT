class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]

  # GET /students or /students.json
  def index
    if admin_signed_in?
      sign_out :student
      redirect_to admins_path
    end
	if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    end

    @students = Student.all
  end

  # GET /students/1 or /students/1.json
  def show
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    end
  end

  # GET /students/new
  def new
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    else
    @student = Student.new
  end
  end

  # GET /students/1/edit
  def edit
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    end
  end

  # POST /students or /students.json
  def create
    if librarian_signed_in?
      sign_out :student
      redirect_to librarians_path , notice: 'Action not allowed.'
    else
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        UserMailer.with(to: @student.email, name: @student.name).complete_sign_up.deliver_later
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
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
      redirect_to librarians_path , notice: 'Action not allowed.'
    else
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
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
      redirect_to librarians_path , notice: 'Action not allowed.'
    else
    @student.destroy
    if current_admin.nil?
      respond_to do |format|
        format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
        format.json { head :no_content }
      end
    else
			respond_to do |format|
			  format.html { redirect_to show_students_url, notice: 'Student was successfully removed.' }
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

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:matricule, :email, :name, :password, :classname)
    end
    def book_params
    params.require(:book).permit(:isbn, :title, :authors, :language, :published_date, :edition, :cover, :subject, :summary, :quantity)
    end
end


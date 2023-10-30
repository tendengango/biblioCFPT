class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = Book.all
  end
   
  def books_students	
	@books = Book.all.where(:email => current_student.email)
	@books_all = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
  if student_signed_in?
      redirect_to students_path, notice: 'Action not allowed.'
	else
    @book = Book.new
  end
  end

  # GET /books/1/edit
  def edit
  if student_signed_in?
      redirect_to students_path, notice: 'Action not allowed.'
	end
  end

  # POST /books or /books.json
  def create
  
	if student_signed_in?
      redirect_to students_path, notice: 'Action not allowed.'
	else
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    if student_signed_in?
      redirect_to students_path, notice: 'Action not allowed.'
	else
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
  if student_signed_in?
      redirect_to students_path, notice: 'Action not allowed.'
	else
    @book.destroy

    if current_admin.nil? and current_librarian.nil?
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  elsif !current_admin.nil?
			respond_to do |format|
			  format.html { redirect_to show_books_path, notice: 'Book was successfully destroyed.' }
			  format.json { head :no_content }
			end		
		elsif !current_librarian.nil?
			respond_to do |format|
			  format.html { redirect_to librarian_book_view_path, notice: 'Book was successfully destroyed.' }
			  format.json { head :no_content }
			end		
		end
	end
  end

  def search
	  if params[:search].blank?  
		redirect_to('index', alert: "Empty field!") and return  
	  elsif params[:search_by]=='title' 
			@results = Book.all.where("lower(title) LIKE ?", "%#{params[:search].downcase}%")
	  elsif params[:search_by]=='authors'
			@results = Book.all.where("lower(authors) LIKE ?", "%#{params[:search].downcase}%")
	  elsif params[:search_by]=='published' 
			@results = Book.all.where("lower(published) LIKE ?", "%#{params[:search].downcase}%")
	  elsif params[:search_by]=='category'
			@results = Book.all.where("lower(category) LIKE ?", "%#{params[:search].downcase}%")
	  else
			redirect_to('index', alert: "Empty field!")
	  end  
  end

  def librarian_book_view
    @books = Book.all
  end

 def checkout # check if the given book is a special book or not
    @book = Book.find(params[:id])
   
          if Checkout.where(:student_id => current_student.id , :book_id => @book.id, :return_date => nil).first.nil?
            @checkout = Checkout.new(:student_id => current_student.id , :book_id => @book.id , :issue_date => Date.today , :return_date =>nil)
            flash[:notice] = "Book Successfully Checked Out"
            puts params[:id]
            puts @book.quantity
            @book.decrement(:quantity)
            puts @book.quantity
            @user = current_student
            UserMailer.checkout_email(@user,@book).deliver_now
            @checkout.save!
            @book.save!
          else 
            flash[:notice] = "Book Already Checked Out!!"
          end  
        #end
      #else
        if Checkout.where(:student_id => current_student.id , :book_id => @book.id).first.nil?
          if HoldRequest.where(:student_id => current_student.id , :book_id => @book.id).first.nil?
            @hold_request =  HoldRequest.new(:student_id => current_student.id , :book_id => @book.id)
            @hold_request.save!
            flash[:notice] = "Book Hold Request Placed"
          else 
            flash[:notice] = "Book Hold Request Is Already Placed"
          end
        else
          flash[:notice] = "Book Already Checked Out!!!"
        end
    
      if !current_student.nil?
        
      end
   
    redirect_to books_students_path
  end

  def getStudentBookFine
    @checkouts = Checkout.where(:student_id => current_student.id , :return_date => nil )
    if !@checkouts.nil?
      @fines = Array.new
      @checkouts.each do |checkout|
        if checkout.issue_date + 15 < Date.today
          delay = (Date.today - checkout.issue_date).to_i - 15
          #fine_per_day  = Library.find(Book.find(checkout.book_id).library_id).overdue_fines
          @fines.push({:fine_ammount => delay * fine_per_day, :book_id => checkout.book_id})
        else
          @fines.push({:fine_ammount => 0, :book_id => checkout.book_id})
        end
      end
    end
  end

  def viewHoldRequestForLibrarian
    @holdreqs = HoldRequest.where(:book_id => Book.where(:library_id => Library.select('id').where(:name => current_librarian.library) ))
  end

  def viewBookHistory
    @checkouts = Checkout.where.not(:return_date => nil ).where(:book_id => params[:id])
  end

  def returnBook
    @book = Book.find(params[:id])
    if(@book.quantity>0) 
      if !Checkout.where(:student_id => current_student.id , :book_id => @book.id, :return_date => nil).first.nil?
        @checkout = Checkout.where(:student_id => current_student.id , :book_id => @book.id, :return_date => nil).first
        @checkout.update( :return_date => Date.today)
        @checkout.save!
        flash[:notice] = "Book Successfully returned"
        @user = current_student
        UserMailer.returnbook_email(@user,@book).deliver_now
        @book.increment(:quantity)
        @book.save!
      else 
        flash[:notice] = "Book is not checked out"
      end  
    else
      if !Checkout.where(:student_id => current_student.id , :book_id => @book.id,:return_date => nil).nil?
        @hold_request = HoldRequest.where(:book_id => @book.id).first
        if @hold_request.nil?
          @checkout = Checkout.where(:student_id => current_student.id , :book_id => @book.id , :return_date => nil)
          @checkout.update( :return_date => Date.today)
          flash[:notice] = "Book Successfully returned"
          @user = current_student
          UserMailer.returnbook_email(@user,@book).deliver_now
          @book.increment(:count)
          @book.save!
        else
          @checkout = Checkout.where(:student_id => current_student.id , :book_id => @book.id )
          @checkout.update( :return_date => Date.today)
          @checkout_new = Checkout.new(:student_id => @hold_request.student_id , :book_id => @hold_request.book_id , :issue_date => Date.today , :return_date =>nil , :validity => Library.find(@book.library_id).borrow_limit)
          @checkout_new.save!
          flash[:notice] = "Book Successfully returned"
          UserMailer.checkout_email(User.find(@hold_request.student_id),@book).deliver_now
          @hold_request.destroy
        end
      end
    end
	  redirect_to action: "getBookmarkBooks"
  end


  def getBookmarkBooks
    
    @checkout = Book.where(id: Checkout.select('book_id').where(:return_date =>nil, :student_id => current_student.id))
    
  end

  def validity
    @validity=15
  end

  def getOverdueBooks
    
    if admin_signed_in?
      @checkouts = Checkout.where(:return_date => nil)
    else
      @checkouts = Checkout.where(:return_date => nil, :book_id => Book.select('id'))
    end    
    if !@checkouts.nil?
      @fines = Array.new
      @checkouts.each do |checkout|
        if checkout.issue_date + 15 < Date.today
          delay = (Date.today - checkout.issue_date).to_i - 15
         # @fines.push({:fine_ammount => delay * fine_per_day, :book_id => checkout.book_id , :student_id => checkout.student_id})
        #else
          #@fines.push({:fine_ammount => 0, :book_id => checkout.book_id ,:student_id => checkout.student_id})
        end
      end
    end
  end

  def viewBookHistory
    @checkouts = Checkout.where.not(:return_date => nil ).where(:book_id => params[:id])
  end

  def list_checkedoutBooks
    #book.where(isbn: Transaction.select('isbn').where(email: current_student.email,bookmarks: true))
    @books = Book.where(id: Checkout.select('book_id').where(:return_date =>nil))
  end

  def list_checkedoutBooksAndStudentsAdmin
	#@results = Checkout.joins('INNER JOIN Students s ON s.id = Checkouts.student_id INNER JOIN Books b ON b.id = Checkouts.book_id')
	@results = Checkout.select(:'students.name',:'students.email',:'books.isbn',:'books.title',:'books.authors',:issue_date,:return_date,:'books.language',:'books.published',:'books.edition',:'books.summary').joins(:student).joins(:book)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:isbn, :title, :authors, :language, :published, :edition, :summary, :quantity, :portrait)
    end
end


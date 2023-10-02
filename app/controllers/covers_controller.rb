class CoversController < ApplicationController
  before_action :set_cover, only: %i[ show edit update destroy ]

  # GET /covers or /covers.json
  def index
    @covers = Cover.all
  end

  # GET /covers/1 or /covers/1.json
  def show
  end

  # GET /covers/new
  def new
    @cover = Cover.new
  end

  # GET /covers/1/edit
  def edit
  end

  # POST /covers or /covers.json
  def create
    @cover = Cover.new(cover_params)

    respond_to do |format|
      if @cover.save
        format.html { redirect_to cover_url(@cover), notice: "Cover was successfully created." }
        format.json { render :show, status: :created, location: @cover }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cover.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /covers/1 or /covers/1.json
  def update
    respond_to do |format|
      if @cover.update(cover_params)
        format.html { redirect_to cover_url(@cover), notice: "Cover was successfully updated." }
        format.json { render :show, status: :ok, location: @cover }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cover.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /covers/1 or /covers/1.json
  def destroy
    @cover.destroy

    respond_to do |format|
      format.html { redirect_to covers_url, notice: "Cover was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cover
      @cover = Cover.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cover_params
      params.require(:cover).permit(:name, :portrait)
    end
end

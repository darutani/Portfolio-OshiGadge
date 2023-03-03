class GadgetsController < ApplicationController
  before_action :set_gadget, only: %i[ show edit update destroy ]

  # GET /gadgets or /gadgets.json
  def index
    @gadgets = Gadget.all
  end

  # GET /gadgets/1 or /gadgets/1.json
  def show
  end

  # GET /gadgets/new
  def new
    @gadget = Gadget.new
  end

  # GET /gadgets/1/edit
  def edit
  end

  # POST /gadgets or /gadgets.json
  def create
    @gadget = Gadget.new(gadget_params)

    respond_to do |format|
      if @gadget.save
        format.html { redirect_to gadget_url(@gadget), notice: "Gadget was successfully created." }
        format.json { render :show, status: :created, location: @gadget }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gadget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gadgets/1 or /gadgets/1.json
  def update
    respond_to do |format|
      if @gadget.update(gadget_params)
        format.html { redirect_to gadget_url(@gadget), notice: "Gadget was successfully updated." }
        format.json { render :show, status: :ok, location: @gadget }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gadget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gadgets/1 or /gadgets/1.json
  def destroy
    @gadget.destroy

    respond_to do |format|
      format.html { redirect_to gadgets_url, notice: "Gadget was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gadget
      @gadget = Gadget.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gadget_params
      params.require(:gadget).permit(:user_id, :name, :start_date, :category, :reason, :point, :usage, :feature)
    end
end

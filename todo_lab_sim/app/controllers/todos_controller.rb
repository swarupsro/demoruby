class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy]

  def index
    @todos = Todo.order(created_at: :desc)
  end

  def show; end

  def new
    @todo = Todo.new
  end

  def edit; end

  def create
    @todo = Todo.new(todo_params)
    simulation_outcome = run_simulation_check(:create)
    if simulation_outcome == :blocked
      render :new, status: :unprocessable_entity and return
    end

    if @todo.save
      redirect_to @todo, notice: "Todo was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    simulation_outcome = run_simulation_check(:update)
    if simulation_outcome == :blocked
      render :edit, status: :unprocessable_entity and return
    end

    if @todo.update(todo_params)
      redirect_to @todo, notice: "Todo was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_url, notice: "Todo was successfully destroyed."
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed)
  end

  # Runs the safe simulation layer before persisting data. The service only inspects strings
  # and never executes raw SQL, so this remains safe for all environments.
  def run_simulation_check(action)
    return :skipped unless params.dig(:todo, :title)

    result = SimulatedInjectionService.check(
      params[:todo][:title],
      request: request,
      metadata: { controller_action: action }
    )

    case result
    when :filtered
      flash.now[:alert] = "Simulated filter intercepted suspicious characters."
      @todo.errors.add(:title, "was blocked by the simulated filter")
      return :blocked
    when :time_delay
      sleep SimulatedInjectionService.delay_seconds
      if Rails.env.lab?
        response.set_header("X-Lab-Simulation", "time_delay")
        flash[:lab_notice] = "Simulated time-based delay introduced for training purposes."
      end
    end

    :proceed
  end
end

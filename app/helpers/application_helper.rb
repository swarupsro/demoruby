module ApplicationHelper
  def lab_mode?
    SimulatedInjectionService.enabled?
  end
end

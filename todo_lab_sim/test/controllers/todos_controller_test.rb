require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    SimulatedInjectionService.enable!
    SimulatedInjectionService.clear_log!
  end

  teardown do
    SimulatedInjectionService.reset_override!
    SimulatedInjectionService.clear_log!
  end

  test "simulated delay triggers and logs when marker present" do
    SimulatedInjectionService.stub(:delay_seconds, 0.05) do
      assert_difference -> { Todo.count }, +1 do
        started = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        post todos_url, params: {
          todo: {
            title: "Blind probe [[SqliProbe]]",
            description: "testing delay simulation",
            completed: false
          }
        }

        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
        assert_operator elapsed, :>=, 0.03, "Expected artificial delay to be applied"
      end
    end

    assert_redirected_to todo_url(Todo.last)

    last_entry = SimulatedInjectionService.log_entries.last
    assert_equal :time_delay, last_entry[:result]
    assert_equal "Blind probe [[SqliProbe]]", last_entry[:payload]
  end

  test "filtered characters short-circuit without delay" do
    SimulatedInjectionService.stub(:delay_seconds, 2) do
      assert_no_difference -> { Todo.count } do
        started = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        post todos_url, params: {
          todo: {
            title: "blocked ' payload",
            description: "should be filtered immediately",
            completed: false
          }
        }

        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
        assert_operator elapsed, :<, 0.5, "Filtered payloads should not trigger delay"
      end
    end

    assert_response :unprocessable_entity

    last_entry = SimulatedInjectionService.log_entries.last
    assert_equal :filtered, last_entry[:result]
  end
end

defmodule PocGenstatem do
end

defmodule Switch do
  defmodule Switch.Switchable do
    @callback flip_off_to_on_event(data :: Any.t()) :: Any.t()
    @callback flip_on_to_off_event(data :: Any.t()) :: Any.t()
  end

  defmacro __using__(_) do
    quote do
      @behaviour Switch.Switchable
      use GenStateMachine

      def handle_event(:cast, :flip, :off, data) do
        {:next_state, :on, __MODULE__.flip_off_to_on_event(data)}
      end

      def handle_event(:cast, :flip, :on, data) do
        {:next_state, :off, __MODULE__.flip_off_to_on_event(data)}
      end

      def handle_event({:call, from}, :get_count, state, data) do
        {:next_state, state, data, [{:reply, from, data}]}
      end

      def flip_off_to_on_event(data), do: data
      def flip_on_to_off_event(data), do: data
      defoverridable flip_off_to_on_event: 1
      defoverridable flip_on_to_off_event: 1
    end
  end
end

defmodule SwitchImpl do
  use Switch

  @impl true
  def flip_off_to_on_event(data), do: data + 1

  @impl true
  def flip_on_to_off_event(data), do: data

  def start() do
    GenStateMachine.start_link(SwitchImpl, {:off, 0})
  end

  def flip(pid), do: GenStateMachine.cast(pid, :flip)

  def get_count(pid), do: GenStateMachine.call(pid, :get_count)
end

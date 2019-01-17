defmodule PocGenstatemTest do
  use ExUnit.Case
  doctest PocGenstatem

  test "greets the world" do
    {:ok, pid} = SwitchImpl.start()

    assert :sys.get_state(pid) == {:off, 0}
    SwitchImpl.flip(pid)
    assert :sys.get_state(pid) == {:on, 1}
    assert SwitchImpl.get_count(pid) == 1
    SwitchImpl.flip(pid)
    assert :sys.get_state(pid) == {:off, 2}
    SwitchImpl.get_count(pid)
    assert SwitchImpl.get_count(pid) == 2
  end
end

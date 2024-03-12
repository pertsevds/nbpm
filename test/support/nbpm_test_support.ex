defmodule NbpmTest.Support do
  @moduledoc false
  def nodes_ports do
    [
      {"88197my-random-name", 1_024},
      {"18736my-random-name", 65_535},
      {"my-random-name", 41_600},
      {"my-random-name-12345", 12_345},
      {"my-random-name12345", 12_345},
      {"12345", 12_345},
      {"my-random-name-443", 443},
      {"my-random-name443", 443},
      {"443", 443},
      {"rpc-random-name", 0},
      {"rpc-random-name-12345", 0},
      {"rpc-my-random-name12345", 0},
      {"rpc-rem-my-random-name-12345", 0},
      {"rpc-rem-my-random-name12345", 0},
      {"rpc-12345", 0},
      {"rpc12345", 12_345},
      {"rpc-443", 0},
      {"rem-random-sname", 0},
      {"rem-random-sname-12345", 0},
      {"rem-random-sname12345", 0},
      {"rem-rpc-my-random-name-12345", 0},
      {"rem-rpc-my-random-name12345", 0},
      {"rem-12345", 0},
      {"rem12345", 12_345},
      {"rem-443", 0}
    ]
  end
end

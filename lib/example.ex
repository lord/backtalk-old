defmodule Testblah do
  use Backtalk.Router

  def route conn, "GET", ["foobar"] do
    "you can also write routes like this"
  end

  def route conn, "GET", ["meow", foo] do
    foo
  end

  def route conn, _, _ do
    {404, "not found error!"}
  end
end
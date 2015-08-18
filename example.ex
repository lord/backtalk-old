defmodule Example.Router do
  use Backtalk.Router

  # GET /cats/<id>
  def route conn = %{
    method: "GET",
    path_info: ["cats", cat_id]
  } do
    {:ok, %{example: "response", your_cat_id: cat_id}}
  end

  # POST /cats
  def route conn = %{
    method: "POST",
    path_info: ["cats"]
  } do
    # you can return a conn object, too, and Backtalk will automatically send it
    # if it's set but unsent
    conn |> Plug.Conn.set_response_header("blah", "blah") |> Plug.Conn.resp("meow")
  end

  # PUT /cats
  def route conn = %{
    method: "PUT",
    path_info: ["cats", cat_id]
    params: %{new_name: new_name}
  } do
    validate String.length(new_name) < 100,
             String.length(new_name) > 3

    # do db insertion here
  end

end
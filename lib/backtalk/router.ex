defmodule Backtalk.Router do
  defmacro __using__(_opts) do
    quote do
      def init(options), do: options

      def call(conn, _opts) do
        method = conn.method |> String.downcase |> String.to_atom
         case route(conn, method, conn.path_info) do
          body when is_binary(body) -> set_reply(conn, 200, %{}, body)
          code when is_number(code) -> set_reply(conn, code, %{}, "")
          {code, body} when is_number(code) and is_binary(body) -> set_reply(conn, code, %{}, body)
          {code, headers, body} when is_number(code) and is_binary(body) and is_map(headers) -> set_reply(conn, code, headers, body)
          new_conn -> new_conn # TODO can check if matches conn struct type?
          # TODO body can be not a string, can be a symbol (i.e. :ok, :error) and then we match as appropriate
        end
      end

      defp set_reply(conn, code, headers, body) do
        conn
        |> Plug.Conn.merge_resp_headers(headers)
        |> Plug.Conn.send_resp(code, body)
      end

      def start do
        {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, []
      end
    end
  end

  # TODO add convenience function r
  # r %{
  #   path_info: ["blah"]
  # } do stuff() end
end

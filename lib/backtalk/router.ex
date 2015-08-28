defmodule Backtalk.Router do
  defmacro __using__(_opts) do
    quote do
      def init(options), do: options

      def call(conn, _opts) do
        case route(conn, method, conn.path_info) do
          body when is_string(body) -> set_reply(conn, 200, %{}, body)
          code when is_number(code) -> set_reply(conn, code, %{}, "")
          {code, body} when is_number(code) and is_string(body) -> set_reply(conn, code, %{}, body)
          {code, headers, body} when is_number(code) and is_string(body) and is_map(headers) -> set_reply(conn, code, headers, body)
          new_conn -> new_conn # TODO can check if matches conn struct type?
          # TODO body can be not a string, can be a symbol and then we match as appropriate
        end
      end

      defp set_reply(conn, code, headers, body) do
        conn
        |> merge_resp_headers(headers)
        |> send_resp(code, body)
      end

      defp send(conn) do
        if conn.state == :set do
          Plug.Conn.send_resp(conn)
        else
          conn
        end
      end
    end
  end
end

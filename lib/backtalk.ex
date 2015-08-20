defmodule Backtalk do
  defmacro __using__(_opts) do
    quote do
      def init(options), do: options

      def call(conn, _opts) do
        result = conn |> route(method, conn.path_info)
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

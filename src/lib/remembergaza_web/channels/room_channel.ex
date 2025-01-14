defmodule RemembergazaWeb.RoomChannel do
  use RemembergazaWeb, :channel

  @impl true
  def join("room:lobby", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    identified_victims = Application.get_env(:remembergaza, :identified_victims)

    Enum.chunk_every(identified_victims, 1000)
    |> Enum.each(fn chunk ->
      push(socket, "message", %{
        victims:
          Enum.map(chunk, fn value ->
            "<div><h3>#{value["name"]}</h3><p>#{value["en_name"]}</p></div>"
          end)
          |> Enum.join()
      })

      :timer.sleep(1)
    end)

    {:noreply, socket}
  end
end

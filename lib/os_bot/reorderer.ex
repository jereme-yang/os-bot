defmodule OsBot.Reorderer do
  # Reorders OH-Queue on events like moving a student to OH slot,
  # Students leaving the OH-Queue, or random disconnects and time-outs

  use Agent

  alias OsBot.QueueTracker
  require Logger


  # TODO: Make this scalable to more servers
  @os_server_id 1276622042031980574

  # Starts the module
  def start_link(_) do
    Task.start_link(fn -> loop() end)
  end

  # takes in @OsBot.QueueTracker list, renames all nicknames to be properly ordered
  def reorder_nicknames(guild_id) do
    QueueTracker.list_users()
    |> Enum.with_index(1)
    |> Enum.each(fn {user_id, index} ->
      with {:ok, %Nostrum.Struct.User{global_name: global, username: username}} <- Nostrum.Api.User.get(user_id) do
        display_name = global || username
        new_nick = "[#{index}] #{display_name}"
        Nostrum.Api.Guild.modify_member(guild_id, user_id, %{nick: new_nick})
      else
        err -> Logger.error("Failed to fetch user #{user_id}: #{inspect(err)}")
      end
    end)
  end


  # WARNING: if scaled to larger than 100 servers / users, may cause large CPU Consumption.
  # reorder nicknames every 30 seconds
  defp loop do
    reorder_nicknames(@os_server_id)
    :timer.sleep(30_000)
    loop()
  end
end

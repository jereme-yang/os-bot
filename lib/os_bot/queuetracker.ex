defmodule OsBot.QueueTracker do
  # This module tracks users in OH-QUEUE using an Agent.
  # It's primarily used to manage VC joins and departures.
  # It uses a list containing user_id's, but maintains uniqueness of user_id's
  # similar to a set

  # Agents allow shared mutable state in elixir
  use Agent

  # inits agent with empty list, not important bc
  # the bot should be run 100% uptime in practice
  @spec start_link(any()) :: {:error, any()} | {:ok, pid()}
  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  # Adds user to queue if they are not already in
  def mark_join(user_id) do
    Agent.get_and_update(__MODULE__, fn users ->
      if user_id in users do
        {:already_in, users}
      else
        {:new_join, users ++ [user_id]}
      end
    end)
  end


  # Removes a user from the list
  def mark_leave(user_id) do
    Agent.update(__MODULE__, fn users ->
      List.delete(users, user_id)
    end)
  end

  # Get the list of User Ids, Used in @OsBot.Reorderer
  def list_users do
    Agent.get(__MODULE__, fn users -> users end)
  end

  # Get the queue size of the OH-Queue used in @OsBot.Consumer
  def queue_size do
    Agent.get(__MODULE__, fn users -> length(users) end)
  end
end

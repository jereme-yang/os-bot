defmodule OsBot.Consumer do
  # Handles events that occur

  use Nostrum.Consumer

  alias Nostrum.Api.Message
  alias OsBot.QueueTracker
  alias OsBot.Reorderer

  require Logger

  # TODO: make this scalable to more servers
  @oh_queue_cid 1276639959998140538


  # Handles events like user joining call, user unmuting/muting
  def handle_event({:VOICE_STATE_UPDATE, %Nostrum.Struct.Event.VoiceState{
    guild_id: guild_id,
    user_id: user_id,
    channel_id: channel_id
  } = _msg, _ws_state}
  ) do

    # Grab the display_name
    display_name =
      with {:ok, %Nostrum.Struct.User{global_name: global, username: username}} <- Nostrum.Api.User.get(user_id) do
        global || username
      else
        _ ->
          raise "Failed to fetch user for ID: #{user_id}"
      end


    # channel id is OH_Queue && the event is a student join
    # ? update nickname with queue position
    # : update back to original nickname, reorder OH_Queue channel
    case channel_id do
      @oh_queue_cid ->
        case QueueTracker.mark_join(user_id) do
          :new_join ->
            case Nostrum.Api.Guild.modify_member(
              guild_id,
              user_id,
              %{nick: "[#{Integer.to_string(QueueTracker.queue_size)}] #{display_name}"}
            ) do
              {:ok, _} -> :ok
              {:error, reason} -> Logger.error("Failed to change nickname: #{inspect(reason)}")
            end

            Logger.debug("Incremented, queue size: #{QueueTracker.queue_size}")

          :already_in ->
            Logger.debug("Already in VC, not incrementing")
        end


      _ ->
        Nostrum.Api.Guild.modify_member(
          guild_id,
          user_id,
          %{nick: display_name}
        )
        QueueTracker.mark_leave(user_id)
        Reorderer.reorder_nicknames(guild_id)
        Logger.debug("Decremented, queue size:  #{QueueTracker.queue_size}")
    end
  end

  # TODO: Make message commands
  def handle_event({:MESSAGE_CREATE, %Nostrum.Struct.Message{
    author: %Nostrum.Struct.User{global_name: username},
    content: msg_content,
    channel_id: channel_id
    } = _msg, _ws_state}
    )
    when is_binary(msg_content) and is_binary(username) do


    Logger.debug("got message #{inspect(msg_content)} from user #{username}")

    case msg_content do
      "!faq" ->
        Message.create(channel_id, "TODO")

      _ ->
        :ignore
    end
  end
end

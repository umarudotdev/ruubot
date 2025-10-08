import gleam/option.{type Option}
import ruubot/twitch/eventsub/message.{
  type Badge, type Cheer, type Message, type Reply,
}
import youid/uuid.{type Uuid}

pub type Event {
  ChannelChatMessageEvent(
    broadcaster_user_id: String,
    broadcaster_user_name: String,
    broadcaster_user_login: String,
    chatter_user_id: String,
    chatter_user_name: String,
    chatter_user_login: String,
    message_id: Uuid,
    message: Message,
    message_type: String,
    badges: List(Badge),
    cheer: Option(Cheer),
    color: String,
    reply: Option(Reply),
    channel_points_custom_reward_id: Option(String),
    source_broadcaster_user_id: Option(String),
    source_broadcaster_user_name: Option(String),
    source_broadcaster_user_login: Option(String),
    source_message_id: Option(Uuid),
    source_badges: Option(List(Badge)),
    is_source_only: Option(Bool),
  )
}

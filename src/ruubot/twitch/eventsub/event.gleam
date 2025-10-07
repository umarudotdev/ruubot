import gleam/dynamic/decode
import gleam/option.{type Option}
import ruubot/internal
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

pub fn event_decoder() -> decode.Decoder(Event) {
  use broadcaster_user_id <- decode.field("broadcaster_user_id", decode.string)
  use broadcaster_user_name <- decode.field(
    "broadcaster_user_name",
    decode.string,
  )
  use broadcaster_user_login <- decode.field(
    "broadcaster_user_login",
    decode.string,
  )
  use chatter_user_id <- decode.field("chatter_user_id", decode.string)
  use chatter_user_name <- decode.field("chatter_user_name", decode.string)
  use chatter_user_login <- decode.field("chatter_user_login", decode.string)
  use message_id <- decode.field("message_id", internal.uuid_decoder())
  use message <- decode.field("message", message.message_decoder())
  use message_type <- decode.field("message_type", decode.string)
  use badges <- decode.field("badges", decode.list(message.badge_decoder()))
  use cheer <- decode.field("cheer", decode.optional(message.cheer_decoder()))
  use color <- decode.field("color", decode.string)
  use reply <- decode.field("reply", decode.optional(message.reply_decoder()))
  use channel_points_custom_reward_id <- decode.field(
    "channel_points_custom_reward_id",
    decode.optional(decode.string),
  )
  use source_broadcaster_user_id <- decode.field(
    "source_broadcaster_user_id",
    decode.optional(decode.string),
  )
  use source_broadcaster_user_name <- decode.field(
    "source_broadcaster_user_name",
    decode.optional(decode.string),
  )
  use source_broadcaster_user_login <- decode.field(
    "source_broadcaster_user_login",
    decode.optional(decode.string),
  )
  use source_message_id <- decode.field(
    "source_message_id",
    decode.optional(internal.uuid_decoder()),
  )
  use source_badges <- decode.field(
    "source_badges",
    decode.optional(decode.list(message.badge_decoder())),
  )
  use is_source_only <- decode.field(
    "is_source_only",
    decode.optional(decode.bool),
  )
  decode.success(ChannelChatMessageEvent(
    broadcaster_user_id:,
    broadcaster_user_name:,
    broadcaster_user_login:,
    chatter_user_id:,
    chatter_user_name:,
    chatter_user_login:,
    message_id:,
    message:,
    message_type:,
    badges:,
    cheer:,
    color:,
    reply:,
    channel_points_custom_reward_id:,
    source_broadcaster_user_id:,
    source_broadcaster_user_name:,
    source_broadcaster_user_login:,
    source_message_id:,
    source_badges:,
    is_source_only:,
  ))
}

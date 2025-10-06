import gleam/dynamic/decode
import gleam/option.{type Option}
import ruubot/twitch/eventsub/message.{
  type Badge, type Cheer, type Message, type Reply,
}

pub type Event {
  ChannelChatMessageEvent(ChannelChatMessage)
}

pub type ChannelChatMessage {
  ChannelChatMessage(
    broadcaster_user_id: String,
    broadcaster_user_login: String,
    broadcaster_user_name: String,
    chatter_user_id: String,
    chatter_user_login: String,
    chatter_user_name: String,
    message_id: String,
    message: Message,
    color: String,
    badges: List(Badge),
    message_type: String,
    cheer: Option(Cheer),
    reply: Option(Reply),
    channel_points_custom_reward_id: Option(String),
    channel_points_animation_id: Option(String),
    source_broadcaster_user_id: Option(String),
    source_broadcaster_user_login: Option(String),
    source_broadcaster_user_name: Option(String),
    source_message_id: Option(String),
    source_badges: Option(List(Badge)),
  )
}

pub fn channel_chat_message_payload_decoder() -> decode.Decoder(
  ChannelChatMessage,
) {
  use broadcaster_user_id <- decode.field("broadcaster_user_id", decode.string)
  use broadcaster_user_login <- decode.field(
    "broadcaster_user_login",
    decode.string,
  )
  use broadcaster_user_name <- decode.field(
    "broadcaster_user_name",
    decode.string,
  )
  use chatter_user_id <- decode.field("chatter_user_id", decode.string)
  use chatter_user_login <- decode.field("chatter_user_login", decode.string)
  use chatter_user_name <- decode.field("chatter_user_name", decode.string)
  use message_id <- decode.field("message_id", decode.string)
  use message <- decode.field("message", message.message_decoder())
  use color <- decode.field("color", decode.string)
  use badges <- decode.field("badges", decode.list(message.badge_decoder()))
  use message_type <- decode.field("message_type", decode.string)
  use cheer <- decode.field("cheer", decode.optional(message.cheer_decoder()))
  use reply <- decode.field("reply", decode.optional(message.reply_decoder()))
  use channel_points_custom_reward_id <- decode.field(
    "channel_points_custom_reward_id",
    decode.optional(decode.string),
  )
  use channel_points_animation_id <- decode.field(
    "channel_points_animation_id",
    decode.optional(decode.string),
  )
  use source_broadcaster_user_id <- decode.field(
    "source_broadcaster_user_id",
    decode.optional(decode.string),
  )
  use source_broadcaster_user_login <- decode.field(
    "source_broadcaster_user_login",
    decode.optional(decode.string),
  )
  use source_broadcaster_user_name <- decode.field(
    "source_broadcaster_user_name",
    decode.optional(decode.string),
  )
  use source_message_id <- decode.field(
    "source_message_id",
    decode.optional(decode.string),
  )
  use source_badges <- decode.field(
    "source_badges",
    decode.optional(decode.list(message.badge_decoder())),
  )
  decode.success(ChannelChatMessage(
    broadcaster_user_id:,
    broadcaster_user_login:,
    broadcaster_user_name:,
    chatter_user_id:,
    chatter_user_login:,
    chatter_user_name:,
    message_id:,
    message:,
    color:,
    badges:,
    message_type:,
    cheer:,
    reply:,
    channel_points_custom_reward_id:,
    channel_points_animation_id:,
    source_broadcaster_user_id:,
    source_broadcaster_user_login:,
    source_broadcaster_user_name:,
    source_message_id:,
    source_badges:,
  ))
}

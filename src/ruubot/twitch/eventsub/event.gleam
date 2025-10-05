import gleam/dynamic/decode
import ruubot/twitch/eventsub/message.{type Message}

pub type Event {
  ChannelChatMessageEvent(message: Message)
}

pub fn event_decoder() -> decode.Decoder(Event) {
  use message <- decode.field("message", message.message_decoder())
  decode.success(ChannelChatMessageEvent(message:))
}

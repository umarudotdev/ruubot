import gleam/dynamic/decode

pub type Message {
  Message(text: String)
}

pub fn message_decoder() -> decode.Decoder(Message) {
  use text <- decode.field("text", decode.string)
  decode.success(Message(text:))
}

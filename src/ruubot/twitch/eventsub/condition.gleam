import gleam/dynamic/decode

pub type Condition {
  ChannelChatMessageCondition(broadcaster_user_id: String, user_id: String)
}

pub fn condition_decoder() -> decode.Decoder(Condition) {
  use broadcaster_user_id <- decode.field("broadcaster_user_id", decode.string)
  use user_id <- decode.field("user_id", decode.string)
  decode.success(ChannelChatMessageCondition(broadcaster_user_id:, user_id:))
}

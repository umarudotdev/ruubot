import gleam/dynamic/decode
import ruubot/twitch/eventsub/condition.{type Condition}

pub type Subscription {
  Subscription(
    id: String,
    subscription_type: SubscriptionType,
    version: String,
    status: String,
    cost: Int,
    condition: Condition,
    created_at: String,
  )
}

pub fn subscription_decoder() -> decode.Decoder(Subscription) {
  use id <- decode.field("id", decode.string)
  use subscription_type <- decode.field(
    "subscription_type",
    subscription_type_decoder(),
  )
  use version <- decode.field("version", decode.string)
  use status <- decode.field("status", decode.string)
  use cost <- decode.field("cost", decode.int)
  use condition <- decode.field("condition", condition.condition_decoder())
  use created_at <- decode.field("created_at", decode.string)
  decode.success(Subscription(
    id:,
    subscription_type:,
    version:,
    status:,
    cost:,
    condition:,
    created_at:,
  ))
}

pub type SubscriptionType {
  ChannelChatMessage
}

pub fn subscription_type_decoder() -> decode.Decoder(SubscriptionType) {
  use variant <- decode.then(decode.string)
  case variant {
    "channel.chat.message" -> decode.success(ChannelChatMessage)
    _ -> decode.failure(ChannelChatMessage, "SubscriptionType")
  }
}

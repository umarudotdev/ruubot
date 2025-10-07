import gleam/dynamic/decode
import gleam/time/timestamp.{type Timestamp}
import ruubot/internal
import ruubot/twitch/eventsub/condition.{type Condition}
import ruubot/twitch/eventsub/transport.{type Transport}
import youid/uuid.{type Uuid}

pub type Subscription {
  Subscription(
    id: Uuid,
    subscription_type: SubscriptionType,
    version: String,
    status: String,
    cost: Int,
    condition: Condition,
    transport: Transport,
    created_at: Timestamp,
  )
}

pub fn subscription_decoder() -> decode.Decoder(Subscription) {
  use id <- decode.field("id", internal.uuid_decoder())
  use subscription_type <- decode.field(
    "subscription_type",
    subscription_type_decoder(),
  )
  use version <- decode.field("version", decode.string)
  use status <- decode.field("status", decode.string)
  use cost <- decode.field("cost", decode.int)
  use condition <- decode.field("condition", condition.condition_decoder())
  use transport <- decode.field("transport", transport.transport_decoder())
  use created_at <- decode.field("created_at", internal.timestamp_decoder())
  decode.success(Subscription(
    id:,
    subscription_type:,
    version:,
    status:,
    cost:,
    condition:,
    transport:,
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
    _ -> decode.failure(ChannelChatMessage, "Type")
  }
}

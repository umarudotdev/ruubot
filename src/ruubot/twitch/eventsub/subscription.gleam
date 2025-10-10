import gleam/time/timestamp.{type Timestamp}
import ruubot/twitch/eventsub/condition.{type Condition}
import ruubot/twitch/eventsub/transport.{type Transport}
import youid/uuid.{type Uuid}

pub type Subscription {
  Subscription(
    id: Uuid,
    subscription_type: Type,
    version: String,
    status: String,
    cost: Int,
    condition: Condition,
    transport: Transport,
    created_at: Timestamp,
  )
}

pub type Type {
  ChannelChatMessage
}

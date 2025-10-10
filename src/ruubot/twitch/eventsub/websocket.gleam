import gleam/option.{type Option}
import gleam/time/timestamp.{type Timestamp}
import ruubot/twitch/eventsub/event.{type Event}
import ruubot/twitch/eventsub/subscription.{
  type Subscription, type Type as SubscriptionType,
}

pub type Message {
  SessionWelcomeMessage(
    metadata: Metadata,
    payload: SessionWelcomeMessagePayload,
  )
  SessionKeepaliveMessage(metadata: Metadata)
  NotificationMessage(metadata: Metadata, payload: NotificationMessagePayload)
  SessionReconnectMessage(
    metadata: Metadata,
    payload: SessionReconnectMessagePayload,
  )
  RevocationMessage(metadata: Metadata, payload: RevocationMessagePayload)
}

pub type Metadata {
  Metadata(
    message_id: String,
    message_type: MessageType,
    message_timestamp: Timestamp,
  )
  SubscriptionMetadata(
    message_id: String,
    message_type: MessageType,
    message_timestamp: Timestamp,
    subscription_type: SubscriptionType,
    subscription_version: String,
  )
}

pub type MessageType {
  SessionWelcome
  SessionKeepalive
  Notification
  SessionReconnect
  Revocation
}

pub type SessionWelcomeMessagePayload {
  SessionWelcomeMessagePayload(session: Session)
}

pub type NotificationMessagePayload {
  NotificationMessagePayload(subscription: Subscription, event: Event)
}

pub type SessionReconnectMessagePayload {
  SessionReconnectMessagePayload(session: Session)
}

pub type RevocationMessagePayload {
  RevocationMessagePayload(subscription: Subscription)
}

pub type Session {
  Session(
    id: String,
    status: String,
    keepalive_timeout_seconds: Option(Int),
    reconnect_url: Option(String),
    connected_at: Timestamp,
  )
}

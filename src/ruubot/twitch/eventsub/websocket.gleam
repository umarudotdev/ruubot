import gleam/dynamic/decode
import gleam/option.{type Option}
import gleam/time/timestamp.{type Timestamp}
import ruubot/internal
import ruubot/twitch/eventsub/event.{type Event}
import ruubot/twitch/eventsub/subscription.{
  type Subscription, type SubscriptionType,
}

pub type Message {
  SessionWelcomeMessage(
    metadata: Metadata,
    payload: SessionWelcomeMessagePayload,
  )
  SessionKeepaliveMessage(metadata: Metadata)
  NotificationMessage(
    metadata: SubscriptionMetadata,
    payload: NotificationMessagePayload,
  )
  SessionReconnectMessage(
    metadata: Metadata,
    payload: SessionReconnectMessagePayload,
  )
  RevocationMessage(
    metadata: SubscriptionMetadata,
    payload: RevocationMessagePayload,
  )
}

pub type Metadata {
  Metadata(
    message_id: String,
    message_type: MessageType,
    message_timestamp: Timestamp,
  )
}

pub fn metadata_decoder() -> decode.Decoder(Metadata) {
  use message_id <- decode.field("message_id", decode.string)
  use message_type <- decode.field("message_type", message_type_decoder())
  use message_timestamp <- decode.field(
    "message_timestamp",
    internal.timestamp_decoder(),
  )
  decode.success(Metadata(message_id:, message_type:, message_timestamp:))
}

pub type SubscriptionMetadata {
  SubscriptionMetadata(
    message_id: String,
    message_type: MessageType,
    message_timestamp: Timestamp,
    subscription_type: SubscriptionType,
    subscription_version: String,
  )
}

pub fn subscription_metadata_decoder() -> decode.Decoder(SubscriptionMetadata) {
  use message_id <- decode.field("message_id", decode.string)
  use message_type <- decode.field("message_type", message_type_decoder())
  use message_timestamp <- decode.field(
    "message_timestamp",
    internal.timestamp_decoder(),
  )
  use subscription_type <- decode.field(
    "subscription_type",
    subscription.subscription_type_decoder(),
  )
  use subscription_version <- decode.field(
    "subscription_version",
    decode.string,
  )
  decode.success(SubscriptionMetadata(
    message_id:,
    message_type:,
    message_timestamp:,
    subscription_type:,
    subscription_version:,
  ))
}

pub type MessageType {
  SessionWelcome
  SessionKeepalive
  Notification
  SessionReconnect
  Revocation
}

pub fn message_type_decoder() -> decode.Decoder(MessageType) {
  use variant <- decode.then(decode.string)
  case variant {
    "session_welcome" -> decode.success(SessionWelcome)
    "session_keepalive" -> decode.success(SessionKeepalive)
    "notification" -> decode.success(Notification)
    "session_reconnect" -> decode.success(SessionReconnect)
    "revocation" -> decode.success(Revocation)
    _ -> decode.failure(SessionWelcome, "MessageType")
  }
}

pub type SessionWelcomeMessagePayload {
  SessionWelcomeMessagePayload(session: Session)
}

pub fn session_welcome_message_payload_decoder() -> decode.Decoder(
  SessionWelcomeMessagePayload,
) {
  use session <- decode.field("session", session_decoder())
  decode.success(SessionWelcomeMessagePayload(session:))
}

pub type NotificationMessagePayload {
  NotificationMessagePayload(subscription: Subscription, event: Event)
}

pub fn notification_message_payload_decoder() -> decode.Decoder(
  NotificationMessagePayload,
) {
  use subscription <- decode.field(
    "subscription",
    subscription.subscription_decoder(),
  )
  use event <- decode.field("event", event.event_decoder())
  decode.success(NotificationMessagePayload(subscription:, event:))
}

pub type SessionReconnectMessagePayload {
  SessionReconnectMessagePayload(session: Session)
}

pub fn session_reconnect_message_payload_decoder() -> decode.Decoder(
  SessionReconnectMessagePayload,
) {
  use session <- decode.field("session", session_decoder())
  decode.success(SessionReconnectMessagePayload(session:))
}

pub type RevocationMessagePayload {
  RevocationMessagePayload(subscription: Subscription)
}

pub fn revocation_message_payload_decoder() -> decode.Decoder(
  RevocationMessagePayload,
) {
  use subscription <- decode.field(
    "subscription",
    subscription.subscription_decoder(),
  )
  decode.success(RevocationMessagePayload(subscription:))
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

pub fn session_decoder() -> decode.Decoder(Session) {
  use id <- decode.field("id", decode.string)
  use status <- decode.field("status", decode.string)
  use keepalive_timeout_seconds <- decode.field(
    "keepalive_timeout_seconds",
    decode.optional(decode.int),
  )
  use reconnect_url <- decode.field(
    "reconnect_url",
    decode.optional(decode.string),
  )
  use connected_at <- decode.field("connected_at", internal.timestamp_decoder())
  decode.success(Session(
    id:,
    status:,
    keepalive_timeout_seconds:,
    reconnect_url:,
    connected_at:,
  ))
}

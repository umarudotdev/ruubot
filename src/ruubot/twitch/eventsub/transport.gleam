import gleam/option.{type Option}
import gleam/time/timestamp.{type Timestamp}

pub type Transport {
  WebhookTransport(callback: Option(String), secret: Option(String))
  WebsocketTransport(
    session_id: Option(String),
    connected_at: Option(Timestamp),
    disconnected_at: Option(Timestamp),
  )
}

pub type Method {
  Webhook
  Websocket
}

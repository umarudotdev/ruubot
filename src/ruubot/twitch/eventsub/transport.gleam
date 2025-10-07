import gleam/dynamic/decode
import gleam/option.{type Option}
import gleam/time/timestamp.{type Timestamp}
import ruubot/internal

pub type Transport {
  WebhookTransport(callback: Option(String), secret: Option(String))
  WebsocketTransport(
    session_id: Option(String),
    connected_at: Option(Timestamp),
    disconnected_at: Option(Timestamp),
  )
}

pub fn transport_decoder() -> decode.Decoder(Transport) {
  use variant <- decode.field("method", method_decoder())
  case variant {
    Webhook -> {
      use callback <- decode.field("callback", decode.optional(decode.string))
      use secret <- decode.field("secret", decode.optional(decode.string))
      decode.success(WebhookTransport(callback:, secret:))
    }
    Websocket -> {
      use session_id <- decode.field(
        "session_id",
        decode.optional(decode.string),
      )
      use connected_at <- decode.field(
        "connected_at",
        decode.optional(internal.timestamp_decoder()),
      )
      use disconnected_at <- decode.field(
        "disconnected_at",
        decode.optional(internal.timestamp_decoder()),
      )
      decode.success(WebsocketTransport(
        session_id:,
        connected_at:,
        disconnected_at:,
      ))
    }
  }
}

pub type Method {
  Webhook
  Websocket
}

pub fn method_decoder() -> decode.Decoder(Method) {
  use variant <- decode.then(decode.string)
  case variant {
    "webhook" -> decode.success(Webhook)
    "websocket" -> decode.success(Websocket)
    _ -> decode.failure(Webhook, "Method")
  }
}

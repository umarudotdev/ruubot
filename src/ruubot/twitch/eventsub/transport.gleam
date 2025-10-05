import gleam/dynamic/decode
import gleam/option.{type Option}

pub type Transport {
  Transport(
    method: TransportMethod,
    session_id: Option(String),
    connected_at: Option(String),
    disconnected_at: Option(String),
  )
}

pub fn transport_decoder() -> decode.Decoder(Transport) {
  use method <- decode.field("method", transport_method_decoder())
  use session_id <- decode.field("session_id", decode.optional(decode.string))
  use connected_at <- decode.field(
    "connected_at",
    decode.optional(decode.string),
  )
  use disconnected_at <- decode.field(
    "disconnected_at",
    decode.optional(decode.string),
  )
  decode.success(Transport(
    method:,
    session_id:,
    connected_at:,
    disconnected_at:,
  ))
}

pub type TransportMethod {
  Webhook
  Websocket
}

pub fn transport_method_decoder() -> decode.Decoder(TransportMethod) {
  use variant <- decode.then(decode.string)
  case variant {
    "webhook" -> decode.success(Webhook)
    "websocket" -> decode.success(Websocket)
    _ -> decode.failure(Webhook, "TransportMethod")
  }
}

import gleam/dynamic/decode.{type Decoder}
import gleam/time/timestamp.{type Timestamp}
import youid/uuid.{type Uuid}

pub fn timestamp_decoder() -> Decoder(Timestamp) {
  use string <- decode.then(decode.string)
  case timestamp.parse_rfc3339(string) {
    Ok(timestamp) -> decode.success(timestamp)
    Error(_) -> decode.failure(timestamp.from_unix_seconds(0), "Timestamp")
  }
}

pub fn uuid_decoder() -> Decoder(Uuid) {
  use string <- decode.then(decode.string)
  case uuid.from_string(string) {
    Ok(uuid) -> decode.success(uuid)
    Error(_) -> decode.failure(uuid.nil, "Uuid")
  }
}

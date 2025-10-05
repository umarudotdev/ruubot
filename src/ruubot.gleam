import dot_env
import dot_env/env
import gleam/dynamic/decode
import gleam/erlang/process
import gleam/function
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/json
import gleam/option
import gleam/result
import gleam/string
import gleam/uri
import glow_auth
import glow_auth/access_token
import glow_auth/token_request
import glow_auth/uri/uri_builder
import logging
import stratus

pub fn main() {
  logging.configure()
  logging.set_level(logging.Debug)

  dot_env.load_default()

  let assert Ok(id) = env.get_string("CLIENT_ID")
  let assert Ok(secret) = env.get_string("CLIENT_SECRET")
  let assert Ok(site) = uri.parse("https://id.twitch.tv/oauth2")

  let req =
    glow_auth.Client(id, secret, site)
    |> token_request.client_credentials(
      uri_builder.RelativePath("token"),
      token_request.RequestBody,
      token_request.ScopeList(["user:read:chat"]),
    )

  use resp <- result.try(httpc.send(req))

  echo resp.body

  let assert Ok(access_token) =
    access_token.decode_token_from_response(resp.body)

  let assert Ok(req) = request.to("https://eventsub.wss.twitch.tv/ws")
  let builder =
    stratus.websocket(
      request: req,
      init: fn() { #(Nil, option.None) },
      loop: fn(state, msg, _conn) {
        case msg {
          stratus.Text(msg) -> {
            let assert Ok(session_id) =
              msg
              |> json.parse(decode.at(
                ["payload", "session", "id"],
                decode.string,
              ))

            let assert Ok(user_id) =
              request.new()
              |> request.set_method(http.Get)
              |> request.set_scheme(http.Https)
              |> request.set_host("api.twitch.tv")
              |> request.set_path("/helix/users")
              |> request.set_header("Client-ID", id)
              |> request.set_header(
                "Authorization",
                "Bearer " <> access_token.access_token,
              )
              |> request.set_query([
                #("login", "UmaruDotDev"),
              ])
              |> httpc.send
              |> result.map(fn(resp) { resp.body })
              |> result.map(fn(body) {
                json.parse(
                  from: body,
                  using: decode.at(["data", "0", "id"], decode.string),
                )
              })
              |> result.lazy_unwrap(fn() { panic })

            let req =
              request.new()
              |> request.set_method(http.Post)
              |> request.set_scheme(http.Https)
              |> request.set_host("api.twitch.tv")
              |> request.set_path("/helix/eventsub/subscriptions")
              |> request.set_header("Client-ID", id)
              |> request.set_header(
                "Authorization",
                "Bearer " <> access_token.access_token,
              )
              |> request.set_header("Content-Type", "application/json")
              |> request.set_body(
                json.object([
                  #("type", json.string("channel.chat.message")),
                  #("version", json.string("1")),
                  #(
                    "condition",
                    json.object([
                      #("broadcaster_user_id", json.string("1374928980")),
                      #("user_id", json.string("1374928980")),
                    ]),
                  ),
                  #(
                    "transport",
                    json.object([
                      #("method", json.string("websocket")),
                      #("session_id", json.string(session_id)),
                    ]),
                  ),
                ])
                |> json.to_string(),
              )

            let _ = httpc.send(req)

            stratus.continue(state)
          }
          _msg -> stratus.continue(state)
        }
      },
    )

  let assert Ok(subj) = stratus.initialize(builder)

  let assert Ok(owner) = process.subject_owner(subj.data)
  let done =
    process.new_selector()
    |> process.select_specific_monitor(
      process.monitor(owner),
      function.identity,
    )
    |> process.selector_receive_forever

  logging.log(
    logging.Info,
    "WebSocket process exited: " <> string.inspect(done),
  )

  Ok(resp)
}

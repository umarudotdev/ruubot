import gleam/dynamic/decode

pub type Message {
  Message(text: String, fragments: List(Fragment))
}

pub fn message_decoder() -> decode.Decoder(Message) {
  use text <- decode.field("text", decode.string)
  use fragments <- decode.field("fragments", decode.list(fragment_decoder()))
  decode.success(Message(text:, fragments:))
}

pub type Fragment {
  TextFragment(text: String)
  EmoteFragment(text: String, emote: Emote)
  CheermoteFragment(text: String, cheermote: Cheermote)
  MentionFragment(text: String, mention: Mention)
}

pub fn fragment_decoder() -> decode.Decoder(Fragment) {
  use variant <- decode.field("type", decode.string)
  case variant {
    "text_fragment" -> {
      use text <- decode.field("text", decode.string)
      decode.success(TextFragment(text:))
    }
    "emote_fragment" -> {
      use text <- decode.field("text", decode.string)
      use emote <- decode.field("emote", emote_decoder())
      decode.success(EmoteFragment(text:, emote:))
    }
    "cheermote_fragment" -> {
      use text <- decode.field("text", decode.string)
      use cheermote <- decode.field("cheermote", cheermote_decoder())
      decode.success(CheermoteFragment(text:, cheermote:))
    }
    "mention_fragment" -> {
      use text <- decode.field("text", decode.string)
      use mention <- decode.field("mention", mention_decoder())
      decode.success(MentionFragment(text:, mention:))
    }
    _ -> decode.failure(TextFragment(""), "Fragment")
  }
}

pub type Emote {
  Emote(id: String, emote_set_id: String, format: List(String))
}

pub fn emote_decoder() -> decode.Decoder(Emote) {
  use id <- decode.field("id", decode.string)
  use emote_set_id <- decode.field("emote_set_id", decode.string)
  use format <- decode.field("format", decode.list(decode.string))
  decode.success(Emote(id:, emote_set_id:, format:))
}

pub type Cheermote {
  Cheermote(prefix: String, bits: Int, tier: Int)
}

pub fn cheermote_decoder() -> decode.Decoder(Cheermote) {
  use prefix <- decode.field("prefix", decode.string)
  use bits <- decode.field("bits", decode.int)
  use tier <- decode.field("tier", decode.int)
  decode.success(Cheermote(prefix:, bits:, tier:))
}

pub type Mention {
  Mention(user_id: String, user_name: String, user_login: String)
}

pub fn mention_decoder() -> decode.Decoder(Mention) {
  use user_id <- decode.field("user_id", decode.string)
  use user_name <- decode.field("user_name", decode.string)
  use user_login <- decode.field("user_login", decode.string)
  decode.success(Mention(user_id:, user_name:, user_login:))
}

pub type Badge {
  Badge(set_id: String, id: String, info: String)
}

pub fn badge_decoder() -> decode.Decoder(Badge) {
  use set_id <- decode.field("set_id", decode.string)
  use id <- decode.field("id", decode.string)
  use info <- decode.field("info", decode.string)
  decode.success(Badge(set_id:, id:, info:))
}

pub type Cheer {
  Cheer(bits: Int)
}

pub fn cheer_decoder() -> decode.Decoder(Cheer) {
  use bits <- decode.field("bits", decode.int)
  decode.success(Cheer(bits:))
}

pub type Reply {
  Reply(
    parent_message_id: String,
    parent_message_body: String,
    parent_user_id: String,
    parent_user_name: String,
    parent_user_login: String,
    thread_message_id: String,
    thread_user_id: String,
    thread_user_name: String,
    thread_user_login: String,
  )
}

pub fn reply_decoder() -> decode.Decoder(Reply) {
  use parent_message_id <- decode.field("parent_message_id", decode.string)
  use parent_message_body <- decode.field("parent_message_body", decode.string)
  use parent_user_id <- decode.field("parent_user_id", decode.string)
  use parent_user_name <- decode.field("parent_user_name", decode.string)
  use parent_user_login <- decode.field("parent_user_login", decode.string)
  use thread_message_id <- decode.field("thread_message_id", decode.string)
  use thread_user_id <- decode.field("thread_user_id", decode.string)
  use thread_user_name <- decode.field("thread_user_name", decode.string)
  use thread_user_login <- decode.field("thread_user_login", decode.string)
  decode.success(Reply(
    parent_message_id:,
    parent_message_body:,
    parent_user_id:,
    parent_user_name:,
    parent_user_login:,
    thread_message_id:,
    thread_user_id:,
    thread_user_name:,
    thread_user_login:,
  ))
}

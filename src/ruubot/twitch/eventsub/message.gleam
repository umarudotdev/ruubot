pub type Message {
  Message(text: String, fragments: List(Fragment))
}

pub type Fragment {
  TextFragment(text: String)
  CheermoteFragment(text: String, cheermote: Cheermote)
  EmoteFragment(text: String, emote: Emote)
  MentionFragment(text: String, mention: Mention)
}

pub type Cheermote {
  Cheermote(prefix: String, bits: Int, tier: Int)
}

pub type Emote {
  Emote(
    id: String,
    emote_set_id: String,
    owner_id: String,
    format: List(String),
  )
}

pub type Mention {
  Mention(user_id: String, user_name: String, user_login: String)
}

pub type Badge {
  Badge(set_id: String, id: String, info: String)
}

pub type Cheer {
  Cheer(bits: Int)
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

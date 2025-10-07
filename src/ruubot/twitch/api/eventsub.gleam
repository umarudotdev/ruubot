import ruubot/twitch/eventsub/condition.{type Condition}
import ruubot/twitch/eventsub/subscription.{type Subscription}

pub type CreateEventsubSubscriptionRequest {
  CreateSubscriptionRequest(
    subscription_type: subscription.SubscriptionType,
    version: String,
    condition: Condition,
    transport: TransportRequest,
  )
}

pub type TransportRequest {
  WebhookTransport(callback: String, secret: String)
  WebsocketTransport(session_id: String)
}

pub type CreateEventsubSubscriptionResponse {
  CreateSubscriptionResponse(
    data: List(Subscription),
    total: Int,
    total_cost: Int,
    max_total_cost: Int,
  )
}

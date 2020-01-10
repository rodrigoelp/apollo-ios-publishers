//

import Foundation
import Combine
import Apollo

/// Publisher capable of broadcasting changes based on the provided subscription.
/// Once subscribed the server might respond with a GraphQLResult<T> containing errors, these errors are omitted
/// from the broadcast... at least on this implementation.
@available(iOS 13, *)
public struct GraphQLSubscriptionPublisher<Subscription: GraphQLSubscription>: Publisher {
    public typealias Output = Optional<Subscription.Data>
    public typealias Failure = Error

    private let client: ApolloClient
    private let subscription: Subscription

    init(client: ApolloClient, subscription: Subscription) {
        self.client = client
        self.subscription = subscription
    }

    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Error, S.Input == Optional<Subscription.Data> {
        let subscription = GraphQLSubscriptionSubscription(client: self.client, subscription: self.subscription, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

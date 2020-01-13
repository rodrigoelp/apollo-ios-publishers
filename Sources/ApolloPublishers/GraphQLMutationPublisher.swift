//

import Foundation
import Combine
import Apollo

/// Publisher performing a mutation on the server and attempting to obtain the result of it.
@available(iOS 13, *)
public struct GraphQLMutationPublisher<Mutation: GraphQLMutation>: Publisher {
    public typealias Output = GraphQLResult<Mutation.Data>
    public typealias Failure = Error

    private let client: ApolloClient
    private let mutation: Mutation
    private let context: UnsafeMutableRawPointer?

    init(client: ApolloClient,
         mutation: Mutation,
         context: UnsafeMutableRawPointer? = nil) {
        self.client = client
        self.mutation = mutation
        self.context = context
    }

    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Error, S.Input == GraphQLResult<Mutation.Data> {
        let subscription = GraphQLMutationSubscription(client: self.client,
                                                    mutation: self.mutation,
                                                    context: self.context,
                                                    subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

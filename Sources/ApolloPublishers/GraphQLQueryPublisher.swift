//

import Foundation
import Combine
import Apollo

/// Publisher fetching items matching the provided query.
///
/// The results will be obtained from a cache or from the remote server as specified in the cache policy. are omitted
/// Once the results have been obtained, the publisher will be marked as finished.
@available(iOS 13, *)
public struct GraphQLQueryPublisher<Query: GraphQLQuery>: Publisher {
    public typealias Output = GraphQLResult<Query.Data>
    public typealias Failure = Error

    private let client: ApolloClient
    private let query: Query
    private let cachePolicy: CachePolicy
    private let context: UnsafeMutableRawPointer?

    init(client: ApolloClient, query: Query, cachePolicy: CachePolicy = .returnCacheDataElseFetch, context: UnsafeMutableRawPointer? = nil) {
        self.client = client
        self.query = query
        self.cachePolicy = cachePolicy
        self.context = context
    }

    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Error, S.Input == GraphQLResult<Query.Data> {
        let subscription = GraphQLQuerySubscription(client: self.client,
                                                    query: self.query,
                                                    cachePolicy: self.cachePolicy,
                                                    context: self.context,
                                                    subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

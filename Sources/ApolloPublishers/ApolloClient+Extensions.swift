import Foundation
import Combine
import Apollo

@available(iOS 13, *)
extension ApolloClient {

    /// Fetches a query from the server or from the local cache, depending on the current contents of the cache and the specified cache policy.
    ///
    /// - Parameters:
    ///   - query: The query to fetch.
    ///   - cachePolicy: [optional] A cache policy that specifies when results should be fetched from the server and when data should be loaded from the local cache.
    ///   - context: [optional] A context to use for the cache to work with results. Should default to nil.
    /// - Returns: A Future publisher containing the result of the query.
    @available(iOS 13, *)
    public func fetchPublisher<Query: GraphQLQuery>(query: Query,
                                             cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                             context: UnsafeMutableRawPointer? = nil) -> Future<GraphQLResult<Query.Data>, Error> {
        return Future { [weak self] completion in
            self?.fetch(query: query, cachePolicy: cachePolicy, context: context) { result in completion(result) }
        }
    }

    /// Performs a mutation by sending it to the server.
    ///
    /// - Parameters:
    ///   - mutation: The mutation to perform.
    ///   - context: [optional] A context to use for the cache to work with results. Should default to nil.
    /// - Returns: A future publisher with the result of the mutation.
    @available(iOS 13, *)
    public func performPublisher<Mutation: GraphQLMutation>(mutation: Mutation,
                                                            context: UnsafeMutableRawPointer? = nil) -> Future<GraphQLResult<Mutation.Data>, Error> {
        return Future { [weak self] completion in
            self?.perform(mutation: mutation, context: context) { result in completion(result) }
        }
    }

    /// Creates a subscription to the given subscription model.
    ///
    /// - Parameters:
    ///   - subscription: The subscription to subscribe to.
    /// - Returns: A subscription publisher, subscribed to the server. Disposing this publisher causes the subscription to be terminated.
    @available(iOS 13, *)
    public func subscribePublisher<Subscription: GraphQLSubscription>(subscription: Subscription) -> GraphQLSubscriptionPublisher<Subscription> {
        return publisher(for: subscription)
    }

    @available(iOS 13, *)
    public func publisher<Subscription: GraphQLSubscription>(for subscription: Subscription) -> GraphQLSubscriptionPublisher<Subscription> {
        return GraphQLSubscriptionPublisher(client: self, subscription: subscription)
    }
}

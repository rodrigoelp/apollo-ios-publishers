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
                                                    context: UnsafeMutableRawPointer? = nil)
        -> GraphQLQueryPublisher<Query> {
            return GraphQLQueryPublisher(client: self, query: query, cachePolicy: cachePolicy, context: context)
    }

    /// Performs a mutation by sending it to the server.
    ///
    /// - Parameters:
    ///   - mutation: The mutation to perform.
    ///   - context: [optional] A context to use for the cache to work with results. Should default to nil.
    /// - Returns: A future publisher with the result of the mutation.
    @available(iOS 13, *)
    public func performPublisher<Mutation: GraphQLMutation>(mutation: Mutation,
                                                            context: UnsafeMutableRawPointer? = nil)
        -> GraphQLMutationPublisher<Mutation> {
            return GraphQLMutationPublisher(client: self, mutation: mutation, context: context)
    }

    /// Creates a subscription to the given subscription model.
    ///
    /// - Parameters:
    ///   - subscription: The subscription to subscribe to.
    /// - Returns: A subscription publisher, subscribed to the server. Disposing this publisher causes the subscription to be terminated.
    @available(iOS 13, *)
    public func subscribePublisher<Subscription: GraphQLSubscription>(subscription: Subscription)
        -> GraphQLSubscriptionPublisher<Subscription> {
            return publisher(for: subscription)
    }

    /// Creates a subscription to the given subscription model.
    ///
    /// - Parameters:
    ///   - subscription: The subscription to subscribe to.
    /// - Returns: A subscription publisher, subscribed to the server. Disposing this publisher causes the subscription to be terminated.
    @available(iOS 13, *)
    public func publisher<Subscription: GraphQLSubscription>(for subscription: Subscription)
        -> GraphQLSubscriptionPublisher<Subscription> {
            return GraphQLSubscriptionPublisher(client: self, subscription: subscription)
    }

    /// Performs file upload to a GraphQL endpoint.
    ///
    /// - Parameters:
    ///   - upload: Upload operation against which the upload occurs.
    ///   - files: Set of files to upload.
    ///   - context: [optional] A context to use for the cache to work with results. Should default to nil.
    /// - Returns: A publisher with the results of the upload operations.
    @available(iOS 13, *)
    public func uploadPublisher<UploadOperation: GraphQLOperation>(upload: UploadOperation, files: [GraphQLFile], context: UnsafeMutableRawPointer? = nil)
        -> GraphQLUploadPublisher<UploadOperation> {
            return GraphQLUploadPublisher(client: self, operation: upload, files: files, context: context)
    }
}

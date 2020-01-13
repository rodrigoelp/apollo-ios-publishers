//

import Foundation
import Combine
import Apollo

@available(iOS 13, *)
public final class GraphQLQuerySubscription<GraphQuery: GraphQLQuery, SubscriberType: Subscriber>: Subscription
where SubscriberType.Input == GraphQLResult<GraphQuery.Data>, SubscriberType.Failure == Error {

    private let subscriber: SubscriberType
    private var cancellable: Apollo.Cancellable? = nil

    init(client: ApolloClient, query: GraphQuery,
         cachePolicy: CachePolicy = .returnCacheDataElseFetch,
         context: UnsafeMutableRawPointer?,
         subscriber: SubscriberType) {

        self.subscriber = subscriber
        self.cancellable = client.fetch(query: query,
                                        cachePolicy: cachePolicy,
                                        context: context,
                                        resultHandler: self.handle)
    }

    deinit {
        cancellable?.cancel()
    }

    public func request(_ demand: Subscribers.Demand) { }

    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }

    public func handle(result: Result<GraphQLResult<GraphQuery.Data>, Error>) {
        switch result {
            case .success(let resultSet):
                _ = subscriber.receive(resultSet)
            case .failure(let e):
                subscriber.receive(completion: .failure(e))
        }
        subscriber.receive(completion: .finished)
    }
}

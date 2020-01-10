//

import Foundation
import Combine
import Apollo

///
@available(iOS 13, *)
public final class GraphQLSubscriptionSubscription<SubscriberType: Subscriber, GraphSubscription: GraphQLSubscription>: Subscription
where SubscriberType.Input == Optional<GraphSubscription.Data>, SubscriberType.Failure == Error {

    private var subscriber: SubscriberType?
    private var cancellable: Apollo.Cancellable? = nil

    public init(client: ApolloClient, subscription: GraphSubscription, subscriber: SubscriberType) {
        self.subscriber = subscriber
        cancellable = client.subscribe(
            subscription: subscription,
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

    private func handle(result: Result<GraphQLResult<GraphSubscription.Data>, Error>) {
        switch result {
            case .success(let resultSet):
                print("Results!")
                _ = subscriber?.receive(resultSet.data)
            case .failure(let e):
                print("Errors!")
                subscriber?.receive(completion: Subscribers.Completion<Error>.failure(e))
                subscriber?.receive(completion: .finished)
        }
    }
}

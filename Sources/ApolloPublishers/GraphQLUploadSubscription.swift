//

import Foundation
import Combine
import Apollo

@available(iOS 13, *)
public final class GraphQLUploadSubscription<GraphOperation: GraphQLOperation, SubscriberType: Subscriber>: Subscription
where SubscriberType.Input == GraphQLResult<GraphOperation.Data>, SubscriberType.Failure == Error {

    private let subscriber: SubscriberType
    private var cancellable: Apollo.Cancellable? = nil

    init(client: ApolloClient,
         operation: GraphOperation,
         files: [GraphQLFile],
         context: UnsafeMutableRawPointer?,
         subscriber: SubscriberType) {

        self.subscriber = subscriber
        self.cancellable = client.upload(
            operation: operation,
            context: context,
            files: files,
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

    public func handle(result: Result<GraphQLResult<GraphOperation.Data>, Error>) {
        switch result {
            case .success(let resultSet):
                _ = subscriber.receive(resultSet)
            case .failure(let e):
                subscriber.receive(completion: .failure(e))
        }
        subscriber.receive(completion: .finished)
    }
}

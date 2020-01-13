//

import Foundation
import Combine
import Apollo

/// Publisher performing file upload to the GraphQL backend.
@available(iOS 13, *)
public struct GraphQLUploadPublisher<UploadOperation: GraphQLOperation>: Publisher {
    public typealias Output = GraphQLResult<UploadOperation.Data>
    public typealias Failure = Error

    private let client: ApolloClient
    private let operation: UploadOperation
    private let files: [GraphQLFile]
    private let context: UnsafeMutableRawPointer?

    init(client: ApolloClient, operation: UploadOperation, files: [GraphQLFile], context: UnsafeMutableRawPointer? = nil) {
        self.client = client
        self.operation = operation
        self.files = files
        self.context = context
    }

    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Error, S.Input == GraphQLResult<UploadOperation.Data> {
        let subscription = GraphQLUploadSubscription(client: self.client,
                                                    operation: self.operation,
                                                    files: self.files,
                                                    context: self.context,
                                                    subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}


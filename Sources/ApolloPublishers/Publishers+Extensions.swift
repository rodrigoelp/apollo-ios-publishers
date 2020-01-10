//

import Foundation
import Combine
import Apollo

@available(iOS 13, *)
extension Publisher {

    @available(iOS 13, *)
    public func asPureResult<T>() -> AnyPublisher<T, Failure> where Output == GraphQLResult<T>, Failure == Error {
        return self.flatMap({ result -> Future<T, Failure> in
            return Future { completion in
                let newResult: Result<T, Failure>
                if let errors = result.errors {
                    newResult = .failure(GraphQLCompoundError.contained(errors: errors) as Error)
                } else if let data = result.data {
                    newResult = .success(data)
                } else {
                    newResult = .failure(GraphQLCompoundError.resultIsEmpty as Error)
                }
                completion(newResult)
            }
            }).eraseToAnyPublisher()
    }
}

@available(iOS 13, *)
public enum GraphQLCompoundError: Error {
    case contained(errors: [Error])
    case resultIsEmpty
}

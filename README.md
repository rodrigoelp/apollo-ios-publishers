# Apollo iOS Publishers

Apollo iOS is a strongly-typed, caching GraphQL client for iOS exposed as publishers for the convinience of those using Swift 5.0 and the [Combine](https://developer.apple.com/documentation/combine) framework.

It allows you to execute queries, mutations and subscriptions against a GraphQL Server whilst maintaining a pure observable approach.

## How to use it?

Let's assume you the following schema:

```graphql
type ToDo {
    id: ID!
    title: String!
}

query GetToDoList {
    todos {
        id
        title
    }
}
```

Once you have configured your project as described in the Apollo iOS configuration you will be able to write the following code:

```swift
func fetchTodos() -> AnyPublisher<[GetToDoList.Data.Todos], Error> {
    return client
        .fetchPublisher(query: GetToDoListQuery())
        .map { $0.data?.todos }
        .filter { $0 != nil }
        .map { $0! }
        .eraseToAnyPublisher()
}
```

## Why should I use this?

Dealing with callbacks isn't pretty and it can make you code hard to maintain.

Let's assume you have created an instance of Apollo and you configured it to a given endpoint. You would normally write the following code to fetch a list of to do items from the server:

```swift
func fetchTodos(completion: @escaping ([GetToDoListQuery.Data.ToDos]?) -> void) {
    client.fetch(query: GetToDoListQuery()) { response in
        switch response {
            case .success(let resultSet):
                completion(results.data.todos)
            case .failure(let e):
                throw e
        }
    }
}
```

(and you will be writing this code a lot!)

With publishers the code above turns into:

```swift
fetch fetchTodos() -> AnyPublisher<[GetToDoListQuery.Data.ToDos]?, Error> {
    return client.fetchPublisher(query: GetToDoListQuery())
        .map { $0.data?.todos }
        .eraseToAnyPublisher()
}
```

## What is the catch?

[Combine](https://developer.apple.com/documentation/combine) framework has dependency on `iOS 13.0+`, `macOS 10.15+`, etc. And allows you to create in a declarative way the pathway to your code. [Combine](https://developer.apple.com/documentation/combine) is Apple's response to [RxSwift](https://github.com/ReactiveX/RxSwift) which implements reactive extensions, but Combine interacts smoothly with [Swift UI](https://developer.apple.com/xcode/swiftui/) which allows you to write better apps with less code.

Eventually Apollo will implement its own version of these publishers at which point we will have no use for this. So, why use it? It allows you write cleaner code, think in terms of promises, futures and those sort of async "boxes"

## Apollo iOS Documentation

[Read the full docs at apollographql.com/docs/ios/](https://www.apollographql.com/docs/ios/)

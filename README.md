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
        .map { $0.data.todos }
        .filter { $0 != nil }
        .map { $0! }
        .eraseToAnyPublisher()
}
```

## Apollo iOS Documentation

[Read the full docs at apollographql.com/docs/ios/](https://www.apollographql.com/docs/ios/)

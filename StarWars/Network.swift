import Foundation
import Apollo

struct Network {
    static let shared = ApolloClient(url: URL(string: "https://swapi-graphql.netlify.com/.netlify/functions/index")!)
}

import SwiftUI
import Apollo

struct QueryView<Content: View, Query: GraphQLQuery>: View {
    typealias ResultTuple = (data: Query.Data?, errors: [GraphQLError]?, refetch: () -> Void, cancel: () -> Void)
    
    var content: (ResultTuple) -> Content
    
    @ObservedObject var model: Q<Query>
    
    init(_ query: Query, @ViewBuilder content: @escaping (ResultTuple) -> Content) {
        self.model = Q(query: query)
        self.content = content
    }
    
    var body: some View {
        content((data: model.data, errors: model.errors, refetch: model.refetch, cancel: model.cancel))
    }
}

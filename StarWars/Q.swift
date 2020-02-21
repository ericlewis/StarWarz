import Apollo
import SwiftUI

class Q<Query: GraphQLQuery>: ObservableObject {
    
    @Published var data: Query.Data? = nil
    @Published var errors: [GraphQLError]? = nil
    
    private var cancellable: Cancellable?
    private var watcher: GraphQLQueryWatcher<Query>?
    
    init(query: Query, watch: Bool = true) {
        if watch {
            watcher = Network.shared.watch(query: query) {
                switch $0 {
                case .success(let result):
                    self.data = result.data
                    self.errors = result.errors
                case .failure(_):
                    break
                }
            }
        } else {
            cancellable = Network.shared.fetch(query: query) {
                switch $0 {
                case .success(let result):
                    self.data = result.data
                    self.errors = result.errors
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func cancel() {
        watcher?.cancel()
        cancellable?.cancel()
    }
    
    func refetch() {
        watcher?.refetch()
    }
    
    deinit {
        cancellable?.cancel()
        watcher?.cancel()
    }
}

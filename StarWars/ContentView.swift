import SwiftUI
import Apollo

extension PeopleQuery.Data {
    var flattenedEdges: [Self.AllPerson.Edge.Node] {
        allPeople?.edges?.compactMap { $0?.node } ?? []
    }
}

extension PlanetsQuery.Data {
    var flattenedEdges: [Self.AllPlanet.Edge.Node] {
        allPlanets?.edges?.compactMap { $0?.node } ?? []
    }
}

struct PeopleIteratedView: View {
    var body: some View {
        QueryView(PeopleQuery()) { apollo in
            if apollo.data == nil && apollo.errors == nil {
                Text("Loading")
            }
            
            apollo.data.map { data in
                ForEach(data.flattenedEdges) { person in
                    person.name.map { Text($0).font(.headline) }
                }
            }
        }
    }
}

struct PlanetsIteratedView: View {
    var body: some View {
        QueryView(PlanetsQuery()) { apollo in
            if apollo.data == nil && apollo.errors == nil {
                Text("Loading")
            }
            
            apollo.data.map { data in
                ForEach(data.flattenedEdges) { person in
                    person.name.map { Text($0).font(.headline) }
                }
            }
        }
    }
}

extension FilmsQuery.Data {
    var flattenedEdges: [Self.AllFilm.Edge.Node] {
        allFilms?.edges?.compactMap { $0?.node } ?? []
    }
}

struct FilmsIteratedView: View {
    var body: some View {
        QueryView(FilmsQuery()) { apollo in
            if apollo.data == nil && apollo.errors == nil {
                Text("Loading")
            }
            
            apollo.data.map { data in
                ForEach(data.flattenedEdges) { movie in
                    VStack(alignment: .leading) {
                        movie.title.map { Text($0).font(.headline) }
                        HStack {
                            movie.director.map { Text($0) }
                            movie.releaseDate.map { Text($0) }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Films"), content: FilmsIteratedView.init)
                Section(header: Text("People"), content: PeopleIteratedView.init)
                Section(header: Text("Planets"), content: PlanetsIteratedView.init)
            }
            .navigationBarTitle("Star Trek")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

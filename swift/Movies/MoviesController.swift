//  MIT License
//
//  Copyright (c) 2018 Pablo Pallocchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

final class MoviesController: UIViewController {
    
    @IBOutlet var moviesTableView: UITableView!
    
    private var movies: [Movie] = []
    private let repository = MoviesRepository()
    
    override func viewDidLoad() {
        movies = repository.top()
    }

}

//MARK: - SearchBar

extension MoviesController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            movies = repository.search(text: searchText)
        } else {
            movies = repository.top()
        }
        moviesTableView.reloadData()
    }
    
}

//MARK: - TableView

extension MoviesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return MovieCell()
        }
        let movie = movies[indexPath.row]
        cell.setup(movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}

//MARK: TableViewCell

final class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"
    
    let imageBasePath = "https://image.tmdb.org/t/p/w200"
    
    @IBOutlet weak var poster: URLImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var year: UILabel!
    
    func setup(_ movie: Movie) {
        poster.image = UIImage(named: "Poster")
        poster.from(link: imageBasePath + movie.poster)
        title.text = movie.title
        overview.text = movie.overview
        year.text = String(movie.year)
    }
    
}

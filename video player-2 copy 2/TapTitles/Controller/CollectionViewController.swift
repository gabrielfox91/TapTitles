//
//  ViewController.swift
//  collectionView.TT
//
//  Created by Michelangelo Di Giacomo on 03/06/2019.
//  Copyright © 2019 Michelangelo Di Giacomo. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  let movies = ["upload", "TED", "2001Odissea", "Film 3", "Film 4", "Film 5", "Film 6", "Film 7", "Film 8"]  //create array (?)
  
  let movieImages : [UIImage] = [
    UIImage(named: "upload")!,
    UIImage(named: "2001 Odissea")!,
    UIImage(named: "TED")!,
    UIImage(named: "film3")!,
    UIImage(named: "film4")!,
    UIImage(named: "film5")!,
    UIImage(named: "film6")!,
    UIImage(named: "film7")!,
    UIImage(named: "film8")!,
  ]
  
  var searchMovies = [String]()
  var searching = false
  var videoName = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    videoName = movies[indexPath.row]
    performSegue(withIdentifier: "playVideo", sender: nil)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if searching {
      return searchMovies.count
    }else{
      return movies.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
    if searching {
      cell.movieLabel.text = searchMovies[indexPath.item]
      cell.movieImageView.image = movieImages[indexPath.item]
      
    }else{
      cell.movieLabel.text = movies[indexPath.item]
      cell.movieImageView.image = movieImages[indexPath.item]
    }
    return cell
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchMovies = movies.filter({$0.prefix(searchText.count) == searchText})
    searching = true
    collectionView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? VideoViewController {
      destination.videoName = videoName
    }
  }
}

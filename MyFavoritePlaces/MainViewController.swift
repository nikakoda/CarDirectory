//
//  MainTableViewController.swift

//
//  Created by Ника Перепелкина on 01/09/2019.
//  Copyright © 2019 Nika Perepelkina. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var cars: Results<Car>!
    private var filteredCars : Results<Car>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // запрос
        cars = realm.objects(Car.self)
        
        // настройка search controller
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false // возможность взаимодействовать
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true // опустить строку поиска при переходе на другой экран
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCars.count
        }
        
        return cars.isEmpty ? 0 : cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        
        var car = Car()
        
        if isFiltering {
            car = filteredCars[indexPath.row]
        } else {
            car = cars[indexPath.row]
        }
        
        
        
        cell.nameLabel.text = car.name
        cell.yearLabel.text = car.year
        cell.manufacturerLabel.text = car.manufacturer
        cell.imageOfPlaces.image = UIImage(data: car.imageData!)
        
        cell.imageOfPlaces.layer.cornerRadius = cell.imageOfPlaces.frame.size.height / 2
        cell.imageOfPlaces.clipsToBounds = true
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // удалить свайпом
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let car = cars[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            
            StorageManager.deleteObject(car)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return[deleteAction]
    }
    
  
     

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let car: Car
            if isFiltering {
                car = filteredCars[indexPath.row]
            } else {
                car = cars[indexPath.row]
            }
            
            
            
            let newCarVC = segue.destination as! NewCarViewController
            newCarVC.currentCar = car
        }
        
     }
 
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newCarVC = segue.source as? NewCarViewController else { return }
        newCarVC.saveCar()
        
        tableView.reloadData()
    }
    
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
       sorting()
    }
    
    
    @IBAction func reversedSorting(_ sender: Any) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cars = cars.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            cars = cars.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
}


extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredCars = cars.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
    
    
}

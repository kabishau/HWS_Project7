import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var vcTitle = "Full List of Petitions"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = vcTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsButtonTapped))
        navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped)), UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))]
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            //urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            //urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return // prevent of showing the error by exiting the method
            }
        }
        showError()
        
    }
    
    @objc func creditsButtonTapped() {
        let alertController = UIAlertController(title: "Information", message: "This data comes from the \"We The People\" API of the Whitehouse", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func refreshButtonTapped() {
        filteredPetitions = petitions
        self.title = vcTitle
        tableView.reloadData()
    }
    
    @objc func searchButtonTapped() {
        
        let alertController = UIAlertController(title: "Search Petition", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Type the topic here"
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak alertController] (action) in
            guard let phrase = alertController?.textFields?[0].text else { return }
            self?.search(by: phrase)
        }
        alertController.addAction(searchAction)
        
        present(alertController, animated: true)
    }
    
    func search(by phrase: String) {
        if phrase == "" {
            
            let alertController = UIAlertController(title: "Error", message: "You can't search nothing... Please type something and try again.", preferredStyle: .alert)
            let searchAgainAction = UIAlertAction(title: "Search Again", style: .default) { (action) in
                self.searchButtonTapped()
            }
            alertController.addAction(searchAgainAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        filteredPetitions = []
        for petition in petitions {
            if petition.title.lowercased().contains(phrase.lowercased()) {
                filteredPetitions.append(petition)
            }
        }
        self.title = "Filtered by: \(phrase)"
        tableView.reloadData()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    func showError() {
        let alertController = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


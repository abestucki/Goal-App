import UIKit

struct Goal {
    var name: String
    var completionDates: [Date]
    
    var completionPercentage: Double {
        let totalDays = Date().timeIntervalSince(completionDates.first!)
        let completedDays = completionDates.count
        return Double(completedDays) / totalDays * 100
    }
}

class User {
    var username: String
    var password: String
    var profilePicture: UIImage?
    var goals: [Goal] = []
    var friends: [User] = []
    
    init(username: String, password: String, profilePicture: UIImage? = nil) {
        self.username = username
        self.password = password
        self.profilePicture = profilePicture
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func checkOffGoal(at index: Int) {
        let goal = goals[index]
        goal.completionDates.append(Date())
    }
    
    func removeGoal(at index: Int) {
        goals.remove(at: index)
    }
    
    func addFriend(_ user: User) {
        friends.append(user)
    }
    
    func removeFriend(at index: Int) {
        friends.remove(at: index)
    }
}

class GoalTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentUser: User
    
    var goalsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        // Add goals table view to the view hierarchy
        view.addSubview(goalsTableView)
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
        // Setup constraints for the goals table view
        NSLayoutConstraint.activate([
            goalsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            goalsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goalsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            goalsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "goalCell")
        cell.textLabel?.text = currentUser.goals[indexPath.row].name
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Goal Options", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Check Off Goal", style: .default, handler: { _ in
            self.currentUser.checkOffGoal(at: indexPath.row)
            self.goalsTableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "View History", style: .default, handler: { _ in
            let goalHistoryViewController = GoalHistoryViewController(goal: self.currentUser.goals[indexPath.row])
            self.navigationController?.pushViewController(goalHistoryViewController, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

class AddGoalViewController: UIViewController {
    var currentUser: User
    
    var goalNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter goal name"
        return textField
    }()
    
    var addButton: UIButton = {
        let button = UIButton

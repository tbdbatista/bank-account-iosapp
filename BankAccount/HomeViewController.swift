//
//  HomeViewController.swift
//  BankAccount
//
//  Created by Beltrami Dias Batista, Thiago on 25/10/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    let header = HomeHeaderView(frame: .zero)
    
    var accounts: [HomeAccountResponse]?
    lazy var stackView = UIStackView()
    lazy var logoutButton = UIBarButtonItem()
    lazy var tableView = UITableView()
    
    var homeHeaderProfile = HomeHeaderModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSelfSetup()
        setSelfView()
        setViews()
        accounts = viewModel.fetchData()
        self.loadNetworkData()
    }
    
    private func setSelfSetup() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(tableView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
        
    private func setSelfView() {
        self.view.backgroundColor = .white
    }

    private func setViews() {
        setStackView()
        setLogoutButton()
        setupTableView()
        setupHeaderTableView()
        setupNavBar()
        setupHeaderProfile()
    }
    
    private func setStackView() {
        stackView.axis = .vertical
        stackView.spacing = 0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setLogoutButton() {
//        logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(callLogout))
        logoutButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(callLogout))
    }
    
    private func setupHeaderProfile() {
        self.homeHeaderProfile.welcomeMessage = "Welcome to the B.A. Bank."
        self.homeHeaderProfile.date = Date()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondaryGreen

        tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
        tableView.rowHeight = 90
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    private func setupHeaderTableView() {
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        tableView.tableHeaderView = header
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = logoutButton
        self.navigationController?.navigationBar.backgroundColor = .secondaryGreen
        self.navigationController?.navigationBar.tintColor = .primaryGreen
    }
    
    //MARK: - Methods - Actions
    @objc private func callLogout(sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    //MARK: - Load network data
    private func loadNetworkData() {
        self.viewModel.getAccountProfileData(completion: { result, error in
            guard let result = result else {
                print(error ?? "Error getting Account Profile Data")
                return
            }
            self.homeHeaderProfile.name = result as String
            
            DispatchQueue.main.async {
                self.header.nameLabel.text = "Hello, " + self.homeHeaderProfile.name! + "."
                self.header.welcomeLabel.text = self.homeHeaderProfile.welcomeMessage
                self.header.dateLabel.text = "Today is " + self.homeHeaderProfile.dateFormatted + "."
                self.tableView.tableHeaderView = self.header
                self.tableView.reloadData()
            }
        })
    }
}

//MARK: - Extension - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let accounts = accounts else {return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reuseID, for: indexPath) as! HomeCell
        cell.configure(response: accounts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts?.count ?? 0
    }
}

//MARK: - Extension - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
    }
}

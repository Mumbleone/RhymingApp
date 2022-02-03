//
//  ViewController.swift
//  Rhymes
//
//  Created by Adrian Devezin on 4/19/21.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var bindings: [AnyCancellable] = []
    private var tableView: UITableView!
    private var textInput: UITextField!
    private var searchButton: UIButton!
    private var rows: [String] = []
    private let viewModel = ViewModel()
    var activityView: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        
        let cancellable = viewModel.$viewState.sink(receiveValue: { viewState in
            switch viewState {
            
            case .initial:
                break
            case let .error(message):
                self.setError(message)
            case .loading:
                self.showActivityIndicator()
            case let .rhymes(rhymes):
                self.setRhymes(rhymes: rhymes)
            }
        })
        bindings.append(cancellable)
    }
    
    private func setError(_ message: String) {
        hideActivityIndicator()
        showDialog(message)
    }
    
    private func setRhymes(rhymes: [String]) {
        hideActivityIndicator()
        rows = rhymes
        tableView.reloadData()
    }
    
    private func showDialog(_ message: String) {
        let dialog = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { _ in }))
        present(dialog, animated: true, completion: nil)
    }
    
    private func createView() {
        createInputView()
        createSearchButton()
        createTableView()
    }
    
    private func createInputView() {
        textInput = UITextField()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.borderStyle = .roundedRect
        textInput.layer.borderColor = UIColor.black.cgColor
        textInput.placeholder = "Enter Word To Rhyme"
        
        view.addSubview(textInput)
        
        textInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        textInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        textInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
    }
    
    private func createSearchButton() {
        searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle("Find Rhymes", for: .normal)
        searchButton.setTitleColor(UIColor.blue, for: .normal)
        searchButton.addTarget(self, action: #selector(onRhymesClicked), for: .touchUpInside)
        
        view.addSubview(searchButton)
        
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let inputGuide = UILayoutGuide()
        view.addLayoutGuide(inputGuide)
        inputGuide.bottomAnchor.constraint(equalTo: textInput.bottomAnchor).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: inputGuide.bottomAnchor, constant: 8).isActive = true
    }
    
    @objc func onRhymesClicked() {
        let word = textInput.text
        viewModel.onGetRhymesClicked(word: word ?? "")
    }
    
    private func createTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        view.addSubview(tableView)
        
        let searchButtonGuide = UILayoutGuide()
        view.addLayoutGuide(searchButtonGuide)
        searchButtonGuide.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchButtonGuide.bottomAnchor, constant: 16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func showActivityIndicator() {
        if activityView == nil {
            activityView = UIActivityIndicatorView(style: .large)
            activityView?.center = self.view.center
            activityView?.layer.cornerRadius = 8
            activityView?.backgroundColor = UIColor.black
            activityView?.hidesWhenStopped = true
            activityView?.alpha = 0.8
            view.addSubview(activityView!)
            activityView?.translatesAutoresizingMaskIntoConstraints = false
            activityView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            activityView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            activityView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            activityView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator() {
        if (activityView != nil) {
            activityView?.stopAnimating()
        }
    }

}


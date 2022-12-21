//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import UIKit
import Combine
import SharedModels
import Favorites

public final class EventsViewController: UIViewController {
    enum Section {
        case main
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    let viewModel: EventsViewModel
    var dataSource: UITableViewDiffableDataSource<Section, Event>!
    let cellIdentifier = "cellIdentifier"
    var searchController = UISearchController(searchResultsController: nil)
    var cancellable: Cancellable?
    
    public init(viewModel: EventsViewModel = EventsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        view.backgroundColor = .systemBackground
        setup()
        Task {
            await viewModel.onViewDidLoad()
        }
    }

    private func setup() {
        setupNavigationItem()
        setupSearchController()
        setupTableView()
        setupBinding()
    }

    private func setupNavigationItem() {
        navigationItem.rightBarButtonItems = [FavoritesButtonItem()]
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Fiter Events"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.prefetchDataSource = self
        setupDataSource()
    }

    private func setupDataSource() {
        let cellProvider: UITableViewDiffableDataSource<Section, Event>.CellProvider =
        { [ weak self] (tableView: UITableView, indexPath: IndexPath, event: Event) -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            let content = EventContentConfiguration(event: event)
            cell.contentConfiguration = content
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .clear
            cell.backgroundConfiguration = background
            return cell
        }
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: cellProvider)
        updateUI()
    }

    private func updateUI() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Event>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.events)
        dataSource.apply(snapshot)
    }

    func setupBinding() {
        cancellable = viewModel
            .$events
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.updateUI()
            }
    }

}

extension EventsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.color = .black
            return activityIndicator
        }()

        let view = UIView()
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicator.startAnimating()
        return view
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }

}

extension EventsViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
    }

}

extension EventsViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}

extension EventsViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        Task {
            await viewModel.fetchAdditionalEventsIfNeeded(for: indexPaths)
        }
    }
}

//
//  ViewController.swift
//  ArchitectureDemo
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import UIKit
import SharedModels
import Combine
import Favorites

public final class CharacterListViewController: UIViewController {
    enum Section {
        case main
    }

    let refreshControl = UIRefreshControl()

    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: viewModel.sortSegments)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(onSegmentChanged), for: .valueChanged)
        return control
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    var dataSource: UITableViewDiffableDataSource<Section, MarvelCharacter>!
    let cellIdentifier = "cellIdentifier"
    let viewModel: CharacterListViewModel
    var cancellables: Set<AnyCancellable> = []

    public init(viewModel: CharacterListViewModel = CharacterListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        Task {
            await viewModel.onViewDidLoad()
        }
    }

    private func setup() {
        title = "Characters"
        view.backgroundColor = .systemBackground
        setupRefereshControl()
        setupNavigationItem()
        setupSegmentedControl()
        setupTableView()
        setupBinding()
    }

    private func setupNavigationItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [FavoritesButtonItem()]
    }

    private func setupRefereshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc
    private func refresh() {
        Task {
            await viewModel.refresh()
            refreshControl.endRefreshing()
        }
    }

    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.prefetchDataSource = self
        setupDataSource()
    }

    private func setupDataSource() {
        let cellProvider: UITableViewDiffableDataSource<Section, MarvelCharacter>.CellProvider =
        { [ weak self] (tableView: UITableView, indexPath: IndexPath, character: MarvelCharacter) -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            let content = MarvelCharacterConfiguration(character: character)
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, MarvelCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(viewModel.characters))
        dataSource.apply(snapshot)
    }

    private func setupBinding() {
        viewModel
            .$characters
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }

    @objc
    private func onSegmentChanged() {
        viewModel.onSegmentChanged(segmentedControl.selectedSegmentIndex)
        scrollToTop()
    }

    private func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
}

extension CharacterListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        let viewModel = CharacterDetailViewModel(character: character)
        let viewController = UINavigationController(rootViewController: CharacterDetailViewController(viewModel: viewModel))
        self.present(viewController, animated: true)
    }

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

extension CharacterListViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        Task {
            await viewModel.fetchAdditionalCharactersIfNeeded(for: indexPaths)
        }
    }
}

#if DEBUG
import SwiftUIHelpers

struct CharacterListViewController_previews: PreviewProvider {
    static var previews: some View {
        let characterListViewModel = CharacterListViewModel()
        let vc = UINavigationController(rootViewController: CharacterListViewController(viewModel: characterListViewModel))
        return vc.preview
    }
}

#endif

//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-16.
//

import UIKit
import SharedModels
import Combine
import UIHelpers

public class FavoritesViewController: UIViewController {
    enum Section {
        case main
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    var dataSource: DataSource!
    let cellIdentifier = "cellIdentifier"
    let viewModel: FavoritesViewModel
    var cancellable: Cancellable?

    public init(viewModel: FavoritesViewModel = FavoritesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        setup()
    }

    private func setup() {
        setupNavigationItem()
        setupTableView()
        setupBinding()
    }

    private func setupNavigationItem() {
        let editingItem = UIBarButtonItem(title: tableView.isEditing ? "Done" : "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        editingItem.tintColor = .orange
        navigationItem.rightBarButtonItems = [editingItem, FavoritesButtonItem()]
    }

    @objc
    func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        setupNavigationItem()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        setupDataSource()
    }

    private func setupDataSource() {
        let cellProvider: UITableViewDiffableDataSource<Section, MarvelCharacter>.CellProvider =
        { [ weak self] (tableView: UITableView, indexPath: IndexPath, character: MarvelCharacter) -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            let content = FavoriteCharacterConfiguration(character: character)
            cell.contentConfiguration = content
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .clear
            cell.backgroundConfiguration = background
            return cell
        }
        dataSource = DataSource(
            viewModel: viewModel,
            tableView: tableView,
            cellProvider: cellProvider)
        updateUI(favorites: [])
    }

    private func updateUI(favorites: [MarvelCharacter]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MarvelCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favorites)
        dataSource.apply(snapshot)
    }

    private func setupBinding() {
        cancellable = viewModel
            .$favorites
            .sink { [ weak self] updatedFavorites in
                self?.updateBackgroundView()
                self?.updateUI(favorites: updatedFavorites)
            }
    }

    private func updateBackgroundView() {
        tableView.backgroundView = viewModel.favorites.isEmpty ? backgroundViewForTableView() : nil
    }

    private func backgroundViewForTableView() -> UIView {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have no favorites"

        let backgroundView = UIView()
        backgroundView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        return backgroundView
    }
}

extension FavoritesViewController {
    class DataSource: UITableViewDiffableDataSource<Section, MarvelCharacter> {
        let viewModel: FavoritesViewModel

        init(viewModel: FavoritesViewModel,
             tableView: UITableView,
             cellProvider: @escaping UITableViewDiffableDataSource<FavoritesViewController.Section, MarvelCharacter>.CellProvider) {
            self.viewModel = viewModel
            super.init(tableView: tableView, cellProvider: cellProvider)
        }

        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            true
        }

        override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//            guard let sourceCharacter = itemIdentifier(for: sourceIndexPath) else { return }
//            guard sourceIndexPath != destinationIndexPath else { return }
//            let destinationCharacter = itemIdentifier(for: destinationIndexPath)

//            var snapshot = self.snapshot()
//
//            if let destinationCharacter = destinationCharacter,
//               let sourceIndex = snapshot.indexOfItem(destinationCharacter),
//               let destinationIndex = snapshot.indexOfItem(destinationCharacter) {
//                let isAfter = destinationIndex > sourceIndex &&
//                   snapshot.sectionIdentifier(containingItem: sourceCharacter) ==
//                    snapshot.sectionIdentifier(containingItem: destinationCharacter)
//
//                snapshot.deleteItems([sourceCharacter])
//                if isAfter {
//                    snapshot.insertItems([sourceCharacter], afterItem: destinationCharacter)
//                } else {
//                    snapshot.insertItems([sourceCharacter], beforeItem: destinationCharacter)
//                }
//            } else {
//                let destinationSection = snapshot.sectionIdentifiers[destinationIndexPath.section]
//                snapshot.deleteItems([sourceCharacter])
//                snapshot.appendItems([sourceCharacter], toSection: destinationSection)
//            }

           // apply(snapshot, animatingDifferences: false)
            viewModel.reorderFavorites(sourceIndex: sourceIndexPath, destinationIndex: destinationIndexPath)
        }

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete, let character = itemIdentifier(for: indexPath) else { return }
            viewModel.deleteFavorite(character)
        }

    }
}


#if DEBUG

struct FavoritesViewController_previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FavoritesViewModel()
        let vc = UINavigationController(rootViewController: FavoritesViewController(viewModel: viewModel))
        return vc.preview
    }
}

#endif

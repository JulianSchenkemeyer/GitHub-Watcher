//
//  SearchResultsViewController.swift
//  GitHub-Watcher
//
//  Created by Julian Schenkemeyer on 04.12.22.
//

import UIKit

class SearchResultsViewController: UIViewController {

	enum Section {
		case user, repository
	}

	weak var coordinator: SearchCoordinatorProtocol!

	var searchterm: String!
	var users: [UserReference] = []

	let requestManager = RequestManager()
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, UserReference>!

	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = false
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()

		searchUsers()
    }

	private func searchUsers() {
		Task {
			guard let users: UserSearchResults = try await requestManager.perform(SearchRequest.findMatchingUsers(searchString: searchterm, page: 1, perPage: 50)) else {
				return
			}
			self.users = users.items
			updateData()
		}


	}

	private func configure() {
		configureCollectionView()
		configureDataSource()
	}

	private func configureFlowLayout() -> UICollectionViewFlowLayout {
		let width = view.bounds.width
		let xPadding: CGFloat = 20
		let yPadding: CGFloat = 10

		let availableWidth = width - (2 * xPadding)
		let itemWidth = availableWidth
		let itemHeight: Double = 60

		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: yPadding, left: xPadding, bottom: yPadding, right: xPadding)
		flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)

		return flowLayout
	}

	private func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureFlowLayout())
		collectionView.delegate = self

		view.addSubview(collectionView)
		collectionView.backgroundColor = .systemBackground
		collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
	}

	private func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, UserReference>(collectionView: collectionView, cellProvider: {
			(collectionView, indexPath, owner) -> UICollectionViewCell? in

			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.reuseId, for: indexPath) as! UserCell
			cell.set(name: owner.login)
			cell.backgroundColor = .systemGray

			return cell
		})
	}

	private func updateData() {
		var snapshot = NSDiffableDataSourceSnapshot<Section, UserReference>()
		snapshot.appendSections([.user])
		snapshot.appendItems(users, toSection: .user)
		dataSource.apply(snapshot, animatingDifferences: true)
	}
}

extension SearchResultsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let selectedUser = users[indexPath.item]
		print(selectedUser)

		coordinator.openDetails(for: selectedUser.login)
	}
}

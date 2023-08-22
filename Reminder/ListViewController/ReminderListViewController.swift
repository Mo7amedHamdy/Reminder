//
//  ViewController.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 19/04/2022.
//

import UIKit
import UserNotifications

class ReminderListViewController: UICollectionViewController {
    
    lazy var datasource = makeDataSource()
    
    var reminders: [Reminder] = []
    
    var listStyle: ReminderListStyle = .today
    
    var filteredReminders: [Reminder] {
        return reminders.filter{listStyle.shouldInclude(date: $0.dueDate)}
//            .sorted {$0.dueDate < $1.dueDate}
    }
    
    let listStyleSegmentConroll: UISegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name])
    
    //supplementary header
    var headerView: ProgressHeaderView?
    
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        let progress = filteredReminders.reduce(0.0) { partialResult, reminder in
            let chunk = reminder.isComplete ? chunkSize : 0
            return partialResult + chunk
        }
        return progress
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
//        updateSnapshots()
        
        //add reminder button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        collectionView.backgroundColor = .todayGradientFutureBegin
        
        listStyleSegmentConroll.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentConroll.addTarget(self, action: #selector(didChangeListStyle), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentConroll
        
        //supplementary header
        //The registration handler specifies
        //how to configure the content and appearance of the supplementary view.
        let headerRegisteration = UICollectionView.SupplementaryRegistration(elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegisterationHandler)
        
        //After registering the supplementary view,
        //you need to pass the registration in a method
        //that dequeues a reusable supplementary view object.
        //You’ll call the method from the data source’s supplementaryViewProvider.
        datasource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegisteration, for: indexPath)
        }
        prepareReminderstore()
    }
    
    //to apply gradiant layer
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func showDetails(for id: Reminder.ID) {
        let reminder = reminder(for: id)
        let RVC = ReminderViewController(reminder: reminder) { [weak self] newReminder in
            self?.update(newReminder, with: newReminder.id)
            self?.updateSnapshots(reloading: [newReminder.id])
        }
        navigationController?.pushViewController(RVC, animated: true)
    }
    
    //The system calls this method
    //when the collection view is about to display the supplementary view.
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == ProgressHeaderView.elementKind,
              let progressView = view as? ProgressHeaderView
        else {
            return
        }
        progressView.progress = progress
    }
    
    //add gradiant layer
    func refreshBackground() {
        collectionView.backgroundView = nil
        let backgrounView = UIView()
        let gradiantLayer = CAGradientLayer.gradiantLayer(for: listStyle, in: collectionView.frame)
        backgrounView.layer.addSublayer(gradiantLayer)
        collectionView.backgroundView = backgrounView
    }
    
    //show errors
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alert.addAction(actionOk)
        present(alert, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
        showDetails(for: id)
        return false
    }

    //creates compositional layout that contains only list sections of the specified configuration
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        listConfiguration.headerMode = .supplementary //supplementary header
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = datasource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] action, view, completion in
            self?.deleteReminder(with: id)
            self?.updateSnapshots()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
  
    //create diffable data source
    private func makeDataSource() -> DataSource {
        let reminderCellregisteration = self.reminderCellRegisteration()
        return DataSource(collectionView: collectionView) { (collectionView: UICollectionView,
                                                             indexPath: IndexPath,
                                                             itemIdentifier: Reminder.ID) -> UICollectionViewCell? in
              collectionView.dequeueConfiguredReusableCell(using: reminderCellregisteration, for: indexPath, item: itemIdentifier)
        }
    }
    
    //create registered cell
    private func reminderCellRegisteration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return .init(handler: cellRegisterationHandler(cell:indexPath:id:))
    }
        
    //create snapshots
    func updateSnapshots(reloading idsThatChanged: [Reminder.ID] = []) {
        let ids = idsThatChanged.filter{ id in
            filteredReminders.contains{ $0.id == id }
        }
        var initialSnapshot = Snapshot()
//        let reminderItems = reminders.map{ $0.id } //array of reminder.id [String]
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(filteredReminders.map { $0.id })
        if !ids.isEmpty {
            initialSnapshot.reloadItems(ids)
        }
        datasource.apply(initialSnapshot)
        headerView?.progress = progress
    }
    
    //supplementary header
    private func supplementaryRegisterationHandler(
        progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath) {
        headerView = progressView
    }
    
    //test -> create basic compositional layout
//    func createBasicCompositionalLayout() -> UICollectionViewLayout {
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }
   
}


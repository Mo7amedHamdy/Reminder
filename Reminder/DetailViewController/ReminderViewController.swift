//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Mohamed Hamdy on 05/05/2022.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    lazy var datasource =  makeDataSource()
    var reminder: Reminder {
        didSet{
            onChange(reminder)
        }
    }
    var workingReminder: Reminder
    var onChange: (Reminder)->Void
    var isAddingNewReminder:Bool = false
    
    init(reminder: Reminder, onChange: @escaping (Reminder)->Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
        
    }
    
    //TODO understand this
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem //new
        updateSnapshotForViewing()
        
    }
    
    @objc func didCancelEdit() {
        workingReminder = reminder
        setEditing(false, animated: true)
    }
    
    //toggle when edit button clicked
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
            prepareForEditing()
        }
        else {
            if !isAddingNewReminder {
                prepareForViewing()
            }
            else {
                onChange(workingReminder)
            }
        }
    }
    
    func cellRegisterationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) { //new ( importance of tuples )
        case (_, .header(let title)) :
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _) :
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, _) : //new
            cell.contentConfiguration = titleConfiguration(for: cell, at: row)
        case (.date, .editDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case (.notes, .editText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        default:
            fatalError("Unexpected combination of section and row.")
        }
    }
    
    
    func makeDataSource() -> Datasource {
        let cellRegisteration = UICollectionView.CellRegistration(handler: cellRegisterationHandler)
        datasource = Datasource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
        })
        return datasource
    }
    
    func prepareForEditing() {
        updateSnapshotForEditing()
    }
    
    func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        snapshot.appendItems([.header(Section.title.name), .viewTitle], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editText(reminder.notes)], toSection: .notes)
        datasource.apply(snapshot)
    }
    
    func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingReminder != reminder {
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }
    
    func updateSnapshotForViewing() {
        var snapshop = Snapshot()
        snapshop.appendSections([.view])
        snapshop.appendItems([.header(Section.view.name), .viewTitle, .viewDate, .viewTime, .viewNotes], toSection: .view)
        datasource.apply(snapshop)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else { fatalError("Unable to find matching section") }
        return section
    }
}

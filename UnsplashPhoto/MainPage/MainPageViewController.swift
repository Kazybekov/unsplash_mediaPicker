import UIKit

class MainPageViewController: UIViewController {
    
    let presenter = MainPagePresenter()
    
    var singleColumn: Bool = false {
        didSet {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            if singleColumn {
                layout.itemSize = CGSize(width: self.view.frame.width - 20, height: self.view.frame.width - 4)
            } else {
                let length = self.view.frame.width / 2 - 20
                layout.itemSize = CGSize(width: length, height: length + 16)
            }
            collectionView.reloadData()
        }
    }
    
    private lazy var dataReloader: () -> Void = {
        self.loadingView.isHidden = true
        self.activityIndicator.stopAnimating()
        self.collectionView.reloadData()
    }
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "Unsplash.com"
        label.font = UIFont(name: "Arial", size: 55)
        label.textColor = ColorProvider.text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.searchBarStyle = .minimal
        bar.tintColor = ColorProvider.text
        if let textField = bar.searchTextField.leftView as? UIImageView {
            textField.tintColor = ColorProvider.text
        }
        let textField = bar.searchTextField
        let placeholderText = "Search here..."
        let placeholderColor = ColorProvider.text
        
        textField.textColor = placeholderColor
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        return bar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let length = self.view.frame.width/2 - 20
        layout.itemSize = CGSize(width: length , height: length + 16)
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: "ImageCell"
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.split.2x2.fill"), for: .normal)
        button.setImage(UIImage(systemName: "square.split.1x2.fill"), for: .selected)
        button.tintColor = ColorProvider.text
        button.addTarget(self, action: #selector(toggleLayout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private func startSearch(input: String) {
        collectionView.isHidden = true
        loadingView.isHidden = false
        activityIndicator.startAnimating()
        presenter.handleInput(input: input, dataReload: dataReloader)
    }
    
    @objc private func toggleLayout() {
        singleColumn.toggle()
        toggleButton.isSelected.toggle()
        collectionView.reloadData()
    }
    
    private func setDelegates() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupLayout()
        setDelegates()
    }
}

extension MainPageViewController {
    private func setupLayout() {
        view.backgroundColor = ColorProvider.background
        
        view.addSubview(pageTitle)
        view.addSubview(searchBar)
        view.addSubview(toggleButton)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        loadingView.isHidden = true
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 64)
        ])
                
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8),
            toggleButton.heightAnchor.constraint(equalToConstant: 64),
        ])
        
        NSLayoutConstraint.activate([
            pageTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageTitle.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 100),
            loadingView.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
        ])
        loadingView.isHidden = true
    }
}

extension MainPageViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        presenter.suggestions = []
        collectionView.isHidden = true
        pageTitle.isHidden = true
        if presenter.shouldShowHistory {
            presenter.suggestions = presenter.history
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
        searchBar.topAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.topAnchor,
            constant: 8
        ).isActive = true
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter.suggestions = presenter.history
            tableView.isHidden = presenter.history.isEmpty
        } else {
            presenter.suggestions =
            presenter.allSuggestions.filter { $0.lowercased().contains(searchText.lowercased()) }
            tableView.isHidden = presenter.suggestions.isEmpty
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.resignFirstResponder()
        tableView.isHidden = true
        startSearch(input: searchText)
        collectionView.isHidden = presenter.images.isEmpty ? true : false
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.isHidden = true
        collectionView.isHidden = true
    }
}

extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomTableViewCell()
        cell.textLabel?.text = presenter.suggestions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = presenter.suggestions[indexPath.row]
        searchBar.text = selectedSuggestion
        searchBar.resignFirstResponder()
        tableView.isHidden = true
        startSearch(input: selectedSuggestion)
        collectionView.isHidden = presenter.images.isEmpty ? true : false
        collectionView.reloadData()
    }
}

extension MainPageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        collectionView.isHidden = false
        return presenter.images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ImageCell",
            for: indexPath
        ) as! ImageCollectionViewCell
        cell.setData(data: presenter.images[indexPath.item])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
        guard let data = cell?.data else { return }
        let vc = DetailsViewController(data: data)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

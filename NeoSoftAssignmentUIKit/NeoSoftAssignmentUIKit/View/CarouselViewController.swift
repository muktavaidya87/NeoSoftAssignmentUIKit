//
//  CarouselViewController.swift
//  NeoSoftAssignmentUIKit
//
//  Created by Mukta on 22/12/24.
//

import UIKit

class CarouselViewController: UIViewController {

    private var viewModel: CarouselViewModel
    private var pageViewController: UIPageViewController!
    private var tableView: UITableView!
    private var searchBar: UISearchBar!
    private var bottomSheetButton: UIButton!
    private var bottomSheetView: UIView!
    private var pageControl: UIPageControl!
    
    // Initialize with ViewModel
    init(viewModel: CarouselViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white



        // ScrollView
        let scrollView = UIScrollView()
        view.addSubview(scrollView)

        // Container view for scrollView content
        let containerView = UIView()
        scrollView.addSubview(containerView)

        
        // Page View Controller (Carousel)
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self

        if let firstViewController = getPageViewController(forIndex: viewModel.currentIndex) {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false)
        }

        containerView.addSubview(pageViewController.view)

        // Page Control (Dots)
        pageControl = UIPageControl()
        pageControl.numberOfPages = viewModel.dataImages.count
        pageControl.currentPage = viewModel.currentIndex
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        containerView.addSubview(pageControl)

        
        // SearchBar
        searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        // TableView
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        containerView.addSubview(tableView)

        // BottomSheet Button
        bottomSheetButton = UIButton(type: .system)
        bottomSheetButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        bottomSheetButton.addTarget(self, action: #selector(toggleBottomSheet), for: .touchUpInside)
        containerView.addSubview(bottomSheetButton)

        // BottomSheet View
        bottomSheetView = UIView()
        bottomSheetView.backgroundColor = .white
        bottomSheetView.layer.cornerRadius = 16
        bottomSheetView.isHidden = true

        let label = UILabel()
        label.text = "Statistics"
        bottomSheetView.addSubview(label)
        containerView.addSubview(bottomSheetView)

        setupConstraints(scrollView: scrollView, containerView: containerView)
    }
    
    private func setupConstraints(scrollView: UIScrollView, containerView: UIView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetButton.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // SearchBar at the top
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // ScrollView below SearchBar
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContainerView within ScrollView
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // PageViewController
            pageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pageViewController.view.heightAnchor.constraint(equalToConstant: 300),

            // PageControl
            pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            // TableView
            tableView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 500), // Example height for table content

            // Floating BottomSheet Button
            bottomSheetButton.widthAnchor.constraint(equalToConstant: 50),
            bottomSheetButton.heightAnchor.constraint(equalToConstant: 50),
            bottomSheetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomSheetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            // BottomSheet View
            bottomSheetView.topAnchor.constraint(equalTo: bottomSheetButton.bottomAnchor, constant: 8),
            bottomSheetView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomSheetView.heightAnchor.constraint(equalToConstant: 200),
            bottomSheetView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor) // Important for scrollable content
            
        ])
    }
    
    // Show/hide the bottom sheet
    @objc private func toggleBottomSheet() {
        let secondViewController = BottomSheetContentViewController(viewModel: viewModel)
          
          // Push the second view controller onto the navigation stack
          navigationController?.pushViewController(secondViewController, animated: true)

    }
    
    private func filterItems() {
        viewModel.searchText = searchBar.text ?? ""
        tableView.reloadData()
    }

    // Helper method to get a page view controller for an index
    private func getPageViewController(forIndex index: Int) -> UIViewController? {
        guard index >= 0 && index < viewModel.dataImages.count else {
            return nil
        }
        
        let imageViewController = ImageViewController(index: index)
        return imageViewController
    }
    // Page Control changed
    @objc private func pageControlChanged() {
        let currentIndex = pageControl.currentPage
        if let viewController = getPageViewController(forIndex: currentIndex) {
            pageViewController.setViewControllers([viewController], direction: .forward, animated: true)
        }
    }
}

// MARK: - UIPageViewControllerDelegate & DataSource

extension CarouselViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (viewController as? ImageViewController)?.index else {
            return nil
        }
        let previousIndex = (viewModel.currentIndex == 0) ? viewModel.dataImages.count - 1 : max(0, currentIndex - 1)
        return getPageViewController(forIndex: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (viewController as? ImageViewController)?.index else {
            return nil
        }
        let nextIndex = (viewModel.currentIndex == viewModel.dataImages.count - 1) ? 0 : min(viewModel.dataImages.count - 1, currentIndex + 1)
        return getPageViewController(forIndex: nextIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted: Bool) {
        guard let currentViewController = pageViewController.viewControllers?.first as? ImageViewController else { return }
        viewModel.currentIndex = currentViewController.index
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & DataSource

extension CarouselViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.filteredItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = item.displayName
        cell.imageView?.image = UIImage(named: item.image)
        
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension CarouselViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems()
    }
}

// MARK: - ImageViewController for the Carousel

class ImageViewController: UIViewController {
    
    var index: Int
    private var imageView: UIImageView!
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: UIImage(named: "Nature\(index)"))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

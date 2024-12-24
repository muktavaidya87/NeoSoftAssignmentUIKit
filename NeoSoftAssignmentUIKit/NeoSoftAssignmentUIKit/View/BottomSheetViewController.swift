//
//  Untitled.swift
//  NeoSoftAssignmentUIKit
//
//  Created by Mukta on 22/12/24.
//

import UIKit

class BottomSheetContentViewController: UIViewController {
    
    private var viewModel: CarouselViewModel
    
    init(viewModel: CarouselViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "StatisticsTitle"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        let itemCountLabel = UILabel()
        itemCountLabel.text = "Total Items: \(viewModel.statistics.itemCount)"
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, itemCountLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Add constraints to center the stackView
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor) // Center vertically
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        let charsStackView = UIStackView()
        charsStackView.axis = .vertical
        charsStackView.spacing = 4
        
        for (char, count) in viewModel.statistics.topChars {
            let label = UILabel()
            label.text = "\(char): \(count)"
            charsStackView.addArrangedSubview(label)
        }
        
        charsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(charsStackView)
        
        // Add constraints to position charsStackView below the main stackView
        NSLayoutConstraint.activate([
            charsStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            charsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor) // Center horizontally
        ])
    }
}

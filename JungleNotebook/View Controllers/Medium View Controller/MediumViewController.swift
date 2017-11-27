//
//  MediumViewController.swift
//  JungleNotebook
//
//  Created by Magnolia on 26.11.2017.
//  
//

import UIKit

class MediumViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var messageLabelTop: UILabel!
    @IBOutlet var messageLabelBotttom: UILabel!
    @IBOutlet var activityIndicatorViewTop: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorViewBottom: UIActivityIndicatorView!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // MARK: - Public Interface

    func reloadData() {
        
    }

    // MARK: - View Methods

    private func setupView() {
        // Configure Message Label
        messageLabelTop.isHidden = true
        messageLabelBotttom.isHidden = true

        // Configure Activity Indicator View
        activityIndicatorViewTop.startAnimating()
        activityIndicatorViewTop.hidesWhenStopped = true
        activityIndicatorViewBottom.startAnimating()
        activityIndicatorViewBottom.hidesWhenStopped = true
    }

    private func updateView() {

    }


}

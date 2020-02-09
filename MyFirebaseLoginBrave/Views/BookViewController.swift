//
//  BookViewController.swift
//  MyFirebaseLoginBrave
//
//  Created by YONGKI LEE on 2020/02/08.
//  Copyright © 2020 Brave Lee. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

struct BookInfo {
    let bookImageURLString: String
    let title: String
    let subtitle: String
    let isbn: String
    let price: String
}

class BookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    var bookInfos: [BookInfo] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func callAPIButtonTapped(_ sender: UIButton) {
        
        let requestURL = "https://api.itbook.store/1.0/search/mongodb"
        bookInfos.removeAll()
        Alamofire.request(requestURL).responseData{ response in
            guard let data = response.data else { return }
            guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            
            print(dict)
            guard let booksDicts = dict["books"] as? [[String: Any]] else { return }
            
            for bookDict in booksDicts {
                let imageURLString = bookDict["image"] as? String ?? ""
                let title = bookDict["title"] as? String ?? ""
                let subtitle = bookDict["subtitle"] as? String ?? ""
                let isbn = bookDict["isbn13"] as? String ?? ""
                let price = bookDict["price"] as? String ?? ""
                
                let bookInfo = BookInfo(bookImageURLString: imageURLString, title: title, subtitle: subtitle, isbn: isbn, price: price)
                
                self.bookInfos.append(bookInfo)
            }
            self.tableView.reloadData()
        }
        
    }
    private func setupTableView() {
        
        let nib = UINib(nibName: CustomTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CustomTableViewCell.nibName)
        
        let bookInfo = BookInfo(
            bookImageURLString: "https://itbook.store/img/books/9781484206485.png",
            title: "dummy title",
            subtitle: "dummy subtitle",
            isbn: "dummy isbn",
            price: "dummy price"
        )
        
        bookInfos.append(bookInfo)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookInfos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.nibName, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        
        let bookInfo = bookInfos[indexPath.row]
        cell.uiImageView?.kf.setImage(with: URL(string: bookInfo.bookImageURLString))
        cell.titleLabel.text = bookInfo.title
        cell.subTitleLabel.text = bookInfo.subtitle
        cell.isbnLabel.text = bookInfo.isbn
        cell.priceLabel.text = bookInfo.price
        
        
        return cell
    }
}

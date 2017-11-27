//
//  AnotherViewController.swift
//  JungleNotebook
//
//  Created by Magnolia on 26.11.2017.
//  
//

import UIKit
import RxSwift
import RxCocoa

class AnotherViewController: MediumViewController {
    // MARK: - Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topSearchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var popupViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHistoryTableView: UITableView!
    
    @IBOutlet weak var popupShadow: UIView!
    
    // Блок popup
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupContent: UILabel!
    
    @IBAction func closePopupView(_ sender: Any) {
        
        closePopup()
        
    }
    
    // MARK:- Для bottomView (User's search history block)
    var favoriteWords: Array<Word> = []
    var favoriteFilteredBySearch: Array<Word> = []
    
    // Есть слова в истории поиска
    fileprivate var hasFavoriteWords: Bool {
        return favoriteFilteredBySearch.count > 0
    }
    
    // MARK:- Rx time
    private let disposeBag = DisposeBag()
    
    // MARK:- Подключение ViewModel
    // Сделать обращение к YandexAPISearchViewModel
    
    var viewModel: YandexAPISearchViewModel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView() // Настройка поисковой строки и заголовка
        
        searchBarAndTableUpdateOnSearch() // Настроить обновление данных в таблицах(при поиске)
        
        searchBarUI() // Дизайн поисковой строки
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show Keyboard
        searchBar.becomeFirstResponder()
        
    }
    
    // MARK: - Public Interface
    
    override func reloadData() {
        updateView()
    }
    
    private func updateView() {
        activityIndicatorViewTop.stopAnimating()
        activityIndicatorViewBottom.stopAnimating()
    }
    
    // MARK: - SearchBar setting
    private func searchBarUI() {
        //searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.setTextFieldClearButtonColor(color: .red)
        searchBar.setTextColor(color: .darkText) // Peach color
        searchBar.setTextFieldColor(color: UIColor(red:1.00, green:0.54, blue:0.48, alpha:1.0))
        searchBar.setPlaceholderTextColor(color: .white)
        searchBar.setSearchImageColor(color: .white)
       
        let img = UIImage.init(named: "cancelSearchBar")
        searchBar.setImage(img, for: .clear, state: UIControlState.normal)
        
        let searchField: UITextField = searchBar.value(forKey: "_searchField") as! UITextField
        searchField.font = UIFont.init(name: "Zapfino", size: 28)
        
    }
    
    // MARK:- Скрыть клавиатуру при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    // Скрыть клавиатуру
    private func hideKeyboard() {
        self.view.endEditing(true)
        updateView()
        print("Hidden kbd")
    }
    
    //MARK:- Обновление данных таблиц при поиске
    private func searchBarAndTableUpdateOnSearch() {
        
        // Начальное копирование в массив для дальнейшей сортировки
        favoriteWords = UserDefaults.loadWords()
        favoriteFilteredBySearch = favoriteWords
        self.bottomHistoryTableView.reloadData()
        
        // Обращение к ViewModel за переводом
        self.prepareTranslationOverYandex()
        
        // Drive Table View
        viewModel
            .words
            .drive(onNext: { [unowned self] (_ words) in
                //                print("words.count: ", words.count)
                if words.count > 0 {
                    self.topSearchTableView .isHidden = false
                    
                } else {
                    self.topSearchTableView .isHidden = true
                    
                    // Свернуть таблицу
                    //parent.topContainerHeight.constant = 280
                    
                }
                // Update Table View
                self.topSearchTableView .reloadData()
            })
            .disposed(by: disposeBag)
        
        // Drive Activity Indicator View
        viewModel
            .querying
            .drive(activityIndicatorViewTop.rx.isAnimating)
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .subscribe { [unowned self] (query) in
                let searchField: UITextField = self.searchBar.value(forKey: "_searchField") as! UITextField
                
                if (self.searchBar.text?.isEmpty)! {
                    searchField.font = UIFont.init(name: "Zapfino", size: 28)
                    
                    self.favoriteFilteredBySearch = self.favoriteWords
                    self.bottomHistoryTableView.reloadData()
                    
                } else {
                    searchField.font = UIFont.init(name: "Zapfino", size: 14)
                    
                    // (Поиск в нижней таблице) Фильтрация для "Истории поиска"
                    // В <self.favoriteFilteredBySearch> пойдут данные, удовлетворяющие условию поиска
                    self.favoriteFilteredBySearch = self.getFilteredByWordArray(findWord: self.searchBar.text!, inArrray: self.favoriteWords)
                    
                    // Если в "Истории поиска" нет необходимого перевода => запуск YandexAPI
//                    if self.favoriteFilteredBySearch.count == 0 {
//
//                    }
                    
                    self.bottomHistoryTableView.reloadData()
                    
                }
                
                print("searchText: ", query, "text: ", self.searchBar.text ?? "")
                self.topSearchTableView .reloadData()
            }
            .disposed(by: disposeBag)
        //
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        //
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.searchBar.resignFirstResponder()
                self.searchBar.endEditing(true)
                self.hideKeyboard()
                
                print("resigning")
                
            })
            .disposed(by: disposeBag)
        
        topSearchTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.topSearchTableView.deselectRow(at: indexPath, animated: false)
                
                // Добавление нового слова в "Историю поиска"
                guard let word = self?.viewModel.word(at: indexPath.row) else { return }
                
                // Примитивная проверка (только на defintion) 
                if (self?.findWordInHistory(findWord: word.definition, inArray: (self?.favoriteWords)!))! {
                   
                    // Слово найдено в "истории"
                    
                } else {
                    UserDefaults.addWord(word)
                    self?.favoriteWords = UserDefaults.loadWords()
                    print("counter: ", UserDefaults.loadWords().count)
                    self?.bottomHistoryTableView.reloadData()
                }
                
                // Отправить данные для popUp
                self?.populatePopup(word: word)
                
                self?.showPopup()
                
                
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: - PopUp methods
    func showPopup() {
        // Скрыть результаты поиска в Yandex API
        self.searchBar.resignFirstResponder()
        self.hideKeyboard()
        
        self.popupViewCenterXConstraint.constant = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.popupShadow.alpha = 0.9
        })
    }
    
    func closePopup() {
        self.popupViewCenterXConstraint.constant = -1200
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.popupShadow.alpha = 0
        })
        
    }
    
    // Данные для Popup'а
    func populatePopup(word:Word) {
        self.popupTitle.text = word.definition
        self.popupContent.text = word.full_translation
    }
    
    // MARK:- Методы для нижней таблицы ("История поиска")
    // Найти слово в нижней таблице (по definition)
    func findWordInHistory(findWord:String, inArray:Array<Word>) -> Bool {
        var found: Bool = false
        
        let tmp:Array<Word> = getFilteredByWordArray(findWord: findWord, inArrray: inArray)
        
        found = tmp.count > 0
        
        return found
    }
    
    // Helper
    func getFilteredByWordArray(findWord:String, inArrray:Array<Word>) -> Array<Word> {
        return inArrray
            .filter { $0
                .definition
                .range(
                    of: findWord,
                    options: .caseInsensitive) != nil
        }
    }
    
    // MARK:- Подговка запуска перевода через Yandex-API
    func prepareTranslationOverYandex() {
        // Обращение к ViewModel за переводом
        viewModel = YandexAPISearchViewModel(query: searchBar.rx.text.orEmpty.asDriver())
        
        print("viewModel.words: ", viewModel.words)
    }
    
}

extension AnotherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.topSearchTableView {
            
            print("viewModel.numberOfLocations: ", viewModel.numberOfWords)
            return viewModel.numberOfWords
        
        } else {
            
            return max(favoriteFilteredBySearch.count, 1)
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.topSearchTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WordTableViewCell.reuseIdentifier, for: indexPath) as? WordTableViewCell else { fatalError("Unexpected Table View Cell") }
            
            if let vm = viewModel.viewModelForWord(at: indexPath.row) {
                // Configure Table View Cell
                cell.configure(withViewModel: vm)
            }
            
            return cell
        
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WordInHistoryTableViewCell.reuseIdentifier, for: indexPath) as? WordInHistoryTableViewCell else { fatalError("Unexpected Table View Cell") }
            
            if favoriteFilteredBySearch.count > 0 {
                // Fetch Favorite
                let favoriteWord = favoriteFilteredBySearch[indexPath.row]
                
                print("cell in favoriteWord: ", favoriteWord.definition)
                cell.mainLabel.text = favoriteWord.definition
                cell.detailLabel.text = favoriteWord.short_translation
                
            }
            
            return cell
            
        }
        
        
    }
    
    
}


extension AnotherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == self.bottomHistoryTableView {
            
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderCell") as! HistoryHeaderCell
            return headerCell
            
        } else {
            return nil
        }
        
    }
    
}

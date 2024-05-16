//
//  ChallengesViewController.swift
//  FleetFeet
//
//  Created by NamTrinh on 12/05/2024.
//

import UIKit

struct FactModel {
    let title: String
    let content: String
    var isDone: Bool = false
}

struct User: Codable {
    let name: String
    let score: Int
    var isUser: Bool = false
}

final class ChallengesViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var factsButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var challengesTableView: UITableView!
    @IBOutlet weak var scoresTableView: UITableView!

    private var facts: [FactModel] = [
        .init(title: "Challenge 1", content: "Take 3rd place in the Scores Challenge"),
        .init(title: "Challenge 2", content: "Play at least 10 times"),
        .init(title: "Challenge 3", content: "Come in and play at least once within 3 days"),
        .init(title: "Challenge 4", content: "Take 2nd place in the Scores Challenge"),
        .init(title: "Challenge 5", content: "Use on Options Share us for someone"),
        .init(title: "Challenge 6", content: "Take 1rd place in the Scores Challenge"),
        .init(title: "Fact 1", content: "Sport contributes to strengthening health, improving physical fitness, and reducing the risk of various diseases."),
        .init(title: "Fact 2", content: "The Olympic Games are the largest sporting event in the world, bringing together athletes from different countries."),
        .init(title: "Fact 3", content: "Football is the most popular and mass sport globally, with billions of fans and broadcasts."),
    ]
    
    private var users: [User] = [
        .init(name: "USERIO", score: 1345),
        .init(name: "FAMILIARO", score: 154),
        .init(name: "BUSSINESMAN", score: 76),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        factsButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        scoreButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        
        facts[0].isDone = AppStorage.scores > 76
        facts[1].isDone = AppStorage.playCount > 10
        facts[3].isDone = AppStorage.scores > 154
        facts[4].isDone = AppStorage.isShared
        facts[5].isDone = AppStorage.scores > 1345
        
        if let date = AppStorage.comDate {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date, to: Date())
            if let differenceInDays = components.day,
                differenceInDays >= 3 {
                facts[2].isDone = true
            }
        }
        
        let user = User(name: "YOU", score: AppStorage.scores, isUser: true)
        users.append(user)
        users.sort(by: { user1, user2 in
            user1.score > user2.score
        })
    }
    
    private func setupTableView() {
        challengesTableView.dataSource = self
        challengesTableView.register(cellType: FactTableViewCell.self)
        challengesTableView.rowHeight = 60
        challengesTableView.reloadData()
        
        scoresTableView.dataSource = self
        scoresTableView.register(cellType: ScoreTableViewCell.self)
        scoresTableView.rowHeight = 60
        scoresTableView.reloadData()
        scoresTableView.isHidden = true
    }
    
    private func showFact(model: FactModel) {
        let vc = PopupViewController.instantiate()
        vc.titleStr = model.title.uppercased()
        vc.content = model.content.uppercased()
        vc.screenType = .fact
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    
    @IBAction func handleFactsButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        scoresTableView.isHidden = true
        challengesTableView.isHidden = false
    }
    
    @IBAction func handleScoreButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        scoresTableView.isHidden = false
        challengesTableView.isHidden = true
    }
    
    
    @IBAction func handleBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == challengesTableView {
            return facts.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == challengesTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FactTableViewCell.self)
            cell.configCell(title: facts[indexPath.row].title.uppercased(), isDone: facts[indexPath.row].isDone)
            
            cell.didSelected = { [weak self] in
                guard let self = self else { return }
                showFact(model: self.facts[indexPath.row])
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ScoreTableViewCell.self)
        let user = users[indexPath.row]
        cell.configCell(index: indexPath.row + 1, title: user.name, score: user.score, isUser: user.isUser)
        return cell
        
    }
}

extension ChallengesViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Challenges", bundle: nil)
}

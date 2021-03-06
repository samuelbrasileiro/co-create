import Foundation
import UIKit

public class Achievement{
    private let image: UIImage
    private let title: String
    private let text: String
    private var completed: Bool
    public init(title: String, text: String, imageName: String) {
        self.title = title
        self.text = text
        self.image = UIImage(imageLiteralResourceName: imageName)
        self.completed = false
    }
    public func getText()->String{return self.text}
    public func getTitle()->String{return self.title}
    public func getImage()->UIImage{return self.image}
    
    public func complete(){
        self.completed = true
    }
    public func isCompleted()->Bool{return self.completed}
}

public class AchievementBank{
    var achievements: [Achievement] = []
    public var count: Int{
        get {achievements.count}
        
    }
    public init() {
        achievements.append(Achievement(title: "a", text: "Realize sua primeira atividade de artesanato!", imageName: "mark"))
        achievements.append(Achievement(title: "b", text: "Complete doze horas de atividades de culinária somente em Recife", imageName: "premio"))
        achievements.append(Achievement(title: "c", text: "Passe quinze dias em recife", imageName: "mark"))
        achievements.append(Achievement(title: "g", text: "Dance maracatu!", imageName: "premio"))
        achievements.append(Achievement(title: "h", text: "Complete uma atividade exclusiva LGBT", imageName: "premio"))
        achievements.append(Achievement(title: "j", text: "Complete uma atividade em Olinda", imageName: "premio"))
        achievements.append(Achievement(title: "n", text: "Pule frevo!", imageName: "mark"))
        achievements.append(Achievement(title: "o", text: "Complete uma atividade do São João", imageName: "mark"))
        achievements.append(Achievement(title: "p", text: "Faça uma mesma atividade três vezes", imageName: "premio"))
        achievements.append(Achievement(title: "q", text: "Visite Recife pela segunda vez", imageName: "mark"))
        achievements[0].complete()
        achievements[1].complete()
        achievements[2].complete()
        achievements[3].complete()
    }
    public func getAchievement(_ index: Int) -> Achievement{
        if index < achievements.count {
            return achievements[index]
        }
        else{
            print("Não existe conquista neste índice")
            return Achievement(title: "Nulo", text: "Não tem nada aki", imageName: "icons-menu")
        }
    }

}

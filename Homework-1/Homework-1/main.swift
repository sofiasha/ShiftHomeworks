import Foundation

struct Car: CustomStringConvertible {
    var description: String {
        let number: String
        if let num = carNumber {
            number = "    номер: \(num)"
        }
        else {
            number = ""
        }
let result = """
    Марка: \(manufacturer)
    Модель: \(model)
    Кузов: \(body.rawValue)
    Год: \(yeaOfIssue?.description ?? "-")
""" + "\n" + number
    return result
    }
    enum Body: String, CaseIterable {
        case jeep = "Внедорожник"
        case sedan = "Седан"
        case unknown = "Другой"
    }
    
    let manufacturer: String
    let model: String
    let body: Body
    let yeaOfIssue: Int?
    let carNumber: String?
}

enum Comand: Int, CaseIterable, CustomStringConvertible {
    var description: String {
        switch self {
        case .add:
            return "\(self.rawValue) - Добавить автомобиль"
        case .list:
            return "\(self.rawValue) - Вывести список"
        case .filter:
            return "\(self.rawValue) - Вывести отфильтрованный список"
        case .exit:
            return "\(self.rawValue) - Выйти"
        }
    }
    case add = 1
    case list
    case filter
    case exit = 0
}

var cars: [Car] = [
    Car(manufacturer: "Audi", model: "A4", body: .sedan, yeaOfIssue: 2000, carNumber: "n264so"),
    Car(manufacturer: "Toyota", model: "Rav4", body: .jeep, yeaOfIssue: nil, carNumber: nil)
]

func run() {
    showMenu()
}

func showMenu() {
    while true {
        let comand = readComand()
        
        switch comand {
        case .add:
            addCar()
        case .list:
            printCarsList(cars: cars)
        case .filter:
            printFilteredCarsList()
        case .exit:
            return
        }
    }
}

func readComand() -> Comand {
    while true {
    
        printPrompt()
    
        let comandString = readLine()
        if let comandInt = Int(comandString ?? ""),
           let comand = Comand(rawValue: comandInt){
            return comand
        }
    }
}

func printPrompt() {
    print()
    Comand.allCases.forEach{print($0)}
}

func addCar() {
    let car = getCar()
    cars.append(car)
}
func printCarsList(cars: [Car]) {
    cars.forEach { print($0, "\n") }
}

func printFilteredCarsList() {
    let body = getBody()
    
    let filteredCars = cars.filter {
        car in car.body == body
    }
    printCarsList(cars: filteredCars)
}

func strongReadLine(prompt: String) -> String {
    while true {
        print(prompt)
    
        if let string = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), string.isEmpty == false {
            return string
        }
        print("Введите корректное значение")
    }
}

func weakReadLine(prompt: String) -> String? {
    print(prompt)
    let result = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)
    return result?.isEmpty ?? true ? nil : result
}

func getBody() -> Car.Body {
    let bodyList = buildBodyList()
    
    var bodyString: String
    var index = 0
    repeat {
    bodyString = strongReadLine(prompt: bodyList)
        if Int(bodyString) == nil {
            index = 0
            continue
        }
        
        index = Int(bodyString) ?? 0
    } while index >= Car.Body.allCases.count || index < 0
        return Car.Body.allCases[index]
}

func buildBodyList() -> String {
    var result = "Тип кузова:"
    
    for (index, body) in Car.Body.allCases.enumerated() {
        result += "\n\(index) \(body.rawValue)"
    }
    return result
}

func getCar() -> Car {
    let manufacturer = strongReadLine(prompt: "Введите марку")
    let model = strongReadLine(prompt: "Введите модель")
    let body = getBody()
    
    let year: Int?
    if let yearString = weakReadLine(prompt: "Введите год выпуска") {
        year = Int(yearString)
    } else {
        year = nil
    }
    let number = weakReadLine(prompt: "Введите номер")
    return Car(manufacturer: manufacturer,
               model: model,
               body: body,
               yeaOfIssue: year,
               carNumber: number)
}

run()

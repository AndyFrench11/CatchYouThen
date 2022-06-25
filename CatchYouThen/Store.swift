import Foundation

class Store: ObservableObject {

    @Published var appData: AppData = AppData()
    
    private let endDateString = "2022/07/24"

     func getDaysRemaining() -> Int {
         _ = imageNames()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let endDate = formatter.date(from: endDateString)
        let calendar = Calendar(identifier: .iso8601)
        return calendar.numberOfDaysBetween(Date(), and: endDate!)
     }

     private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("app.data")
     }

     static func load() async throws -> AppData {
         try await withCheckedThrowingContinuation { continuation in
             load { result in
                 switch result {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .success(let data):
                        continuation.resume(returning: data)
                 }
             }
         }
     }

    static func load(completion: @escaping (Result<AppData, Error>) -> Void) {
         DispatchQueue.global(qos: .background).async {
             do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(
                            .success(AppData())
                        )
                    }
                    return
                }
                let appData = try JSONDecoder().decode(AppData.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(appData))
                }
             } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
             }
         }
     }

     static func save(appData: AppData) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
             save(appData: appData) { result in
                 switch result {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .success(let data):
                        continuation.resume(returning: data)
                 }
             }
         }

     }

     static func save(appData: AppData, completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(appData)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(1))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
     }


}

extension Calendar {

    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>

        return numberOfDays.day!
    }

}

struct AppData: Codable {
    var imageRevealed: Bool = false
    var lastOpened: Date = Date()
}

var testData: AppData = .init()

func imageNames() -> [String] {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    var pictures = [String]()

    for item in items {
        if item.hasSuffix("JPG") || item.hasSuffix("HEIC") {
            pictures.append(item)
        }
    }

    return pictures
}

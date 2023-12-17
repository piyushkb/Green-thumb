import Foundation

struct PlantDetails: Codable {
    let name: String
    let des: String
}

struct PlantsData: Codable {
    let plants: [PlantDetails]
}
 

enum PlantError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case plantNotFound
}

func fetchPlantsDetails(plant: String, completion: @escaping (Result<PlantDetails, PlantError>) -> Void) {
    let urlString = "https://6bb89dbc36ec4c0287b964a865ac84ba.api.mockbin.io/"
    
    guard let url = URL(string: urlString) else {
        completion(.failure(.invalidURL))
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(.networkError(error)))
            return
        }
        
        guard let data = data else {
            completion(.failure(.invalidResponse))
            return
        }
        
        do {
            let plantsData = try JSONDecoder().decode(PlantsData.self, from: data)
            
            if let plantDetails = plantsData.plants.first(where: { $0.name.lowercased() == plant.lowercased() }) {
                completion(.success(plantDetails))
            } else {
                completion(.failure(.plantNotFound))
            }
        } catch let decodingError {
            completion(.failure(.decodingError(decodingError)))
        }
    }.resume()
}

 

//
//  OrderManager.swift
//  TablesBooking
//
//  Created by temir on 18.12.2020.
//

import Foundation

enum PlaceOrderStatus {
    case booked
    case succeed
    case error
}

class OrderManager {
    
    static let shared = OrderManager()
    
    private init() {
        fetchPlaces()
    }
    ///Put your own URL here
    private let getPlacesURL = URL(string: "https://------/api/places")
    private let checkIfBookedURL = URL(string: "https://------/api/orders/check")
    private let createOrderURL = URL(string: "https://-------/api/orders/create")
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }
    
    var selectedDate: Date?
    
    var places: [Place]?
    
    var orderID: UUID?
    
    private func fetchPlaces() {
        if let url = getPlacesURL {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else if let data = data {
                    do {
                        let fetchedPlaces = try JSONDecoder().decode([Place].self, from: data)
                        if !fetchedPlaces.isEmpty {
                            self.places = fetchedPlaces
                            print(self.places!)
                        }
                    } catch {
                        print(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
    private func makeRequestObject(with placeName: String) -> OrderRequest? {
        if let place = places?.filter({ $0.name == placeName }).first,
           let date = selectedDate {
            let object = OrderRequest(personsCount: 1,
                                      bookingDate: dateFormatter.string(from: date),
                                      place: place)
            return object
        } else {
            return nil
        }
    }
    
    private func makeRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private func checkBooking(for placeName: String, completion: @escaping((PlaceOrderStatus) -> Void)) {
        guard let json = makeRequestObject(with: placeName) else {
            completion(.error)
            return
        }
        do {
            let data = try JSONEncoder().encode(json)
            if let url = checkIfBookedURL {
                var request = makeRequest(with: url)
                request.httpBody = data
                URLSession.shared.dataTask(with: request) { (data, _, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.error)
                        return
                    } else if let data = data {
                        do {
                            let responce = try JSONDecoder().decode(Int.self, from: data)
                            completion(responce == 0 ? .succeed : .booked)
                        } catch {
                            completion(.error)
                            print(error.localizedDescription)
                            return
                        }
                    }
                }.resume()
            }
        } catch {
            completion(.error)
            print(error.localizedDescription)
        }
    }
    
    func makeOrder(for placeName: String, completion: @escaping((PlaceOrderStatus) -> Void)) {
        checkBooking(for: placeName) { status in
            switch status {
            case .booked:
                completion(.booked)
            case .succeed:
                if let url = self.createOrderURL {
                    do {
                        let data = try JSONEncoder().encode(self.makeRequestObject(with: placeName))
                        var request = self.makeRequest(with: url)
                        request.httpBody = data
                        URLSession.shared.dataTask(with: request) { (data, _, error) in
                            if let data = data {
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data,
                                                                                options: .mutableContainers) as? [String: Any]
                                    if let orderID = json?["id"] as? String {
                                        self.orderID = UUID(uuidString: orderID)
                                        completion(.succeed)
                                    }
                                } catch {
                                    completion(.error)
                                }
                            }
                        }.resume()
                    } catch {
                        completion(.error)
                    }
                }
            case .error:
                completion(.error)
            }
        }
    }
}

struct OrderRequest: Encodable {
    var personsCount: Int
    var bookingDate: String
    var place: Place
}

//
//  RepresentativeController.swift
//  Representative
//
//  Created by Kevin Tanner on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class RepresentativeController {
    
    static let baseURL = URL(string: "http://whoismyrepresentative.com/getall_reps_bystate.php?")
    
    static func searchRepresentatives(forState state: String, completion: @escaping ([Representative]) -> Void) {
        
        guard let url = baseURL else { completion([]); return }
        
        // https://whoismyrepresentative.com/getall_reps_bystate.php?state=CA&output=json
        let stateQuery = URLQueryItem(name: "state", value: state.lowercased())
        let outputQuery = URLQueryItem(name: "output", value: "json")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [stateQuery, outputQuery]
        
        
        guard let urlRequest = urlComponents?.url else { completion([]); return }
        
        print(urlRequest)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error {
                print("There was an error in the dataTask: \(error) \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data found")
                completion([])
                return
            }
            
            guard let dataAsAscii = String(data: data, encoding: .ascii),
                let dataAsUTF = dataAsAscii.data(using: .utf8) else {
                    completion([])
                    return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let resultsDictionary = try jsonDecoder.decode([String : [Representative]].self, from: dataAsUTF)

                guard let results = resultsDictionary["results"] else { completion([]); return }
                
                completion(results)
                
            } catch {
                print("Error decoding json \(error) \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}

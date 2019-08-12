//
//  PostController.swift
//  Post
//
//  Created by Kevin Tanner on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
    
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    let posts: [Post] = []
    
    func fetchPosts(completion: @escaping () -> Void) {
        
        guard let baseURL = baseURL else { return }
        
        let getterEndpoint = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error with network request \(error) \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data else { completion(); return}
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let postsDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                var posts = postsDictionary.compactMap({ $0.value })
                posts.sort(by: {$0.timestamp > $1.timestamp})
                posts = self.posts
                completion()
            } catch {
                print("Error decoding data: \(error) \(error.localizedDescription)")
                completion()
                return
            }
            
            
            
            
        }
        dataTask.resume()
        
    }
    
} // End of class

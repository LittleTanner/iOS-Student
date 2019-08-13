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
    
    var posts: [Post] = []
    
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
                self.posts = posts
                completion()
            } catch {
                print("Error decoding data: \(error) \(error.localizedDescription)")
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping () -> Void ) {
        
        let newPost = Post(username: username, text: text)
        
        var postData: Data?
        
        // There might be an error here, not 100% sure
        do {
            let jsonEncoder = JSONEncoder()
            postData = try jsonEncoder.encode(newPost)
            completion()
        } catch {
            print("Error encoding data: \(error) \(error.localizedDescription)")
            completion()
        }
        
        guard let baseURL = baseURL else { return }
        
        var postEndpoint = baseURL
        postEndpoint.appendPathExtension("json")
        
        var urlRequest = URLRequest(url: postEndpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("Error sending dataTask \(error) \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data else { return }
            
            if let dataResponseString = String(data: data, encoding: .utf8) {
                print(dataResponseString)
            }
            
            self.posts.append(newPost)
            self.fetchPosts(completion: {
                completion()
            })
            
        }
        
        dataTask.resume()
    }
    
} // End of class

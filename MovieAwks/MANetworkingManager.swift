//
//  MANetworkingManager.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import Alamofire
    
let API_KEY = "05fb742d973ead23b8c11c9d46e53260"

//SEARCH: https://api.themoviedb.org/3/search/movie?api_key=05fb742d973ead23b8c11c9d46e53260&query=ant man&page=1
//IMAGE: http://image.tmdb.org/t/p/w300/t2AvtK0jS8MwAsVzgwbG6fvaaH0.jpg



func searchForMovieWithName(name:String, page:Int = 1, completion:(response:AnyObject) ->Void) {
    Alamofire.request(.GET, "https://api.themoviedb.org/3/search/movie", parameters: ["api_key" : API_KEY, "query" : name, "page": page]).responseJSON {
        response in
//        print(response.request)  // original URL request
//        print(response.response) // URL response
//        print(response.result.value)
//        print(response.result)   // result of response serialization
        
        if (response.result.isSuccess){
            if let JSON = response.result.value {
                if let dict = JSON as? Dictionary<String, AnyObject> {
                    completion(response: parseMovieResult(dict))
                }
            }
        }
        else{
            completion(response: response.result.error!)
        }

    }
}

func parseMovieResult(JSON:Dictionary<String, AnyObject>) -> Array<MAMovie> {
    var movies = Array<MAMovie>()
    
    if let results = JSON["results"] as? Array<Dictionary<String, AnyObject>> {
        for dict in results {
            movies.append(MAMovie.init(dict: dict))
        }
    }
    
    return movies
}

func genres(completion:(response:AnyObject) ->Void)  {
    
    var returnDict = Dictionary<NSNumber, String>()
    
    Alamofire.request(.GET, "http://api.themoviedb.org/3/genre/movie/list", parameters: ["api_key" : API_KEY]).responseJSON {
        response in
        if (response.result.isSuccess){
            if let JSON = response.result.value {
                if let dict = JSON as? Dictionary<String, AnyObject> {
                    if let genresDict = dict["genres"] as? Array<Dictionary<String,AnyObject>> {
                        for genre in genresDict {
                            let id = genre["id"] as! NSNumber
                            returnDict[id] = genre["name"] as? String
                        }
                        completion(response: returnDict)
                    }
                }
            }
        }
        let error = NSError.init(domain: "MA", code: 1, userInfo: ["description": "genre error"])
        completion(response: error)
    }
    
}
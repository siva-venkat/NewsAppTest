//
//  NewsAppTestTests.swift
//  NewsAppTestTests
//
//  Created by Sivaranjani Venkatesh on 22/1/22.
//

import XCTest
@testable import NewsAppTest

class NewsAppTestTests: XCTestCase {
    func testMyTableView(){
        let vc = ViewController()
        _ = vc.view
        XCTAssertNotNil(vc.title)
        
    }


    func  handleAPI() throws {
        
        let json = """
 "articles":[
      {
         "source":{
            "id":"news-com-au",
            "name":"News.com.au"
         },
         "author":"Nic Savage and Andrew McMurtry",
         "title":"‘Off the charts’: Barty cannot be stopped - NEWS.com.au",
         "description":"<p>Rafael Nadal and Alexander Zverev were both in action at the Australian Open today, but the best is yet to come, with Ash Barty stepping on court for her fourth round clash later tonight.</p>",
         "url":"https://www.news.com.au/sport/tennis/australian-open/australian-open-live-scores-results-schedule-ash-barty-and-nick-kyrgios-news/news-story/268419ef7e59dc5cf49f15d329ef22c2",
         "urlToImage":"https://content.api.news/v3/images/bin/eb63308a2306b670a42b3c517e623a7c",
         "publishedAt":"2022-01-23T09:55:08Z",
         "content":"Ash Barty has been in remarkable form on the court but even the World No. 1 cant do or remember everything perfectly all the time.Rafael Nadal and Alexander Zverev were both in action at the Australi… [+12592 chars]"
      },
      {
         "source":{
            "id":null,
            "name":"WAtoday"
         },
        
    }


"""
        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(User.self, from: data)
        
        XCTAssertEqual("‘Off the charts’: Barty cannot be stopped - NEWS.com.au", result.articles[0].title)
        XCTAssertEqual("WAtoday", result.articles[0].source.name)
        
    }
    
}

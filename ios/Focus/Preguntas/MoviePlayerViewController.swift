//
//  MoviePlayerViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 09/09/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit
import MediaPlayer

class MoviePlayerViewController: UIViewController {
    
    var moviePlayer: MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerHeight = self.view.frame.size.height / 3
        
        let url: NSURL = NSURL(string: "http://ec2-52-26-0-111.us-west-2.compute.amazonaws.com/focus/resources/videos/test.m4v")!
//        let url: NSURL = NSURL(string: "http://192.168.1.16:8888/focus/resources/videos/test.m4v")!
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        moviePlayer.view.frame = CGRect(x: 0, y: self.view.frame.size.height / 2 - playerHeight / 2, width: self.view.frame.size.width, height: playerHeight)
        
        self.view.addSubview(moviePlayer.view)
        moviePlayer.fullscreen = true
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.moviePlayer.stop()
    }
    
}

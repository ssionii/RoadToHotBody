//
//  PhotoViewModel.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoDetailViewModel {
	struct Input {
		
	}
	
	struct Output {
		var urlStrings: Observable<[String]>
		var index: Observable<Int>
	}
	
	private let loadImageUseCase = LoadImageUseCase()
	
	private let urlStrings: [String]
	private let index: Int
	
	init(urls: [String], index: Int) {
		self.urlStrings = urls
		self.index = index
	}
	
	func transform(input: Input) -> Output {
		return Output( urlStrings: Observable.just(urlStrings), index: Observable.just(index))
	}
}

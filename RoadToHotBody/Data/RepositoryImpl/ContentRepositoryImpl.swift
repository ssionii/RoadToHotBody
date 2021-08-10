//
//  ContentRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift

class ContentRepository: ContentRepositoryProtocol {
	
	func fetchDetailContents(request: FetchDetailContentsUseCaseModels.Request) -> Observable<FetchDetailContentsUseCaseModels.Response> {
		
		// dummy data
		let detailContents = [
			Content(type: .Memo, text: "승모근 운동방법 1 \n승모근은 이렇게 한다. 으쓱으쓱호오오오잇 하아아아잇 \n줄바꿈 했다", url: nil),
			Content(type: .Video, text: nil, url: ""),
			Content(type: .Photo, text: nil, url: "https://img1.yna.co.kr/photo/cms/2020/04/29/15/PCM20200429000015005_P2.jpg"),
			Content(type: .Memo, text: "승모근 운동방법 2 메롱메롱 메에롱", url: nil)
		]
		
		let response = FetchDetailContentsUseCaseModels.Response(contents: detailContents)
		
		return Observable.of(response)
	}
	

}

//
//  ContentRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift

class TrainingDetailRepository: TrainingDetailRepositoryProtocol {
	
	// dummy data
	let detailContents = [
		Content(index: 0, type: .Memo, text: "승모근 운동방법 1 \n승모근은 이렇게 한다. 으쓱으쓱호오오오잇 하아아아잇 \n줄바꿈 했다"),
		Content(index: 1, type: .Memo, text: "야야 ~"),
		Content(index: 2, type: .Photo, text: "http://img.segye.com/content/image/2021/06/18/20210618504877.jpg"),
		Content(index: 3, type: .Photo, text: "https://img1.yna.co.kr/photo/cms/2020/04/29/15/PCM20200429000015005_P2.jpg"),
		Content(index: 4, type: .Memo, text: "승모근 운동방법 2 메롱메롱 메에롱"),
		Content(index: 5, type: .Memo, text: "승모근 운동방법 3 오랜만에 마라탕 먹어서 그런지 배아프네;"),
		Content(index: 6, type: .Memo, text: "승모근 운동방법 4")
	]
	
	private let trainingDetailDataSource: TrainingDetailDataSourceProtocol
	
	init(dataSource: TrainingDetailDataSourceProtocol) {
		self.trainingDetailDataSource = dataSource
	}
	
	func fetchDetailContents(request: FetchDetailContentsUseCaseModels.Request) -> Observable<FetchDetailContentsUseCaseModels.Response> {
		
		return trainingDetailDataSource.fetchDetailContents()
			.asObservable().map { contents -> FetchDetailContentsUseCaseModels.Response in
				return FetchDetailContentsUseCaseModels.Response(contents: contents)
			}
	}
	
	func fetchDetailContent(request: FetchDetailContentUseCaseModels.Request) -> Observable<FetchDetailContentUseCaseModels.Response> {
		
		let response = FetchDetailContentUseCaseModels.Response(content: detailContents[request.index])
		return Observable.of(response)
	}
	
	func saveDetailContent(request: SaveDetailContentUseCaseModels.Request) -> Observable<SaveDetailContentUseCaseModels.Response> {
		
		// TODO: 저장
		print(request.text)
		
		if let index = request.index {
			// 업데이트
			
			let response = SaveDetailContentUseCaseModels.Response(isSuccess: true)
			return Observable.of(response)
		} else {
			// 새로 저장
			
			let response = SaveDetailContentUseCaseModels.Response(isSuccess: true)
			return Observable.of(response)
		}
		
		
	}
	
	

}

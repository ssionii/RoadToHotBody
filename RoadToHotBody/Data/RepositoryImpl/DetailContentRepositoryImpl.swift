//
//  ContentRepository.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import RxSwift

class DetailContentRepository: DetailContentRepositoryProtocol {
    
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
	
	private let trainingDetailDataSource: DetailContentDataSourceProtocol
	
	init(dataSource: DetailContentDataSourceProtocol) {
		self.trainingDetailDataSource = dataSource
	}
	
	func fetchDetailContents(request: FetchDetailContentsUseCaseModels.Request) -> Observable<FetchDetailContentsUseCaseModels.Response> {
		
		return trainingDetailDataSource.fetchDetailContents(muscleIndex: request.trainingIndex)
			.asObservable().map { contents -> FetchDetailContentsUseCaseModels.Response in
				return FetchDetailContentsUseCaseModels.Response(contents: contents)
			}
	}
	
	func fetchDetailContent(request: FetchDetailContentUseCaseModels.Request) -> Observable<FetchDetailContentUseCaseModels.Response> {
		
		let response = FetchDetailContentUseCaseModels.Response(content: detailContents[request.index])
		return Observable.of(response)
	}
	
	func saveDetailContent(request: SaveDetailContentUseCaseModels.Request) -> Observable<SaveDetailContentUseCaseModels.Response> {
        return trainingDetailDataSource.saveDetailContent(muscleIndex: request.muscleIndex, text: request.text, type: request.type)
            .andThen(Observable.of(SaveDetailContentUseCaseModels.Response(isSuccess: true)))
	}
    
    func updateDetailContent(request: UpdateDetailContentUseCaseModels.Request) -> Observable<UpdateDetailContentUseCaseModels.Response> {
        return trainingDetailDataSource.updateDetailContent(index: request.index, text: request.text)
            .andThen(Observable.of(UpdateDetailContentUseCaseModels.Response(isSuccess: true)))
    }
	
	func deleteDetailContent(request: DeleteDetailContentUseCaseModels.Request) -> Observable<DeleteDetailContentUseCaseModels.Response> {
		return trainingDetailDataSource.deleteDetailContent(index: request.index)
			.andThen(Observable.of(DeleteDetailContentUseCaseModels.Response(isSuccess: true)))
	}
	

}

//
//  ViewController.swift
//  CardGameApp
//
//  Created by Yoda Codd on 2018. 12. 24..
//  Copyright © 2018년 Drake. All rights reserved.
//

import UIKit
import os



class ViewController: UIViewController {
    /// 덱 카드들이 뷰로 생성되면 모이는 배열
    private var deckCardViews : [CardView] = []
    /// 오픈덱 카드들이 뷰로 생성되면 모이는 배열
    private var openedCardViews : [CardView] = []
    
    
    /// 플레이카드가 들어가는 스택뷰
    @IBOutlet weak var playCardMainStackView: UIStackView!
    
    /// 최대 카드 개수 장수로 카드사이즈 세팅
    private var cardSize = CardSize(maxCardCount: 7)
    
    /// 카드 전체 위치 배열
    private var widthPositions : [CGFloat] = []
    /// 플레이카드 Y 좌표
    private var heightPositions : [CGFloat] = []
    
    /// 게임보드 생성
    private var gameBoard = GameBoard(slotCount: 7)
    
    /// 앱 배경화면 설정
    private func setBackGroundImage() {
        // 배경이미지 바둑판식으로 출력
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg_pattern"))
    }
    
    /// 전체 위치를 설정
    private func calculateWidthPosition(cardSize: CardSize){
        // 0 ~ maxCardCount -1 추가
        for x in 0..<cardSize.maxCardCount {
            widthPositions.append(cardSize.originWidth * CGFloat(x) + cardSize.widthPadding)
        }
    }
    private func calculateHeightPosition(cardSize: CardSize){
        // 첫 지점은 20
        heightPositions.append(20 + cardSize.heightPadding)
        // 트럼프 카드의 종류는 13종
        for x in 0..<Numbering.allCases().count {
            // 시작지점 높이 100
            heightPositions.append(cardSize.originHeight * 0.25 * CGFloat(x) + 100 + cardSize.heightPadding)
        }
    }
    
    
    /// 최대 카드 수량 체크
    private func checkMaxCardCount(startNumber: Int, cardCount: Int) -> Bool {
        return startNumber > cardSize.maxCardCount || cardCount > cardSize.maxCardCount
    }
    
    
    /// 첫줄 카드배경 출력
    private func setPointDeckPosition(){
        // 원하는 빈칸은 4칸
        for x in 0..<Mark.allCases().count {
            // 카드 기준점 설정
            let viewPoint = CGPoint(x: widthPositions[x], y: heightPositions[0])
            // 기준점에서 카드사이즈로 이미지뷰 생성
            let emptyCardView = EmptyPointCardView(origin: viewPoint, size: cardSize.cardSize)
            // 뷰를 메인뷰에 추가
            self.view.addSubview(emptyCardView)
        }
    }
    
    
    /// 카드 이미지 출력
    private func makeCardView(widthPosition: Int, heightPosition: Int, cardSize: CardSize, cardInfo: CardInfo) -> CardView {
        // 배경 뷰 생성
        let cardView = CardView(cardInfo: cardInfo, frame: CGRect(origin: CGPoint(x: widthPositions[widthPosition - 1], y: heightPositions[heightPosition - 1]), size: cardSize.cardSize))
        // 서브뷰 추가
        return cardView
    }
    
    /// 뷰를 받아서 메인 뷰에 추가
    func addViewToMain(view: UIView){
        self.view.addSubview(view)
        return ()
    }
    
    /// 덱인포를 받아서 카드인포배열을 리턴
    func getDeckInfo(deckInfo: DeckInfo) -> [CardInfo] {
        return deckInfo.allInfo()
    }
    
    
    /// 덱을 카드뷰로 출력
    func drawDeckView(){
        // 덱,오픈덱 카드뷰 배열을 초기화 한다. 게임 리셋 기능시 쓰인다.
        deckCardViews = []
        openedCardViews = []
        
        // 덱을 카드객체가 아닌 프로토콜로 받는다
        let cardInfos = getDeckInfo(deckInfo: self.gameBoard)
        
        // 각 카드정보를 모두 카드뷰로 전환
        for cardInfo in cardInfos {
            // 카드뷰 생성
            let cardView = makeCardView(widthPosition: 7, heightPosition: 1, cardSize: cardSize, cardInfo: cardInfo)
            // 덱을 위한 탭 제스쳐를 생성, 추가한다
            cardView.addGestureRecognizer(makeTapGetstureForDeck())
            // 메인뷰에 추가
            addViewToMain(view: cardView)
            
            // 덱카드뷰 배열에 넣는다
            deckCardViews.append(cardView)
        }
    }
    
    /// 라인번호와 카드배열을 받아서 해당 라인에 카드를 출력한다
    func drawCardLine(lineNumber: Int){
        // 게임보드에서 플레이카드를 카드인포 배열로 받는다
        let cardInfos = gameBoard.getPlayDeckLineCardInfos(line: lineNumber)
        // 모든 카드인포가 목표
        for x in 0..<cardInfos.count {
            let cardView = makeCardView(widthPosition: lineNumber, heightPosition: x + 2, cardSize: cardSize, cardInfo: cardInfos[x])
            // 유저와 상호작용 on
            cardView.isUserInteractionEnabled = true
            addViewToMain(view: cardView)
        }
    }
    
    /// 맥스카드카운트로 모든 플레이카드 를 출력한다
    func drawAllPlayCard() {
        for x in 0..<cardSize.maxCardCount {
            drawCardLine(lineNumber: x)
        }
    }
    
    
    /// 덱 탭 제스처시 발생하는 이벤트
    @objc func deckTapEvent(_ sender: UITapGestureRecognizer) {
        
        // 옮겨진 뷰가 카드뷰가 맞는지 체크
        guard let openedCardView = sender.view as? CardView else { return () }
        
        // 오픈된 카드뷰 위치 이동.  5번과 6번 사이. 둘을 더해서 /2 하면 가운데값이 나옴
        openedCardView.frame.origin.x = (widthPositions[4] + widthPositions[5]) / 2
        
        // 카드뷰를 뒤집는다
        openedCardView.flip()
        
        // 옮겨진 카드가 안보이니 맨 위로 올린다
        self.view.bringSubview(toFront: openedCardView)
        
        // 상호작용 금지
        openedCardView.isUserInteractionEnabled = false
        
        // 해당 뷰를 덱>오픈덱 뷰 배열로 옮긴다
        guard let popedDeckCardView = deckCardViews.popLast() else {
            os_log("덱카드뷰 에서 뷰 추출 실패")
            return ()
        }
        openedCardViews.append(popedDeckCardView)
        
    }
    
    /// 덱을 오픈한다
    func openDeck() -> CardInfo? {
        // 덱의 카드를 오픈덱으로 이동
        guard let openedCardInfo = gameBoard.deckToOpened() else { return nil }
        // 카드인포 리턴
        return openedCardInfo
    }
    
    /// 덱을 위한 탭 제스처
    func makeTapGetstureForDeck() -> UITapGestureRecognizer {
        // 탭 제스처 선언
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.deckTapEvent(_:)))
        // 작동에 필요한 탭 횟수
        gesture.numberOfTapsRequired = 1
        // 작동에 필요한 터치 횟수
        gesture.numberOfTouchesRequired = 1
        // 제스처를 리턴한다
        return gesture
    }
    
    /// 덱 가장 밑부분의 리프레시 아이콘뷰
    func makeRefreshIconView(){
        // 뷰 기준점 설정.
        let viewPoint = CGPoint(x: widthPositions[6], y: heightPositions[0])
        // 기준점에서 카드사이즈로 이미지뷰 생성
        let refreshIconView = RefreshIconView(origin: viewPoint, size: cardSize.cardSize)
        // 제스처를 적용
        let refreshGesture = makeRefreshGesture()
        refreshIconView.addGestureRecognizer(refreshGesture)
        // 뷰를 메인뷰에 추가
        addViewToMain(view: refreshIconView)
    }
    
    /// 리프레시 아이콘 함수. 오픈덱 카드뷰를 역순으로 뒤집어서 덱뷰에 삽입
    @objc func refreshDeck(_ sender: UITapGestureRecognizer){
        // 오픈카드뷰 전체가 대상
        for _ in 0..<openedCardViews.count {
            // 배열 마지막을 뽑느다
            guard let lastCardView = openedCardViews.popLast() else { return () }
            
            // 덱에 넣기 위해 뒤집는다
            lastCardView.flip()
            // 유저 인터랙션 허용
            lastCardView.isUserInteractionEnabled = true
            
            // 덱카드뷰 배열에 넣는다
            deckCardViews.append(lastCardView)
            
            // 위치 이동. 가로칸 7번째 위치로.
            lastCardView.frame.origin.x = widthPositions[6]
            // 뷰를 앞으로 이동시킨다
            self.view.bringSubview(toFront: lastCardView)
        }
        
        // 게임보드도 이동해 준다
        gameBoard.refreshDeck()
    }
    
    /// 리프레시 아이콘 용 제스처 생성
    func makeRefreshGesture() -> UITapGestureRecognizer {
        // 탭 제스처 선언
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.refreshDeck(_:)))
        // 작동에 필요한 탭 횟수
        gesture.numberOfTapsRequired = 1
        // 작동에 필요한 터치 횟수
        gesture.numberOfTouchesRequired = 1
        // 제스처를 리턴한다
        return gesture
    }
    
    /// 카드게임 시작시 카드뷰 전체 배치 함수
    func gameStart(){
        // 카드 빈자리 4장 출력
        setPointDeckPosition()
        
        // 리프레시 아이콘 뷰 생성
        makeRefreshIconView()
        
        // 오픈덱뷰 생성
        makeOpenedDeckView()
        
        // 덱 출력
        drawDeckView()
        
        // 플레이카드 출력
//        drawAllPlayCard()
    }
    
    /// shake 함수.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        // 뷰를 모두 지운다
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        // 게임보드 카드들 초기화
        gameBoard.reset()
        // 카드배치를 뷰로 생성
        gameStart()
    }
    
    /// 오픈덱뷰 생성
    func makeOpenedDeckView(){
        // 뷰 기준점 설정. 5,6번째 카드 중간값 위치
        let xPosition = (widthPositions[4] + widthPositions[5]) / 2
        let viewPoint = CGPoint(x: xPosition, y: heightPositions[0])
        // 기준점에서 카드사이즈로 이미지뷰 생성
        let opendedDeckView = UIView(frame: CGRect(origin: viewPoint, size: cardSize.cardSize))
        // 뷰를 메인뷰에 추가
        addViewToMain(view: opendedDeckView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카드 사이즈 계산
        cardSize.calculateCardSize(screenWidth: UIScreen.main.bounds.width)
        
        // 화면 가로사이즈를 받아서 카드출력 기준점 계산
        calculateWidthPosition(cardSize: cardSize)
        // 세로 위치 설정
        calculateHeightPosition(cardSize: cardSize)
        
        // 앱 배경 설정
        setBackGroundImage()
        
        // 카드배치 시작
        gameStart()
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

// Configure StatusBar
extension ViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


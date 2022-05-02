//
//  CustomViewController.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/06.
//

import Foundation

import UIKit

class CustomViewController: UIViewController{
    
    @IBOutlet var profileView: UIView!
    @IBOutlet weak var profileNumberLabel: UILabel!
    @IBOutlet weak var profileImageCollectionView: UICollectionView!
    
    var imageResources = [URL]() //이미지데이터
    var indexNum : Int = 1 //이미지 인덱스넘버 //1부터 시작
    var indexEndNum : Int! //이미지 끝넘버

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("didLoad")

        print("\(indexNum)번째 사진")
        print("사진 개수 >> \(indexEndNum!)")
        
        
        profileImageCollectionView.delegate = self
        profileImageCollectionView.dataSource = self
        

        //컬렉션 뷰 레이아웃
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        profileImageCollectionView.collectionViewLayout = layout
        
        
        //스와이프액션 시 > 뷰 dismiss
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.screenSwipeDown))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down //방향지정
        profileView.addGestureRecognizer(swipeDown)
        
    
        
    }
    
    override func viewDidLayoutSubviews() {

            DispatchQueue.main.async {
                self.profileImageCollectionView.isPagingEnabled = true
                self.profileImageCollectionView.scrollToItem(at:IndexPath(item: self.indexNum-1, section: 0), at: .centeredHorizontally, animated: false)
                
                self.profileImageCollectionView.isPagingEnabled = true
            }
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        print("willappear")

        profileNumberLabel.text = "\(indexNum)/\(indexEndNum!)"//사진 순서 라벨 적용
        
        
    }
    

    
    
    //뷰 dismiss
    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    //아래 스와이프 액션 dismiss
    @objc func screenSwipeDown(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    //선택한 사진 순서로 이동
    func moveToIndexNum(){
        let screenWidth = UIScreen.main.bounds.size.width //디바이스 너비
        let position = CGPoint(x: Int(screenWidth)*(indexNum-1), y: 0)
        
        print("디바이스너비 >> \(screenWidth)")
        print("포지션 >> \(position)")
        print("컨텐츠사이즈 >> \(profileImageCollectionView.contentSize)")
        
        profileImageCollectionView.setContentOffset(position, animated: true)
    }
    
}

//MARK: -컬렉션뷰

extension CustomViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageResources.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = profileImageCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileDetailImageCell", for: indexPath) as? ProfileDetailImageCell{
        
            //cell.profileImage.image = UIImage(data: imageResources[indexPath.row])
            cell.profileImage.kf.setImage(with: imageResources[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width//self.profileImageCollectionView.frame.width
        let height = width//self.profileImageCollectionView.frame.height

        //print("컬렉션뷰. \(width)")
        return CGSize(width: width, height: height)
        
        }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.profileImageCollectionView.frame.width)// x좌표/너비
        self.indexNum = page + 1
        print(page)
        viewWillAppear(true)
      }
}

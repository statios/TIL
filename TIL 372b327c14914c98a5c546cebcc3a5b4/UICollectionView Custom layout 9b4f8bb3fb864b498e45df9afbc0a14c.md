# UICollectionView Custom layout

[UICollectionView Custom Layout Tutorial: Pinterest](https://iyarweb.wordpress.com/2017/09/18/uicollectionview-custom-layout-tutorial-pinterest/)

## Core Layout Process

`UICollectionView`가 레이아웃을 작성하는 프로세스를 알아보자. 

`UICollectionView`가 레이아웃에 대한 정보가 필요할 때, `UICollectionView`는 `UICollectionViewLayout`에 그러한 정보를 요청하게 된다. 그러면 `UICollectionViewLayout`은 특정 메서드를 호출하여 레이아웃 정보를 `UICollectionView`에 제공하게 된다.

![UICollectionView%20Custom%20layout%209b4f8bb3fb864b498e45df9afbc0a14c/image.png](UICollectionView%20Custom%20layout%209b4f8bb3fb864b498e45df9afbc0a14c/image.png)

`UICollectionViewLayout`에서 호출되는 메서드

- `collectionViewContentSize` : 컬렉션뷰 전체의 size를 리턴한다. 이 사이즈는 컬렉션뷰는 내부적으로 자신의 스크롤뷰 contents 사이즈를 지정하기 위해 사용한다. layout 객체를 커스텀하기 위해서 반드시 override 해야하는 메서드다.
- `prepare()` : 레이아웃 작업이 수행되려고 할 때마다 호출된다. 여기서 셀의 사이즈나 위치에 대한 계산을 하면된다.
- `layoutAttributesForElements(in:)` : 셀에 대한 레이아웃 속성들을 어레이 타입으로 리턴해야한다.
- `layoutAttributesForItem(at:)` : 컬렉션뷰가 요청하는 특정 IndexPath에 대한 셀 레이아웃 속성을 리턴한다.
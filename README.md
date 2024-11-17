# notice_board1111

JSP를 활용한 게시판

## 개요

게시판을 만듦으로써 대용량 데이터일때 처리해야하는 페이징 처리, 민감한 정보를 저장할 때 암호화 처리, 이메일 인증 API, BACK End, Front End 공부를 하기 위해서 본 프로젝트를 수행하였다.

## 페이징 처리 - 게시판

페이징 처리란 데이터 베이스에 저장된 데이터가 소량일 경우는 상관이 없지만, 대량일 경우 한꺼번에 불러와서 처리하는 것은 비효율적이다. 그 이유는 사용자가 직접 보는 화면에는 소량의 데이터만 필요하기 때문이다.

![carbon](<https://user-images.githubusercontent.com/74814641/160281871-b7ebbc90-6668-428e-8577-57f77bac259a.png>)

위 코드는 DB에서 게시판 데이터를 불러와 ArrayList에 저장한 뒤 리턴하는 코드의 일부이다. 1페이지일 때 실행되는 코드로 쿼리문은 bbs(게시판)테이블에서 데이터를 불러오되 bbsID가 getNext()(이 함수는 데이터가 저장될 때 그 다음 bbsID를 가져오는 함수)보다 작고 bbsAvailable(1이면 존재, 0이면 삭제)가 1이고 bbsID를 내림차순으로 정렬하고 10개만 가져오는 쿼리이다.

![image](<https://user-images.githubusercontent.com/74814641/160282559-cd442204-c56c-4452-bc72-02dc8444d74a.png>)

위에 이미지를 보게되면 1페이지 임으로 해쉬맵 변수 head_list에 key값으로 1, value로는 23이 저장된다. tail_list에도 마찬가지로 key값으로 1, value로는 10이 저장된다.

![image](<https://user-images.githubusercontent.com/74814641/160282901-5b9c5fda-7c17-43ac-b894-7b43d498b95d.png>)

위에 이미지를 보게되면 2페이지 임으로 해쉬맵 변수 head_list에 key값으로 2, value로는 9가 저장된다. tail_list에도 마찬가지로 key값으로 2, value로는 1이 저장된다.

![image](<https://user-images.githubusercontent.com/74814641/160282791-09933af6-c284-40bb-a267-7bb00dedaaa1.png>)

위에 이미지는 해쉬맵에 저장된 head_list, tail_list를 가지고 데이터를 가져오는 코드이다. 이렇게 하여 페이지를 자유롭게 이동하여도 PageNumber를 key값으로 하여 해쉬맵에서 bbsID를 가져와서 데이터를 가져온다. 이렇게 하여 게시판 페이징 처리를 구현하였다.

## 페이징 처리 - 댓글

댓글에 모든 데이터를 불러와서 처리하기 보다는 현재 화면에 필요한 정보의 데이터만 가져오도록 구현하였다. 그 방법은 스크롤바가 화면 맨 아래에 닿았을 때 AJAX를 활용하여 10개의 데이터만 가져오도록 구현하였다.

![image](<https://user-images.githubusercontent.com/74814641/160283538-ca22fc79-773b-4be5-bf12-34b0741ef450.png>)

JQuery를 사용하였고 스크롤바가 화면 맨 아래에 있는지 확인하는 조건문이 있다. 그 조건을 만족한다면 AJAX를 활용하여 새로고침하지 않아도 댓글을 볼 수 있도록 하였다. replyListAction.jsp에서 전달받은 문자열을 가공처리하고 화면에 나타나는 함수이다.

![ezgif com-gif-maker](<https://user-images.githubusercontent.com/74814641/160284125-e9f5497e-5f9d-45d9-b530-44547012d7bf.gif>)

댓글 페이징 처리이다.

## BCrpyt를 이용한 중요정보 암호화

![image](<https://user-images.githubusercontent.com/74814641/160284270-c0883bcb-1573-4aff-84ce-0762d2fac544.png>)

주민등록번호, 비밀번호, 이메일 인증에 필요한 해쉬값이 암호화 되어있는 것을 볼 수 있다.

## Google Gmail API를 사용한 비밀번호 인증

<https://user-images.githubusercontent.com/74814641/160284505-35d026f9-6978-4098-be32-a4ba6dc93552.mp4>

URL 해쉬코드값과 DB에 저장된 해쉬코드값이랑 비교하여 인증을 한다.




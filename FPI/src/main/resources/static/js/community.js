const loginUserId = $('input[name="loginUserId"]').val();
const communityId = $('input[name="communityId"]').val();
// 게시글 삭제
document.getElementById('deleteBtn').addEventListener('click',function(){
    // var communityId = document.querySelector('input[name="communityId"]').value;
    // Form을 통해 POST 요청으로 서버에 삭제를 요청하도록 변경
    var form = document.createElement('form');
    form.method = 'post';
    form.action = '/community/delete/' + communityId;
    document.body.appendChild(form);
    form.submit();
})

// 게시글 좋아요
document.getElementById('like').addEventListener('click',function(){
    // var communityId = document.querySelector('input[name="communityId"]').value;
    // var loginUserId = document.querySelector('input[name="loginUserId"]').value;

    var iconColor = document.querySelector(".like-icon");
    if(iconColor.style.color ==='black'){
        iconColor.style.color ='rgb(106, 118, 133)';
    }
    else {
        iconColor.style.color ='black';
    }

    var likeForm = document.createElement('form');
    likeForm.method = 'post';
    likeForm.action = '/community/like/' + communityId;

    // input hidden으로 로그인유저아이디를 컨트롤러로 넘겨줌
    var Input = document.createElement('input');
    Input.type = 'hidden';
    Input.name = 'loginUserId';
    Input.value = loginUserId;
    likeForm.appendChild(Input);
    document.body.appendChild(likeForm);
    likeForm.submit();

})

//페이지가 처음 로드 될때 댓글 목록 조회 함수가 실행되도록 함
// ready : 제일 처음페이지 로드준비
$(document).ready(function () {

    // const communityId = $('input[name="communityId"]').val(); //j쿼리 문법
    getCommentsList(communityId); //
})
// 댓글 리스트 가져옴
function getCommentsList(communityId) {
    $.ajax({
        method : 'get',
        url : '/comments/' + communityId,
        success : function(data) {
            let commentListArea = $('.comment-list')

            // 댓글이 작성될 해당 섹션 비우기.
            commentListArea.empty();

            // 댓글 없을 때 표시할 html
            if(data.length === 0){
                commentListArea.append(
                    `<div class="alert alert-info">
                         작성된 댓글이 없습니다.
                    </div>`
                );
            }

            // 댓글 있을 때 목록을 뿌려줄 반복문.
            data.forEach(function(comment) {
                let commentDate = formatDate(comment.commentRegisterDate);
                let buttons = '';
                let editStr = '';

                // 작성일과 수정일을 비교해서 html 에 다른 모양으로 표시.
                if(comment.commentUpdateDate !== comment.commentRegisterDate){
                    commentDate = formatDate(comment.commentUpdateDate);
                    editStr = ' (수정)';
                }

                // 현재 로그인된 계정과 댓글 작성자가 동일하다면 만들어줄 버튼
                if(loginUserId === comment.userId){
                    buttons = `
                        <div class="comment-actions">
                            <button onclick="updateComment(${comment.commentId})" class="btn btn-primary">수정</button>
                            <button onclick="deleteComment(${comment.commentId})" class="btn btn-danger">삭제</button>
                        </div>
                    `
                }

                // 종합적으로 뿌려줄 html
                let commentElement = `
                    <li class="comment-item">
                        <strong class="comment-title">
                            <img alt="#" src="https://static.cdn.soomgo.com/upload/profile-default/soomgo_65.jpg?h=320&w=320&webp=1">
                            <span class="comment-nickname">인재파파</span>
                            <span class="comment-date">(2024-07-04 06:39)</span>
                        </strong>
                        <img class="delete-icon" alt="#" width="10px" height="10px" src="https://w7.pngwing.com/pngs/447/77/png-transparent-computer-icons-x-mark-symbol-check-mark-symbol-miscellaneous-cross-sign.png">
                        <button type="button" class="report-button">신고하기</button>
                        <button type="button" class="send-button">견적요청</button>
                        <div class="comment-text">
                            당기면 빠집니다 살살 땡기세요
                        </div>
                    </li>
                `
                // 해당 섹션에 댓글의 개수 만큼 차례대로 추가
                commentListArea.append(commentElement);
            })
        },
        error : function(data) {
            console.error(data, "실패");
        }
    })
}












// 날짜 포맷
function formatDate(dateString) {
    const now = new Date();
    const commentDate = new Date(dateString); // 문자열을 Date 객체로 변환

    const nowYear = now.getFullYear();
    const nowMonth = now.getMonth();
    const nowDate = now.getDate();

    const commentYear = commentDate.getFullYear();
    const commentMonth = commentDate.getMonth();
    const commentDateDate = commentDate.getDate();

    let displayText = "";

    // 년, 월, 일이 모두 같은 경우 "오늘"로 표시
    if (nowYear === commentYear && nowMonth === commentMonth && nowDate === commentDateDate) {
        displayText = "오늘";
    } else {
        // 그 외의 경우, 정해진 포맷으로 표시
        const yy = commentYear.toString().slice(-2); // 마지막 두 자리를 가지고 옴.
        const M = commentMonth + 1; // 월은 0부터 시작하므로 1을 더해줍니다.
        const d = commentDateDate;
        const HH = commentDate.getHours().toString().padStart(2, '0');
        const mm = commentDate.getMinutes().toString().padStart(2, '0'); // 두자리 수 일 때 앞에 0을 붙임.

        displayText = `${yy}년 ${M}월 ${d}일 ${HH}시 ${mm}분`;
    }
    return displayText;
}



//
//
//
// function goUpdate() {
//     if (!confirm('게시글을 수정하시겠습니까?')) {
//         return; // 사용자가 취소를 선택한 경우 아무 것도 하지 않습니다.
//     }
//
//     var communityId = document.querySelector('input[name="communityId"]').value;
//     window.location.href = '/edit/' + communityId;
// }
//
// // function goDelete() {
// //     if (confirm('게시글을 삭제하시겠습니까?')) {
// //         // 사용자가 '확인'을 선택했을 경우, 삭제 절차 진행
// //         var communityId = document.querySelector('input[name="communityId"]').value;
// //         // Form을 통해 POST 요청으로 서버에 삭제를 요청하도록 변경
// //         var form = document.createElement('form');
// //         form.method = 'post';
// //         form.action = '/community/delete/' + communityId;
// //         document.body.appendChild(form);
// //         form.submit();
// //     }
// //     // 사용자가 '취소'를 선택한 경우, 함수를 종료하고 아무것도 하지 않습니다.
// // }
//
// // 타임리프는 서버 사이드 템플릿 엔진이라서 서버에서 HTML에 랜더링 할 때 사용.
// // ajax 는 클라이언트 측에서 실행되는 친구이기 때문에 th 문법은 사용할 수 없다.
// const loginId = $('input[name="loginId"]').val();
//
// // 댓글 관련 ajax (jQuery 안에 있는 문법.)
// // 날짜 포맷
// function formatDate(dateString) {
//     const now = new Date();
//     const commentDate = new Date(dateString); // 문자열을 Date 객체로 변환
//
//     const nowYear = now.getFullYear();
//     const nowMonth = now.getMonth();
//     const nowDate = now.getDate();
//
//     const commentYear = commentDate.getFullYear();
//     const commentMonth = commentDate.getMonth();
//     const commentDateDate = commentDate.getDate();
//
//     let displayText = "";
//
//     // 년, 월, 일이 모두 같은 경우 "오늘"로 표시
//     // if (nowYear === commentYear && nowMonth === commentMonth && nowDate === commentDateDate) {
//     //     displayText = "오늘";
//     // } else {
//     // 그 외의 경우, 정해진 포맷으로 표시
//     const yy = commentYear.toString().slice(-2); // 마지막 두 자리를 가지고 옴.
//     const M = commentMonth + 1; // 월은 0부터 시작하므로 1을 더해줍니다.
//     const d = commentDateDate;
//     const HH = commentDate.getHours().toString().padStart(2, '0');
//     const mm = commentDate.getMinutes().toString().padStart(2, '0'); // 두자리 수 일 때 앞에 0을 붙임.
//
//     displayText = `(yyyy-MM-dd HH:mm)`;
//     // }
//     return displayText;
// }
//
// // 페이지가 처음 로드 될 때 댓글 목록 조회 함수가 실행되도록 한다.
// $(document).ready(function () {
//     // let boardId = document.querySelector('input[name="boardId"]').value;
//     let communityId = $('input[name="communityId"]').val();
//     getComments(communityId);
// })
//
// // 댓글 목록 조회 함수
// function getComments(communityId) {
//     $.ajax({
//         method : 'get',
//         url : '/comments/' + communityId,
//         success : function(data) {
//             let commentListArea = $('.comment-list')
//
//             // 댓글이 작성될 해당 섹션 비우기.
//             commentListArea.empty();
//
//             // 댓글 없을 때 표시할 html
//             if(data.length === 0){
//                 commentListArea.append(
//                     `<div class="alert alert-info">
//                          첫번째 댓글을 남겨주세요!
//                     </div>`
//                 );
//             }
//
//             // 댓글 있을 때 목록을 뿌려줄 반복문.
//             data.forEach(function(comment) {
//                 let commentDate = formatDate(comment.commentRegisterDate);
//                 let buttons = '';
//                 let editStr = '';
//
//                 // 작성일과 수정일을 비교해서 html 에 다른 모양으로 표시.
//                 if(comment.commentUpdateDate !== comment.commentRegisterDate){
//                     commentDate = formatDate(comment.commentUpdateDate);
//                     editStr = ' (수정)';
//                 }
//
//                 // 현재 로그인된 계정과 댓글 작성자가 동일하다면 만들어줄 버튼
//                 // 여기
//                 // 수정하기를 견적요청하기로 변경
//                 if(loginId === comment.providerId){
//                     buttons = `
//                         <div>
//                         <img class="delete-icon" alt="#" width="10px" height="10px" src="https://w7.pngwing.com/pngs/447/77/png-transparent-computer-icons-x-mark-symbol-check-mark-symbol-miscellaneous-cross-sign.png" onclick="deleteComment(${comment.commentId})">
// <!--                            <button onclick="deleteComment(${comment.commentId})" type="button" class="delete-button">삭제</button>-->
//                         </div>
//                     `
//                 }
//
//                 // 종합적으로 뿌려줄 html
//                 let commentElement = `
//                     <ul class="comment-list">
//                         <li class="comment-item id="comment-${comment.commentId}"">
//                             <strong class="comment-title">
//                                 <img alt="#" src="https://static.cdn.soomgo.com/upload/profile-default/soomgo_65.jpg?h=320&w=320&webp=1">
//                                 <span class="comment-nickname">${comment.name}</span>
//                                 <span class="comment-date">${commentDate}${editStr}</span>
//                             </strong>
//                             ${buttons}
//                             <div class="comment-text">
//                                     ${comment.commentContent}
// <!--                                당기면 빠집니다 살살 땡기세요-->
//                             </div>
//                         </li>
//                     </ul>
//                 `
//                 // 이걸 참고해서 수정
//                 // `<div class="comment-card" id="comment-${comment.commentId}">
//                 //         <div class="comment-body">
//                 //             <div class="comment-title">${comment.name}</div>
//                 //             <div class="comment-subtitle">${commentDate}${editStr}</div>
//                 //             <p class="comment-text">${comment.commentContent}</p>
//                 //             <!-- 수정, 삭제 버튼 -->
//                 //             ${buttons}
//                 //         </div>
//                 //     </div>`
//
//                 // 해당 섹션에 추가
//                 // 댓글의 갯 수 만큼 차례대로 추가될 것이다.
//                 commentListArea.append(commentElement);
//             })
//         },
//         error : function(data) {
//             console.error(data, "불러오기 실패");
//         }
//     })
// }
//
// // 댓글 추가
// function addComment(){
//     let communityId = $('input[name="communityId"]').val();
//     let commentContent = $('#commentContent').val();
//
//     // textarea 비어 있으면 경고
//     if(!commentContent){
//         alert('내용을 입력하세요!');
//         return
//     }
//
//     $.ajax({
//         method : 'post',
//         url: '/comments',
//         contentType: 'application/json',
//         data: JSON.stringify({
//             communityId: communityId,
//             commentContent: commentContent,
//             // 여기 하는 중 ctrl 눌러서 이동하기를 바람
//             providerId : loginId
//         }),
//         success : function(data) {
//             $('#commentContent').val('')
//             getComments(communityId);
//         },
//         error : function(data) {
//             console.error(data);
//         }
//     })
// }
//
// // 댓글 삭제
// function deleteComment(commentId){
//     // 매개 변수로 pk 잘 넘어왔는지 확인.
//     // alert(commentId)
//     // console.log(commentId)
//
//     if(!confirm('정말로 삭제하시겠습니까?')){
//         return;
//     }
//
//     $.ajax({
//         method : 'delete',
//         url : '/comments/' + commentId,
//         success : function(data) {
//             console.log(data, '삭제 성공')
//             getComments($('input[name="boardId"]').val());
//         },
//         error : function(data) {
//             console.error(data, '삭제 실패')
//         }
//     })
// }
//

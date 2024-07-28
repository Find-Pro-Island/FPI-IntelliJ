function enterkey(){
        saveKeyword();
}
function saveKeyword(){
    search = $('input[name="search"]').val();
    getList(1);
}
function getList(page){
    $.ajax({
        method:'get',
        url :'/user/activeList',
        data : {
            page:page,
            size:pageSize,
            search :search

        },
        success:function (data){
            //리스트 뿌려주는 함수,
            renderBoard(data.content);
            renderPagination(data);

        },
        error:function (){
            console.error('실패')
        }
    })
}
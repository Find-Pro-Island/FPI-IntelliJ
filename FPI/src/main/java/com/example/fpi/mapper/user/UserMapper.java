package com.example.fpi.mapper.user;

import com.example.fpi.domain.dto.user.*;
import com.example.fpi.domain.vo.main.CategoryListVO;
import com.example.fpi.domain.vo.user.UserVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {


//    유저가 받은 요청 갯수
    int countReceivedRequest(String userId);

//    유저가 보낸 요청 갯수
    int countSendRequest(String userId);


//  REST
    // 동적 쿼리
//    받은 요청 목록
    List<UserReceivedReqListDTO> selectReceivedReq(String userId, int startRow, int endRow, String sort);

//    보낸 요청 목록
    List<UserSendReqListDTO> selectSendReq(String userId, int startRow, int endRow, String sort);

//    유저가 보낸 요청 상세보기
    UserRequestDetailDTO selectUserReqDetail(Long userRequestId);

//    유저가 받은 리뷰 목록보기
    List<UserReviewListDTO> selectUserReview(String userId);

    //    전뭄가 찾기 동적
    List<UserUploadListDTO> selectUserUploadList(int startRow, int endRow, String search);

    //    전문가 찾기 갯수 동적
    int countUserUpload(String search);

//    유저가 올리 견적 상세보기
    UserUploadDetailDTO selectUserUploadDetail(Long userUploadId);


    //    회원정보 상세보기
    UserDTO detailUser(String userId);

    //회원 탈퇴
    void deleteUser(String userId,String userName);

    //    회원가입된 유저인지 조회
    UserDTO findByUserId(String userId);
    //    OAuth회원가입
    void saveUser(UserVO vo);
    //회원가입 폼
    void updateUser(UserVO vo);

//    전문가 탈퇴시 전문가 인증값 변경
    void editApproval(String userId);

//    유저정보 수정
    void editUser(UserVO vo);
    void editCategory(CategoryListVO vo);

}

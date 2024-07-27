package com.example.fpi.mapper.pro;

import com.example.fpi.domain.dto.certify.CardInfoDTO;
import com.example.fpi.domain.dto.certify.CardInfoFIleListDTO;
import com.example.fpi.domain.dto.certify.CardInfoFileDTO;
import com.example.fpi.domain.dto.certify.CareerInfoDTO;
import com.example.fpi.domain.dto.pro.*;
import com.example.fpi.domain.vo.certify.CardInfoFileVO;
import com.example.fpi.domain.vo.certify.CardInfoVO;
import com.example.fpi.domain.vo.certify.CareerInfoVO;
import com.example.fpi.domain.vo.main.CategoryListVO;
import com.example.fpi.domain.vo.pro.ProVO;
import com.example.fpi.domain.dto.user.UserReviewDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Mapper
public interface ProMapper {


//    전문가가 받은 요청 갯수
    int countReceivedRequest(Long proId);

//    전문가가 보낸 요청 갯수
    int countSendRequest(Long proId);


//  REST
    // 동적 쿼리
//    받은 요청 목록
    List<ProReceivedReqListDTO> selectReceivedReq(Long proId, int startRow, int endRow, String sort);

//    보낸 요청 목록
    List<ProSendReqListDTO> selectSendReq(Long proId, int startRow, int endRow, String sort);

//    전문가가 보낸 요청 상세보기
    ProRequestDetailDTO selectProReqDetail(Long proRequestId);

//    전문가가 받은 리뷰 목록 조회
    List<ProReviewListDTO> selectProReview(Long proId);


    //    <!--    마이페이지 전문가정보 상세보기-->
    ProDetailDTO detailPro(Long proId);
    List<CardInfoFileDTO> selectCardFile(Long proId);
    List<CardInfoDTO> selectCard(Long proId);

    int empCount(Long proId);

//    마이페이지 전문가 수정하기에 뿌려줌
    ProEditDTO selectEditPro(Long proId);

    void editPro(ProVO vo);
    void editCategory(CategoryListVO vo);
    void editCardInfoFile(CardInfoFileVO vo);
    void editCardInfo(CardInfoVO vo);
    void editCareerInfo(CareerInfoVO vo);


//    유저아이디를 입력받아 프로아이디 알아내기
    Long selectProId(String userId);

//    조인 없이 오직 전문가 테이블만
    ProDTO selectProInfo(Long proId);

    //    전문가 탈퇴
    void deletePro(Long proId,String proName);

    //    탈퇴시 전문가 이름필요
    String selectProName(Long proId);

//    전문가 탈퇴시 자격증사진 삭제위해 필요
//    List<CardInfoFileDTO>  cardImg(Long cardInfoId);

//    보유 자격증사진 뿌려주기위해
    List<CardInfoFileDTO> cardFileList(Long proId);




    //    요청으로 전문가 경력 가져오기
    List<ProCareerInfoListDTO> selectProCareerByReq(Long proRequestId);

    //  올린견적으로  전문가 경력 가져오기
    List<ProCareerInfoListDTO> selectProCareerByUp(Long proUploadId);

    //    전문가가 올리 견적 상세보기
    ProUploadDetailDTO selectProUploadDetail(Long proUploadId);

    //    견적 올리기
//    시퀀스 가져오기
    long getUploadSeq();

//    전문가 견적올리기 작성하기
    void saveProUpload(ProUploadDTO proUpload);

//    전뭄가 찾기 동적
    List<ProUploadListDTO> selectProUploadList(int startRow, int endRow, String search);

//    전문가 찾기 갯수 동적
    int countProUpload(String search);

    //    전문가 위치가져오기
    ProLocationDTO selectProLocation(Long proId);

    //    전문가 견적을 보고 요청 보내기
    void proRequest(ProRequestDTO proRequestDTO);

    Long checkProRequest(Long userUploadId, Long proId);

    void proWriteUserReview(UserReviewDTO userReview);

    void deleteUserRequest(Long userRequestId);

//    조인테이블에서 전문가아이디를 통해 -> 자격증관리테이블 -> 파일아이디 가져옴
//    Long selectCardFileId(Long proId);

}

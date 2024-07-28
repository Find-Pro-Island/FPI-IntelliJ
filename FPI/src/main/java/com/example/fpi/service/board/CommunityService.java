package com.example.fpi.service.board;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.board.CommunityDetailDTO;
import com.example.fpi.domain.dto.board.CommunityFileDTO;
import com.example.fpi.domain.dto.board.LikeDTO;
import com.example.fpi.domain.dto.pro.ProUploadListDTO;
import com.example.fpi.domain.oauth.CustomOAuth2User;
import com.example.fpi.domain.util.PagedResponse;
import com.example.fpi.domain.vo.board.CommunityVO;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
public interface CommunityService {

//    게시판리스트 select
PagedResponse<CommunityDTO> getCommunityList(int page, int pageSize,String search,String subject); //전체게시판,페이징
//    List<CommunityDTO> SelectBoardList(int page, int pageSize); //자유게시판
//    List<CommunityDTO> SelectProTipList(int page, int pageSize); //전문가팁



    CommunityDetailDTO getCommunityDetail(Long communityId); //게시판 상세보기


    void saveCommunity(CommunityDTO community); //게시판 작성
    void updateCommunity(CommunityDTO community); //게시판 수정

    void deleteCommunity(Long communityId); //게시판 삭제
    void selectLike(String userId,Long communityId); //게시판 좋아요기능

//    메인화면에 뿌려주는 최신 리스트
    List<CommunityDTO> maincommunityList();
}


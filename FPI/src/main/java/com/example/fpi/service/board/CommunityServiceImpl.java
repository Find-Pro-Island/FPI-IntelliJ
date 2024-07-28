package com.example.fpi.service.board;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.board.CommunityDetailDTO;
import com.example.fpi.domain.dto.board.CommunityFileDTO;
import com.example.fpi.domain.dto.board.LikeDTO;
import com.example.fpi.domain.dto.pro.ProSendReqListDTO;
import com.example.fpi.domain.oauth.CustomOAuth2User;
import com.example.fpi.domain.util.PagedResponse;
import com.example.fpi.domain.vo.board.CommunityFileVO;
import com.example.fpi.domain.vo.board.CommunityVO;
import com.example.fpi.domain.vo.board.LikeVO;
import com.example.fpi.mapper.File.FileMapper;
import com.example.fpi.mapper.board.CommunityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
public class CommunityServiceImpl implements CommunityService {

    private final CommunityMapper communityMapper;
    private final FileMapper fileMapper;


//    @Override
//    public List<CommunityDTO> SelectBoardList(int page, int pageSize) {
//        int startRow = (page - 1) * pageSize;
//        int endRow = page * pageSize;
//
//        return communityMapper.SelectBoardList(startRow, endRow);
//    }
//
//    @Override
//    public List<CommunityDTO> SelectProTipList(int page, int pageSize) {
//        int startRow = (page - 1) * pageSize;
//        int endRow = page * pageSize;
//
//        return communityMapper.SelectProTipList(startRow, endRow);
//    }

//    게시판 리스트,rest
    @Override
    public PagedResponse<CommunityDTO> getCommunityList(int page, int pageSize,String search ,String subject) {
        int startRow = (page - 1) * pageSize;
        int endRow = page * pageSize;

        int totalLists = communityMapper.countCommunity(search,subject);
        int totalPages = (int) Math.ceil((double)totalLists/pageSize);

        List<CommunityDTO> lists = communityMapper.communitySelectAll(startRow,endRow,search,subject);

        return new PagedResponse<>(lists, page, totalPages, pageSize, totalLists);
    }



//    게시판 상세페이지
    @Override
    @Transactional
    public CommunityDetailDTO getCommunityDetail(Long communityId) {
        CommunityDetailDTO community= communityMapper.selectCommunityDetail(communityId);

        return community;
    }

//    게시판 작성insert
    @Override
    public void saveCommunity(CommunityDTO community) {
        String thumnail = null;

        Long communityId = communityMapper.getSeq();
        community.setCommunityId(communityId);

    // summernote에서 이미지가 여러개 들어갔을때 첫번째 등록한 이미지만 content에서 분리하여 썸네일에 저장해줌
        // 정규표현식 패턴 설정
        String patternString = "<img\\s+src\\s*=\\s*\"([^\"]+)\"";
        Pattern pattern = Pattern.compile(patternString);

        // 정규표현식을 이용한 매칭
        Matcher matcher = pattern.matcher(community.getCommunityContent());

        // 첫 번째 img 태그의 src 속성 값 추출
        if (matcher.find()) {
            thumnail = matcher.group(1);
        } else {
            thumnail = "";
        }

        community.setCommunityThumbnail(thumnail);
        communityMapper.saveCommunity(community);
//        System.out.println(community);
    }

    @Override
    public void updateCommunity(CommunityDTO community) {

        String thumnail = community.getCommunityThumbnail();

        // summernote에서 이미지가 여러개 들어갔을때 첫번째 등록한 이미지만 content에서 분리하여 썸네일에 저장해줌
        // 정규표현식 패턴 설정
        String patternString = "<img\\s+src\\s*=\\s*\"([^\"]+)\"";
        Pattern pattern = Pattern.compile(patternString);

        // 정규표현식을 이용한 매칭
        Matcher matcher = pattern.matcher(community.getCommunityContent());

        // 첫 번째 img 태그의 src 속성 값 추출
        if (matcher.find()) {
            thumnail = matcher.group(1);
        } else {
            thumnail = "";
        }

        community.setCommunityThumbnail(thumnail);

        communityMapper.editCommunity(CommunityVO.toEntity(community));

    }



    //    게시글 삭제
    @Override
    public void deleteCommunity(Long communityId) {
        communityMapper.deleteCommunity(communityId);
    }

    @Override
    public void selectLike(String userId,Long communityId) {
        LikeDTO likeDTO = new LikeDTO();
//        해당게시글에 본인의 like가 조회된다면 해당 좋아요 취소,
        Long likeId = communityMapper.selectLike(userId,communityId);
        if(likeId == null || likeId == 0){
            likeDTO.setLikeId(communityMapper.getLikeSeq());
            likeDTO.setUserId(userId);
            likeDTO.setCommunityId(communityId);
            communityMapper.insertLike(LikeVO.toEntity(likeDTO));
        }
        else {
            communityMapper.deleteLike(likeId);
        }
        System.out.println(likeDTO);

    }

//    메인에서 보여주는 최신커뮤니티 리스트
    @Override
    public List<CommunityDTO> maincommunityList() {
        return communityMapper.communityList();
    }

}

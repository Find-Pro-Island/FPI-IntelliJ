package com.example.fpi.mapper.main;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.board.CommunityDetailDTO;
import com.example.fpi.domain.dto.pro.ProUploadListDTO;
import com.example.fpi.domain.dto.user.UserUploadListDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MainListMapper {
    List<CommunityDetailDTO> mainCommunityList(); //메인에서 뿌려주는 최근커뮤니티 리스트
    List<ProUploadListDTO> proUploadList();
    List<UserUploadListDTO> userUploadList();


}
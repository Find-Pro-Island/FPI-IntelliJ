package com.example.fpi.mapper.user;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.board.UserCommunityListDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ActiveListMapper {
//    작성한 게시글 목록
    List<UserCommunityListDTO> selectUserCommuList(String userId, int startRow, int endRow);
    int countUserCommu(String userId);
}

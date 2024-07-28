package com.example.fpi.service.user;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.board.UserCommunityListDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface ActiveService {
    List<UserCommunityListDTO> selectUserCommuList(String userId, int page, int pageSize);
    int countUserCommu(String userId);
}

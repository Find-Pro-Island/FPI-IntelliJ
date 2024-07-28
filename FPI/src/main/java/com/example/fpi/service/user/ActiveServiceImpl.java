package com.example.fpi.service.user;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.board.UserCommunityListDTO;
import com.example.fpi.mapper.user.ActiveListMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ActiveServiceImpl implements ActiveService {
    private final ActiveListMapper activeListMapper;

    @Override
    public List<UserCommunityListDTO> selectUserCommuList(String userId, int page, int pageSize) {
        int startRow = (page - 1) * pageSize;
        int endRow = page * pageSize;

        return activeListMapper.selectUserCommuList(userId,startRow,endRow);
    }

    @Override
    public int countUserCommu(String userId) {
        return activeListMapper.countUserCommu(userId);
    }
}

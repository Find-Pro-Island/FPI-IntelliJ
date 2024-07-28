package com.example.fpi.mapper.board;

import com.example.fpi.domain.dto.board.CommentListDTO;
import com.example.fpi.domain.vo.board.CommentVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CommentMapper {
//    해당 게시글의 댓글 리스트 가져오기
    List<CommentListDTO> selectCommentList(Long communityId);

//    댓글 추가
    void insertComment(CommentVO commentVO);
//    댓글수정
    void updateComment(CommentVO commentVO);

//    댓글 삭제
    void deleteComment(Long commentId);

}

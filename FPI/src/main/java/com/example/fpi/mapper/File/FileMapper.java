package com.example.fpi.mapper.File;

import com.example.fpi.domain.dto.file.ProCardInfoFileDTO;
import com.example.fpi.domain.dto.file.ProUploadFileDTO;
import com.example.fpi.domain.dto.file.UserUploadFileDTO;
import com.example.fpi.domain.vo.board.CommunityFileVO;
import com.example.fpi.domain.vo.file.ProUploadFileVO;
import com.example.fpi.domain.vo.file.UserUploadFileVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FileMapper {

    void insertProUploadFile(ProUploadFileVO proUploadFileVO);

    List<ProUploadFileDTO> selectProUploadFileList(Long proUploadId);

    void insertUserUploadFile(UserUploadFileVO userUploadFileVO);

    List<UserUploadFileDTO> selectUserUploadFileList(Long userUploadId);

    void insertSummernoteImg(CommunityFileVO communityFileVO);

    List<ProCardInfoFileDTO> selectProCardFileList(Long proId);

}

package com.example.fpi.domain.vo.board;


import com.example.fpi.domain.dto.board.CommunityDTO;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@Getter
@ToString
@NoArgsConstructor
public class CommunityVO {

    private Long communityId;
    private String subject;
    private String communityTitle;
    private String communityContent;
    private String userId;
    private String userName;
    private LocalDateTime communityRegisterDate;
    private LocalDateTime communityUpdateDate;
    private String communityThumbnail;

    @Builder
    public CommunityVO(Long communityId, String subject, String communityTitle, String communityContent,String userId,String userName, LocalDateTime communityRegisterDate, LocalDateTime communityUpdateDate, String communityThumbnail) {
        this.communityId = communityId;
        this.subject = subject;
        this.communityTitle = communityTitle;
        this.communityContent = communityContent;
        this.userId = userId;
        this.userName = userName;
        this.communityRegisterDate = communityRegisterDate;
        this.communityUpdateDate = communityUpdateDate;
        this.communityThumbnail = communityThumbnail;
    }

    public static CommunityVO toEntity(CommunityDTO communityDTO){
        return CommunityVO.builder().communityId(communityDTO.getCommunityId())
                .subject(communityDTO.getSubject())
                .communityTitle(communityDTO.getCommunityTitle())
                .communityContent(communityDTO.getCommunityContent())
                .userId(communityDTO.getUserId())
                .userName(communityDTO.getUserName())
                .communityRegisterDate(communityDTO.getCommunityRegisterDate())
                .communityUpdateDate(communityDTO.getCommunityUpdateDate())
                .communityThumbnail(communityDTO.getCommunityThumbnail())
                .build();
    }

}

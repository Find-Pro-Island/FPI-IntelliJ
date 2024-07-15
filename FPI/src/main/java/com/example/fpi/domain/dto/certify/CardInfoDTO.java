package com.example.fpi.domain.dto.certify;

import lombok.Data;
import org.springframework.stereotype.Component;

@Component
@Data
public class CardInfoDTO {
    private Long cardInfoId;
    private String certifyOrgan;
    private String certifyNumber;
    private Long proId;
}

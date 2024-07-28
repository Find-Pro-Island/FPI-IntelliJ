package com.example.fpi.controller.board;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.pro.ProReceivedReqListDTO;
import com.example.fpi.domain.util.PagedResponse;
import com.example.fpi.service.board.CommunityService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;


@RestController
@RequiredArgsConstructor
@RequestMapping
public class CommunityRestController {

    private final CommunityService communityService;
    @GetMapping("/community/list")
    public ResponseEntity<PagedResponse<CommunityDTO>> getCommunityList( @RequestParam(defaultValue = "1") int page,
                                                                         @RequestParam(defaultValue = "5") int size,
                                                                         @RequestParam String search,
                                                                         @RequestParam(defaultValue = "") String subject){

        System.out.println(search);
        System.out.println(subject);

        return ResponseEntity.ok(communityService.getCommunityList(page, size, search, subject));
    }
//    @GetMapping("/community")
//    public ResponseEntity<PagedResponse<CommunityDTO>> getCommunityList( @RequestParam(defaultValue = "1") int page,
//                                                                         @RequestParam(defaultValue = "5") int size,
//                                                                         @RequestParam(defaultValue = "") String subject){
//        return ResponseEntity.ok(communityService.getCommunityList(page, size, subject));
//    }

}

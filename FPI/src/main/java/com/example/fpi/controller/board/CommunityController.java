package com.example.fpi.controller.board;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.board.CommunityDetailDTO;
import com.example.fpi.domain.dto.board.LikeDTO;
import com.example.fpi.domain.oauth.CustomOAuth2User;
import com.example.fpi.service.board.CommunityService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class CommunityController {

    private final CommunityService communityService;

//    @GetMapping({"/community", "/freeTalk", "/proTip"})
//    public String list(@RequestParam(value = "pageNo", defaultValue = "1") int pageNo,
//                       @RequestParam(value = "pageSize", defaultValue = "5") int pageSize,
//                       Model model,
//                       HttpServletRequest request) {
//
//        String requestURI = request.getRequestURI();
//
//        int totalCommunities = communityService.getCommunityListCount();
//        int totalPages = (int) Math.ceil((double)totalCommunities/pageSize);
//
//        List<CommunityDTO> commus = communityService.getCommunityList(pageNo, pageSize);
//        List<CommunityDTO> freeTalks = communityService.SelectBoardList(pageNo, pageSize);
//        List<CommunityDTO> proTips = communityService.SelectProTipList(pageNo, pageSize);
//
//
//        int pageGroupSize = 5;
//        int startPage = ((pageNo - 1) / pageGroupSize) * pageGroupSize + 1;
//        int endPage = Math.min(startPage + pageGroupSize - 1, totalPages);
//
//        model.addAttribute("commus", commus);
//        model.addAttribute("freeTalks", freeTalks);
//        model.addAttribute("proTips", proTips);
//
//
//        model.addAttribute("currentPage", pageNo);
//        model.addAttribute("pageSize", pageSize);
//        model.addAttribute("totalPages", totalPages);
//
//        model.addAttribute("startPage", startPage);
//        model.addAttribute("endPage", endPage);
//
//        // Determine which view to return based on the request URI
//        if (requestURI.equals("/community")) {
//            return "board/community";
//        } else if (requestURI.equals("/freeTalk")) {
//
//            return "board/freeTalk";
//        } else if (requestURI.equals("/proTip")) {
//            return "board/proTip";
//        }
//
//        // Default return if no matching URI is found
//        return "board/community";
//    }

    @GetMapping("/community")
    public String list() {
        return "community/community";
    }

//    커뮤니티 게시판상세보기
    @GetMapping("/community/detail/{communityId}")
    public String detail(@PathVariable("communityId") Long communityId, Model model,
                         @AuthenticationPrincipal CustomOAuth2User customOAuth2User) {


        CommunityDetailDTO commu = communityService.getCommunityDetail(communityId);

//        로그인했다면, 그 로그인값을 detail에 넣어줌
        if(customOAuth2User != null && customOAuth2User.getUserId() != null){
            commu.setLoginUserId(customOAuth2User.getUserId());
        }

        model.addAttribute("commu", commu);
        System.out.println(commu);

//

        return "/community/detail";
    }

//    게시글 작성시 이동할 폼 지정
    @GetMapping("/community/write")
    public String writeForm(Model model, @AuthenticationPrincipal CustomOAuth2User customOAuth2User){
        CommunityDTO communityInfo = new CommunityDTO();
        communityInfo.setUserId(customOAuth2User.getUserId());
        model.addAttribute("communityInfo",communityInfo);

        return "/community/write";
    }
//게시글 수정시 가지고 이동할 정보, 폼(postmapping) 지정
    @GetMapping("/community/edit/{communityId}")
    public String goEdit(@PathVariable Long communityId,Model model, @AuthenticationPrincipal CustomOAuth2User customOAuth2User){
        CommunityDetailDTO communityInfo=communityService.getCommunityDetail(communityId);
        communityInfo.setLoginUserId(customOAuth2User.getUserId());
        model.addAttribute("communityInfo",communityInfo);

        System.out.println(model+"뭐가들어있니");

        return "/community/write";
    }

//    게시글 수정,작성
    @PostMapping("/community/write")
    public String write(CommunityDTO communityInfo,@AuthenticationPrincipal CustomOAuth2User customOAuth2User,RedirectAttributes redirectAttributes){

//       작성자와 로그인된 사람이 같다면
        if(communityInfo.getUserId().equals(customOAuth2User.getUserId())){
            communityService.updateCommunity(communityInfo);

            redirectAttributes.addFlashAttribute("msg","게시글이 수정 되었습니다.");
            return "redirect:/community/detail/" + communityInfo.getCommunityId();
        }

//        커뮤니티 글작성
//        community.setUserId(userId);
        communityService.saveCommunity(communityInfo);
        redirectAttributes.addFlashAttribute("msg","게시글이 작성 되었습니다.");

        return "redirect:/community";
    }

//    게시글 삭제
    @PostMapping("/community/delete/{communityId}")
    public String delete(@PathVariable Long communityId){
        communityService.deleteCommunity(communityId);
        return "redirect:/community";
    }

//    게시글 좋아요
    @PostMapping("/community/like/{communityId}")
    public String like(@PathVariable Long communityId, @RequestParam("loginUserId") String loginUserId){
        communityService.selectLike(loginUserId,communityId);
        System.out.println();
        return "redirect:/community/detail/{communityId}";
    }
}
